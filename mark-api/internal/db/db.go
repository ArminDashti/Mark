package db

import (
	"context"
	"database/sql"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/google/uuid"
	_ "modernc.org/sqlite"
)

// Open connects to the SQLite database file at path, creating its directory if needed.
func Open(path string) (*sql.DB, error) {
	if path == "" {
		return nil, fmt.Errorf("DATABASE_PATH is required")
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return nil, fmt.Errorf("create database dir: %w", err)
	}
	dsn := "file:" + filepath.ToSlash(path) +
		"?_pragma=foreign_keys(1)&_pragma=busy_timeout(5000)&_pragma=journal_mode(WAL)"

	db, err := sql.Open("sqlite", dsn)
	if err != nil {
		return nil, err
	}
	// SQLite allows a single writer; one connection avoids SQLITE_BUSY under concurrent requests.
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	db.SetConnMaxLifetime(0)

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := db.PingContext(ctx); err != nil {
		_ = db.Close()
		return nil, fmt.Errorf("ping database: %w", err)
	}
	return db, nil
}

// Migrate runs SQL files in migrationsDir in lexical order.
func Migrate(db *sql.DB, migrationsDir string) error {
	entries, err := os.ReadDir(migrationsDir)
	if err != nil {
		return fmt.Errorf("read migrations: %w", err)
	}
	var files []string
	for _, e := range entries {
		if e.IsDir() || !strings.HasSuffix(e.Name(), ".sql") {
			continue
		}
		files = append(files, e.Name())
	}
	sort.Strings(files)

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	for _, name := range files {
		body, err := os.ReadFile(filepath.Join(migrationsDir, name))
		if err != nil {
			return err
		}
		if _, err := db.ExecContext(ctx, string(body)); err != nil {
			return fmt.Errorf("migration %s: %w", name, err)
		}
	}
	return nil
}

// Default local/demo login account.
const (
	DefaultUsername = "armin"
	DefaultPassword = "dopadopa123"
	DefaultEmail    = "armin@local"
)

// Agent upload account for automated logo POST (mark-finder-agent-by-armin).
const (
	AgentUsername = "logo-agent"
	AgentPassword = "dopadopa123"
	AgentEmail    = "logo-agent@local"
)

// SeedDefaultUser upserts the default local login account.
func SeedDefaultUser(ctx context.Context, db *sql.DB, passwordHash string) error {
	_, err := db.ExecContext(ctx, `
		INSERT INTO users (id, email, password_hash, username)
		VALUES (?, ?, ?, ?)
		ON CONFLICT (email) DO UPDATE SET
			password_hash = excluded.password_hash,
			username = excluded.username,
			updated_at = CURRENT_TIMESTAMP
	`, uuid.NewString(), DefaultEmail, passwordHash, DefaultUsername)
	return err
}

// SeedAgentUser upserts the automated upload account.
func SeedAgentUser(ctx context.Context, db *sql.DB, username, email, passwordHash string) error {
	if strings.TrimSpace(username) == "" {
		return nil
	}
	if email == "" {
		email = username + "@local"
	}
	_, err := db.ExecContext(ctx, `
		INSERT INTO users (id, email, password_hash, username)
		VALUES (?, ?, ?, ?)
		ON CONFLICT (email) DO UPDATE SET
			password_hash = excluded.password_hash,
			username = excluded.username,
			updated_at = CURRENT_TIMESTAMP
	`, uuid.NewString(), email, passwordHash, username)
	return err
}
