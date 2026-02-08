# Things 3 API

A Rails 8.1 API-only app that wraps the Things 3 AppleScript API as RESTful JSON endpoints.

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

## Endpoints

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

## Examples

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

## Error Responses

| Status | Meaning |
|--------|---------|
| 400 | Validation error (missing required params) |
| 404 | Resource not found |
| 422 | AppleScript execution error |
| 500 | Response parse error |
| 503 | Things 3 is not running |

## Architecture

All interaction with Things 3 uses AppleScript via `osascript`. The service layer in `lib/things_script/` builds AppleScript commands, executes them through a Runner, and parses the JSON responses. No direct database access.

## Tests

```bash
bin/rails test
```

Tests use a MockRunner that returns canned responses, so Things 3 does not need to be running.
