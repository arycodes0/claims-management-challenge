# Claims Management Frontend

React frontend for the Claims Management Challenge.
Provides authentication, claims listing, CSV export, and CSV import UI.

## Tech Stack

- React 19 (Vite)
- Ant Design
- Axios
- React Router DOM

## Prerequisites

- Node.js 18+
- Backend API running on `http://localhost:3000`

## Setup

```bash
npm install
npm run dev
```

The app runs on: `http://localhost:5173`

## Environment Assumptions

- Backend API base URL: `http://localhost:3000/api/v1`
- Authentication token stored in `localStorage`
- CORS enabled on backend for `http://localhost:5173`

## Features

### Authentication

- Login with email and password
- Token-based auth via `Authorization: Bearer <token>`
- Protected routes block unauthenticated access

### Claims

- View all claims in a sortable table
- Export claims as CSV

### CSV Import

- Upload CSV file with claims data
- Displays import results (processed vs failed rows)
- Duplicate claim numbers are reported as errors

## Pages

| Route | Description |
|-------|-------------|
| `/login` | Login screen |
| `/claims` | Claims list and CSV export |
| `/import` | CSV upload and import results |

## Project Structure

```
src/
  api/
    client.js          # Axios client with auth interceptor
  components/
    ProtectedRoute.jsx # Auth guard + layout
  pages/
    LoginPage.jsx
    ClaimsPage.jsx
    ImportPage.jsx
  App.jsx              # Routing
  main.jsx             # Entry point
```

## Out of Scope

The following were intentionally excluded to keep scope aligned with challenge requirements:

- TypeScript
- Redux / Zustand
- UI for patient management
- Server-side pagination
- Tests
