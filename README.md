# Things 3 API

A Rails 8.1 API-only app that wraps the [Things 3 AppleScript API](https://culturedcode.com/things/support/articles/4562654/) and [Things 3 URL Scheme](https://culturedcode.com/things/support/articles/2803573/) as RESTful JSON endpoints.

## Disclaimer

This was 99% agentic coded.
This is not secure.

## Requirements

- macOS
- Things 3 (must be running)
- Ruby 3.4+
- Rails 8.1

## Setup

```bash
bundle install
bin/rails server
```

For V2 update/import operations, set your Things 3 auth token:

```bash
export THINGS_AUTH_TOKEN="your-token-here"
```

## V1 — AppleScript API

V1 uses AppleScript via `osascript` to read and write data from Things 3.

### Discovery

```
GET /api/v1
```

### Lists

```
GET  /api/v1/lists
GET  /api/v1/lists/:name/todos
```

Built-in lists: Inbox, Today, Anytime, Upcoming, Someday, Logbook, Trash.

### To-dos

```
GET    /api/v1/todos
GET    /api/v1/todos/:id
POST   /api/v1/todos              { name, notes, tag_names, due_date, list }
PATCH  /api/v1/todos/:id          { name, notes, tag_names, due_date }
DELETE /api/v1/todos/:id
POST   /api/v1/todos/:id/move     { target_list }
POST   /api/v1/todos/:id/schedule { date }
POST   /api/v1/todos/:id/complete
POST   /api/v1/todos/:id/cancel
POST   /api/v1/todos/:id/show
POST   /api/v1/todos/:id/edit
```

### Projects

```
GET    /api/v1/projects
GET    /api/v1/projects/:id
GET    /api/v1/projects/:id/todos
POST   /api/v1/projects           { name, notes, tag_names, due_date }
PATCH  /api/v1/projects/:id       { name, notes, tag_names, due_date }
DELETE /api/v1/projects/:id
POST   /api/v1/projects/:id/complete
POST   /api/v1/projects/:id/show
```

### Areas

```
GET    /api/v1/areas
GET    /api/v1/areas/:id
GET    /api/v1/areas/:id/todos
GET    /api/v1/areas/:id/projects
POST   /api/v1/areas              { name, tag_names }
PATCH  /api/v1/areas/:id          { name, tag_names }
DELETE /api/v1/areas/:id
POST   /api/v1/areas/:id/show
```

### Tags

```
GET    /api/v1/tags
POST   /api/v1/tags               { name, parent_tag }
DELETE /api/v1/tags/:name
```

### Selected

```
GET /api/v1/selected
```

### Actions

```
POST /api/v1/empty_trash
POST /api/v1/log_completed
POST /api/v1/quick_entry          { name, notes, autofill }
```

## V2 — Hybrid CRUD API

V2 is a full CRUD API with feature parity to V1. It uses a hybrid approach:
- **URL Scheme** (`things:///command`) for creates and updates — supports richer parameters like checklist-items, prepend-notes, and creation-date
- **AppleScript** for reads, deletes, and actions — same as V1 under the hood

### Discovery

```
GET /api/v2
```

### To-dos

```
GET    /api/v2/todos
GET    /api/v2/todos/:id
POST   /api/v2/todos              { title, titles, notes, when, deadline, tags, checklist_items, list, list_id, heading, heading_id, completed, canceled, show_quick_entry, reveal, creation_date, completion_date }
PATCH  /api/v2/todos/:id          { title, notes, prepend_notes, append_notes, when, deadline, tags, add_tags, checklist_items, prepend_checklist_items, append_checklist_items, list, list_id, heading, heading_id, completed, canceled, reveal, duplicate, creation_date, completion_date } (auth required)
DELETE /api/v2/todos/:id
POST   /api/v2/todos/:id/move     { target_list }
POST   /api/v2/todos/:id/schedule { date }
POST   /api/v2/todos/:id/complete
POST   /api/v2/todos/:id/cancel
POST   /api/v2/todos/:id/show
POST   /api/v2/todos/:id/edit
```

### Projects

```
GET    /api/v2/projects
GET    /api/v2/projects/:id
GET    /api/v2/projects/:id/todos
POST   /api/v2/projects           { title, notes, when, deadline, tags, area, area_id, to_dos, completed, canceled, reveal, creation_date, completion_date }
PATCH  /api/v2/projects/:id       { title, notes, prepend_notes, append_notes, when, deadline, tags, add_tags, area, area_id, completed, canceled, reveal, duplicate, creation_date, completion_date } (auth required)
DELETE /api/v2/projects/:id
POST   /api/v2/projects/:id/complete
POST   /api/v2/projects/:id/show
```

### Areas

```
GET    /api/v2/areas
GET    /api/v2/areas/:id
GET    /api/v2/areas/:id/todos
GET    /api/v2/areas/:id/projects
POST   /api/v2/areas              { name, tag_names }
PATCH  /api/v2/areas/:id          { name, tag_names }
DELETE /api/v2/areas/:id
POST   /api/v2/areas/:id/show
```

### Tags

```
GET    /api/v2/tags
POST   /api/v2/tags               { name, parent_tag }
DELETE /api/v2/tags/:name
```

### Lists

```
GET  /api/v2/lists
GET  /api/v2/lists/:name/todos
```

### Selected

```
GET /api/v2/selected
```

### Actions

```
POST /api/v2/empty_trash
POST /api/v2/log_completed
POST /api/v2/quick_entry          { name, notes, autofill }
```

### Search

```
GET /api/v2/search?query=groceries
```

### JSON Import (auth for updates)

```
POST /api/v2/json  { data, reveal }
```

### Version

```
GET /api/v2/version
```

## V1 Examples

```bash
# List all to-dos
curl http://localhost:3000/api/v1/todos

# Get inbox items
curl http://localhost:3000/api/v1/lists/Inbox/todos

# Create a to-do
curl -X POST http://localhost:3000/api/v1/todos \
  -H "Content-Type: application/json" \
  -d '{"name":"Buy groceries","notes":"Milk, eggs, bread"}'

# Complete a to-do
curl -X POST http://localhost:3000/api/v1/todos/TASK-UUID/complete

# Move to Today
curl -X POST http://localhost:3000/api/v1/todos/TASK-UUID/move \
  -H "Content-Type: application/json" \
  -d '{"target_list":"Today"}'
```

## V2 Examples

```bash
# List all to-dos
curl http://localhost:3000/api/v2/todos

# Create a to-do with rich params
curl -X POST http://localhost:3000/api/v2/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Buy milk","checklist_items":"Whole\n2%\nOat"}'

# Update a to-do (requires THINGS_AUTH_TOKEN)
curl -X PATCH http://localhost:3000/api/v2/todos/TASK-UUID \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated title"}'

# Complete a to-do
curl -X POST http://localhost:3000/api/v2/todos/TASK-UUID/complete

# Create a project
curl -X POST http://localhost:3000/api/v2/projects \
  -H "Content-Type: application/json" \
  -d '{"title":"Shopping","to_dos":"Milk\nEggs\nBread"}'

# Search
curl http://localhost:3000/api/v2/search?query=groceries
```

## Error Responses

| Status | Meaning |
|--------|---------|
| 400 | Validation error (missing required params) |
| 401 | Auth token required (V2 update operations) |
| 404 | Resource not found |
| 422 | Execution error |
| 500 | Response parse error |
| 503 | Things 3 is not running |

## Architecture

- **V1** uses AppleScript via `osascript` — can both read and write data. Service layer in `lib/things_script/`.
- **V2** uses a hybrid approach — URL Scheme for creates/updates (richer params), AppleScript for reads/deletes/actions. Service layer in `lib/things_shortcut/` acts as a facade, delegating to `ThingsScript` for AppleScript operations.

Both versions share the same thin-controller pattern, delegating to their respective service layers. No database.

## Tests

```bash
bin/rails test
```

Tests use mock runners that return canned responses, so Things 3 does not need to be running.
