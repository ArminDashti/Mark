package marks

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"github.com/ArminDashti/mark-api/internal/models"
)

// ErrNotFound is returned when a mark does not exist.
var ErrNotFound = errors.New("mark not found")

// ErrConflict is returned on unique (kind, slug) collisions.
var ErrConflict = errors.New("mark already exists")

// sqliteConstraintUnique is SQLITE_CONSTRAINT_UNIQUE (extended result code).
const sqliteConstraintUnique = 2067

// Store persists marks in SQLite.
type Store struct {
	db *sql.DB
}

// NewStore creates a Store.
func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

const markCols = `id, kind, slug, name, original_path, original_mime, width, height, has_alpha, created_at, updated_at`

func scanMark(row interface {
	Scan(dest ...any) error
}) (*models.Mark, error) {
	var m models.Mark
	if err := row.Scan(
		&m.ID, &m.Kind, &m.Slug, &m.Name, &m.OriginalPath, &m.OriginalMIME,
		&m.Width, &m.Height, &m.HasAlpha, &m.CreatedAt, &m.UpdatedAt,
	); err != nil {
		return nil, err
	}
	return &m, nil
}

// GetByID loads a mark by id.
func (s *Store) GetByID(ctx context.Context, id string) (*models.Mark, error) {
	m, err := scanMark(s.db.QueryRowContext(ctx, `SELECT `+markCols+` FROM marks WHERE id = ?`, id))
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNotFound
	}
	return m, err
}

// GetByKindSlug loads a mark by kind and slug.
func (s *Store) GetByKindSlug(ctx context.Context, kind, slug string) (*models.Mark, error) {
	m, err := scanMark(s.db.QueryRowContext(ctx, `
		SELECT `+markCols+` FROM marks WHERE kind = ? AND slug = ?
	`, kind, slug))
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNotFound
	}
	return m, err
}

// List returns marks, optionally filtered by kind and a name/slug search, newest first.
func (s *Store) List(ctx context.Context, kind, q string) ([]models.Mark, error) {
	var (
		rows *sql.Rows
		err  error
	)
	like := likeContains(q)
	switch {
	case kind == "" && q == "":
		rows, err = s.db.QueryContext(ctx, `SELECT `+markCols+` FROM marks ORDER BY updated_at DESC`)
	case kind != "" && q == "":
		rows, err = s.db.QueryContext(ctx, `
			SELECT `+markCols+` FROM marks WHERE kind = ? ORDER BY updated_at DESC
		`, kind)
	case kind == "" && q != "":
		rows, err = s.db.QueryContext(ctx, `
			SELECT `+markCols+` FROM marks
			WHERE name LIKE ? ESCAPE '\' OR slug LIKE ? ESCAPE '\'
			ORDER BY updated_at DESC
		`, like, like)
	default:
		rows, err = s.db.QueryContext(ctx, `
			SELECT `+markCols+` FROM marks
			WHERE kind = ? AND (name LIKE ? ESCAPE '\' OR slug LIKE ? ESCAPE '\')
			ORDER BY updated_at DESC
		`, kind, like, like)
	}
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	out := make([]models.Mark, 0)
	for rows.Next() {
		m, err := scanMark(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, *m)
	}
	return out, rows.Err()
}

// Insert creates a mark row.
func (s *Store) Insert(ctx context.Context, m *models.Mark) (*models.Mark, error) {
	created, err := scanMark(s.db.QueryRowContext(ctx, `
		INSERT INTO marks (id, kind, slug, name, original_path, original_mime, width, height, has_alpha)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
		RETURNING `+markCols, m.ID, m.Kind, m.Slug, m.Name, m.OriginalPath, m.OriginalMIME, m.Width, m.Height, m.HasAlpha))
	if err != nil {
		return nil, wrapConflict(err)
	}
	return created, nil
}

// Update saves metadata and original fields.
func (s *Store) Update(ctx context.Context, m *models.Mark) (*models.Mark, error) {
	updated, err := scanMark(s.db.QueryRowContext(ctx, `
		UPDATE marks SET
			kind = ?,
			slug = ?,
			name = ?,
			original_path = ?,
			original_mime = ?,
			width = ?,
			height = ?,
			has_alpha = ?,
			updated_at = CURRENT_TIMESTAMP
		WHERE id = ?
		RETURNING `+markCols,
		m.Kind, m.Slug, m.Name, m.OriginalPath, m.OriginalMIME, m.Width, m.Height, m.HasAlpha, m.ID))
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, wrapConflict(err)
	}
	return updated, nil
}

// Delete removes a mark row.
func (s *Store) Delete(ctx context.Context, id string) error {
	res, err := s.db.ExecContext(ctx, `DELETE FROM marks WHERE id = ?`, id)
	if err != nil {
		return err
	}
	n, err := res.RowsAffected()
	if err != nil {
		return err
	}
	if n == 0 {
		return ErrNotFound
	}
	return nil
}

func likeContains(q string) string {
	q = strings.TrimSpace(q)
	replacer := strings.NewReplacer(`\`, `\\`, `%`, `\%`, `_`, `\_`)
	return "%" + replacer.Replace(q) + "%"
}

func wrapConflict(err error) error {
	var sqliteErr interface{ Code() int }
	if errors.As(err, &sqliteErr) && sqliteErr.Code() == sqliteConstraintUnique {
		return fmt.Errorf("%w: kind and slug must be unique", ErrConflict)
	}
	return err
}
