# Graph Report - mark  (2026-10-15)

## Corpus Check
- 71 files · ~70,725 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 519 nodes · 692 edges · 36 communities (31 shown, 5 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f33f67ec`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MarksView.vue
- armin-dev-policies/SKILL.md
- Disk
- service.go
- Skill authoring spec
- LoginView.vue
- Handler
- devDependencies
- package.json
- compilerOptions
- Code Removal (Dead / Orphan Only)
- Code Removal (Dead / Orphan Only)
- Mark
- compilerOptions
- Workflow
- App.vue
- GitNexus — Code Intelligence
- Detect Anti-Pattern
- Reuse task procedures
- Decision cues
- Redeploy and open a PR
- REPLACE — title of the golden path
- Store
- AboutMeView.vue
- GitNexus — Code Intelligence
- tsconfig.json
- mark-api
- mark-ui
- vite-env.d.ts
- INDEX.md
- safe-refactor/SKILL.md
- vite.config.ts
- github.com/ArminDashti/mark-api

## God Nodes (most connected - your core abstractions)
1. `compilerOptions` - 17 edges
2. `Disk` - 14 edges
3. `main()` - 13 edges
4. `Handler` - 12 edges
5. `Service` - 12 edges
6. `Mark` - 12 edges
7. `markHTTPError()` - 11 edges
8. `Reuse task procedures` - 10 edges
9. `New()` - 9 edges
10. `Store` - 9 edges

## Surprising Connections (you probably didn't know these)
- `main()` --calls--> `HashPassword()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/auth/password.go
- `main()` --calls--> `New()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/handlers/handlers.go
- `main()` --calls--> `NewService()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/marks/service.go
- `main()` --calls--> `EnsureRoot()`  [INFERRED]
  mark-api/cmd/server/main.go → mark-api/internal/storage/disk.go
- `Middleware()` --calls--> `ParseToken()`  [INFERRED]
  mark-api/internal/auth/middleware.go → mark-api/internal/auth/jwt.go

## Import Cycles
- None detected.

## Communities (36 total, 5 thin omitted)

### Community 0 - "MarksView.vue"
Cohesion: 0.05
Nodes (46): emit, props, API_BASE, apiFetch(), AuthResponse, clearSession(), createMark(), deleteMark() (+38 more)

### Community 1 - "armin-dev-policies/SKILL.md"
Cohesion: 0.06
Nodes (27): Anti-pattern reference, Coupling & cohesion, Data & concurrency, Distribution, False positives (usually skip), Layering (typical clean/onion/n-tier), Structure, Core Rules & AI Behavior (+19 more)

### Community 2 - "Disk"
Cohesion: 0.10
Nodes (18): Config, HandlerFunc, main(), Middleware(), CheckPassword(), HashPassword(), envOr(), Load() (+10 more)

### Community 3 - "service.go"
Cohesion: 0.13
Nodes (25): Image, detectMIME(), extForMIME(), Context, Store, IsBadRequest(), IsConflict(), IsNotFound() (+17 more)

### Community 4 - "Skill authoring spec"
Cohesion: 0.07
Nodes (25): Example, Gotchas, Procedure, REPLACE — title of the golden path, What didn't work, When to use this, Add what the agent lacks, omit what it knows, Body content (+17 more)

### Community 5 - "LoginView.vue"
Cohesion: 0.11
Nodes (16): buttonVariants, classes, props, classes, emit, props, login(), cn() (+8 more)

### Community 6 - "Handler"
Cohesion: 0.19
Nodes (14): Claims, Handler, loginRequest, updateJSON, IssueToken(), ParseToken(), firstNonEmpty(), Context (+6 more)

### Community 7 - "devDependencies"
Cohesion: 0.09
Nodes (23): autoprefixer, devDependencies, autoprefixer, postcss, tailwindcss, tailwindcss-animate, @types/node, typescript (+15 more)

### Community 8 - "package.json"
Cohesion: 0.09
Nodes (21): class-variance-authority, clsx, @fontsource/inter, dependencies, class-variance-authority, clsx, @fontsource/inter, tailwind-merge (+13 more)

### Community 9 - "compilerOptions"
Cohesion: 0.09
Nodes (21): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+13 more)

### Community 10 - "Code Removal (Dead / Orphan Only)"
Cohesion: 0.10
Nodes (19): 1. Identify candidate targets, 2. Prove dead/orphan status (required), 3. Confirm no hidden connections, 4. Execute removal, 5. Validate and report, Code Removal (Dead / Orphan Only), Edge cases, Eligibility (all must pass) (+11 more)

### Community 11 - "Code Removal (Dead / Orphan Only)"
Cohesion: 0.11
Nodes (19): 1. Identify candidate targets, 2. Prove dead/orphan status (required), 3. Confirm no hidden connections, 4. Execute removal, 5. Validate and report, Code Removal (Dead / Orphan Only), Edge cases, Eligibility (all must pass) (+11 more)

### Community 12 - "Mark"
Cohesion: 0.25
Nodes (10): Context, DB, likeContains(), NewStore(), scanMark(), wrapConflict(), Store, Mark (+2 more)

### Community 13 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, baseUrl, noFallthroughCasesInSwitch, noUncheckedSideEffectImports, noUnusedLocals, noUnusedParameters, paths, strict (+7 more)

### Community 14 - "Workflow"
Cohesion: 0.14
Nodes (13): About Me Section, Examples, Objective, Safety rules, Step 1: Place the page, Step 2: Layout (match helix), Step 3: Write the bio (eloquent, unique), Step 4: Contact email (anti-crawl) (+5 more)

### Community 15 - "App.vue"
Cohesion: 0.24
Nodes (10): { isAuthenticated, logout }, onToggleTheme(), router, syncTheme(), theme, applyTheme(), getTheme(), initTheme() (+2 more)

### Community 16 - "GitNexus — Code Intelligence"
Cohesion: 0.17
Nodes (11): Always Do, CLI, GitNexus — Code Intelligence, lean-ctx, Learned, Never Do, Promotion rule, Resources (+3 more)

### Community 17 - "Detect Anti-Pattern"
Cohesion: 0.17
Nodes (12): Additional resources, Detect Anti-Pattern, Examples, Objective, Safety rules, Step 1: Scope, Step 2: Map structure, Step 3: Hunt by category (+4 more)

### Community 18 - "Reuse task procedures"
Cohesion: 0.17
Nodes (11): Layout, Never, Reuse task procedures, Script rules, Step 1: Search the index, Step 2: Decide whether to save it, and how, Step 3: Do the task, the way you will save it, Step 4: Follow a saved guide (+3 more)

### Community 19 - "Decision cues"
Cohesion: 0.18
Nodes (10): Architecture, Common mistakes, Consider microservices only when, Decision cues, Eventing, Policy, Prefer Clean / Hexagonal inside modules when, Prefer modular monolith when (+2 more)

### Community 20 - "Redeploy and open a PR"
Cohesion: 0.22
Nodes (8): 1. Detect Docker, 2. Rebuild + re-run (keep data), 2b. Non-Docker: close, reinstall, run, 3. Pull Request, 4. Final report, Cheat-sheet, Never, Redeploy and open a PR

### Community 21 - "REPLACE — title of the golden path"
Cohesion: 0.29
Nodes (6): Example, Gotchas, Procedure, REPLACE — title of the golden path, What didn't work, When to use this

### Community 22 - "Store"
Cohesion: 0.38
Nodes (5): Context, DB, NewStore(), User, Store

### Community 23 - "AboutMeView.vue"
Cohesion: 0.29
Nodes (6): domainParts, localPart, mailtoHref, photoOk, photoSrc, visibleEmail

### Community 24 - "GitNexus — Code Intelligence"
Cohesion: 0.33
Nodes (5): Always Do, CLI, GitNexus — Code Intelligence, Never Do, Resources

### Community 25 - "tsconfig.json"
Cohesion: 0.33
Nodes (5): compilerOptions, baseUrl, paths, files, references

### Community 26 - "mark-api"
Cohesion: 0.40
Nodes (4): Admin API, Local run, mark-api, Public URL

### Community 27 - "mark-ui"
Cohesion: 0.50
Nodes (3): Local run, mark-ui, Pages

## Knowledge Gaps
- **249 isolated node(s):** `github.com/ArminDashti/mark-api`, `loginRequest`, `updateJSON`, `name`, `private` (+244 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Service` connect `service.go` to `Disk`, `Handler`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `Mark` connect `Mark` to `service.go`?**
  _High betweenness centrality (0.012) - this node is a cross-community bridge._
- **Why does `main()` connect `Disk` to `service.go`, `Handler`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `main()` (e.g. with `Middleware()` and `HashPassword()`) actually correct?**
  _`main()` has 12 INFERRED edges - model-reasoned connections that need verification._
- **What connects `github.com/ArminDashti/mark-api`, `loginRequest`, `updateJSON` to the rest of the system?**
  _249 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MarksView.vue` be split into smaller, more focused modules?**
  _Cohesion score 0.053185271770894216 - nodes in this community are weakly interconnected._
- **Should `armin-dev-policies/SKILL.md` be split into smaller, more focused modules?**
  _Cohesion score 0.058823529411764705 - nodes in this community are weakly interconnected._