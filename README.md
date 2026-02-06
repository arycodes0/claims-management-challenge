# Claims Management Challenge

A medical center claim management system with a Rails API backend and React frontend.

## Tech Stack

- **Backend:** Ruby 3.3.6, Rails 8.1.2 (API-only), PostgreSQL
- **Frontend:** React 19 (Vite), Ant Design
- **Auth:** Token-based authentication

## Quick Start

### Prerequisites

- Ruby 3.3.6
- PostgreSQL running locally
- Node.js 18+

### Backend

```bash
cd backend
bundle install
rails db:create db:migrate db:seed
rails server
```

Runs on http://localhost:3000

### Frontend

```bash
cd frontend
npm install
npm run dev
```

Runs on http://localhost:5173

### Default Login

- **Email:** admin@example.com
- **Password:** password123

## API Endpoints

All endpoints require `Authorization: Bearer <token>` header except login.

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/login | Authenticate |
| DELETE | /api/v1/logout | Invalidate token |
| GET | /api/v1/claims | List claims |
| POST | /api/v1/claims | Create claim |
| GET | /api/v1/claims/:id | Get claim |
| PATCH | /api/v1/claims/:id | Update claim |
| DELETE | /api/v1/claims/:id | Delete claim |
| GET | /api/v1/claims/export | Export claims CSV |
| POST | /api/v1/claim_imports | Import claims CSV |
| GET | /api/v1/patients | List patients |
| POST | /api/v1/patients | Create patient |
| GET | /api/v1/patients/:id | Get patient |
| PATCH | /api/v1/patients/:id | Update patient |
| DELETE | /api/v1/patients/:id | Delete patient |

## CSV Import Format

Expected headers:

```
patient_first_name,patient_last_name,patient_dob,claim_number,service_date,amount,status
```

- Dates use `YYYY-MM-DD` format
- Status must be: `pending`, `denied`, or `paid`
- Duplicate `claim_number` values are reported as errors (not fatal)
- Existing patients (matched by name + DOB) are reused

Sample file: `backend/sample_import.csv`

## Assumptions

- **No user registration** — users created via seeds or Rails console
- **No role-based access control** — all authenticated users have full access
- **Synchronous CSV import** — suitable for small to medium files
- **Token stored in localStorage** — acceptable for this challenge
- **No server-side pagination** — client-side pagination via Ant Design
- **Claim statuses:** `pending`, `denied`, `paid` only

## Challenge Compliance

This implementation satisfies all requirements outlined in the provided
Claims Management Challenge, including authentication, CRUD APIs,
CSV import/export, and a functional React UI.
