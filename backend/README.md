# Claims Management API

Rails API backend for a medical center claims management system.

This project is part of a technical coding challenge and is intended for local development and evaluation purposes only.

---

## Tech Stack

- Ruby 3.3.6
- Rails 8.1.2 (API-only)
- PostgreSQL

---

## System Requirements

- Ruby 3.3.6
- PostgreSQL running locally

---

## Setup

From the `backend/` directory:

```bash
bundle install
rails db:create
rails db:migrate
rails db:seed
```

CORS is configured to allow requests from `http://localhost:5173`.

## Running the Server

```bash
rails server
```

Runs on `http://localhost:3000`

---

## Default Credentials

- **Email:** admin@example.com
- **Password:** password123

---

## API Endpoints

All endpoints are under `/api/v1` and require `Authorization: Bearer <token>` except login.

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/login | Authenticate and receive token |
| DELETE | /api/v1/logout | Invalidate token |

Tokens are generated on login and invalidated on logout.

### Claims

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/claims | List all claims |
| POST | /api/v1/claims | Create a claim |
| GET | /api/v1/claims/:id | Get a claim |
| PATCH | /api/v1/claims/:id | Update a claim |
| DELETE | /api/v1/claims/:id | Delete a claim |
| GET | /api/v1/claims/export | Export claims as CSV |

### Patients

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/patients | List all patients |
| POST | /api/v1/patients | Create a patient |
| GET | /api/v1/patients/:id | Get a patient with claims |
| PATCH | /api/v1/patients/:id | Update a patient |
| DELETE | /api/v1/patients/:id | Delete a patient |

### CSV Import

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/claim_imports | Import claims from CSV |
| GET | /api/v1/claim_imports | List all imports |
| GET | /api/v1/claim_imports/:id | Get import details |

---

## Database Schema

### Users

| Column | Type | Notes |
|--------|------|-------|
| email | string | unique, required |
| password_digest | string | bcrypt hash |
| role | string | default: "staff" |
| authentication_token | string | unique, nullable |

### Patients

| Column | Type | Notes |
|--------|------|-------|
| first_name | string | required |
| last_name | string | required |
| dob | date | nullable |

Unique constraint on `[first_name, last_name, dob]`

### Claims

| Column | Type | Notes |
|--------|------|-------|
| patient_id | reference | required |
| claim_import_id | reference | nullable |
| claim_number | string | unique, required |
| service_date | date | required |
| amount | decimal(10,2) | required |
| status | string | pending, denied, paid |

### ClaimImports

| Column | Type | Notes |
|--------|------|-------|
| file_name | string | required |
| total_records | integer | default: 0 |
| processed_records | integer | default: 0 |
| status | string | pending, processing, completed, failed |

---

## CSV Import Format

Expected headers:

```
patient_first_name,patient_last_name,patient_dob,claim_number,service_date,amount,status
```

- Dates use `YYYY-MM-DD` format
- Status must be: `pending`, `denied`, or `paid`
- Duplicate `claim_number` values are reported as row errors (import continues)
- Existing patients (matched by first_name + last_name + dob) are reused

Sample file: `sample_import.csv`

---

## Out of Scope

The following were intentionally excluded to keep scope aligned with challenge requirements:

- User registration endpoint
- Role-based authorization
- Background job processing for CSV import
- Server-side pagination
- Docker / deployment configuration
- Automated tests (omitted due to time constraints of the challenge)
