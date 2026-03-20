# StaffSource Connect — HRMS SaaS Platform

Enterprise-grade Human Resource Management System with multi-tenant architecture.

## Architecture

| Layer | Tech | Purpose |
|-------|------|---------|
| **Backend** | NestJS + PostgreSQL + Prisma | REST API, JWT auth, RBAC, multi-tenancy |
| **Web Dashboard** | Flutter Web | HR/Admin portal — employee management, leave approvals, payslips, monitoring |
| **Mobile App** | Flutter (iOS/Android) | Employee/Manager app — punch-in, leave requests, payslips |
| **Shared** | Dart package | Data models + API client shared between both Flutter projects |

## Project Structure

```
├── backend/              NestJS Modular Monolith
│   ├── prisma/           Schema + seed script
│   └── src/modules/      identity, hr, attendance, leave, payroll
├── frontend/             Flutter Web (HR/Admin)
├── mobile/               Flutter Mobile (Employee/Manager)
└── packages/shared/      Shared Dart models + API client
```

## Quick Start

### 1. Backend

```bash
cd backend
npm install
cp .env.example .env
# Edit .env → set your DATABASE_URL (Render PostgreSQL)

npx prisma generate
npx prisma migrate dev --name init
npm run db:seed            # Seeds: admin, HR, manager, 2 employees
npm run start:dev          # http://localhost:3000/api
```

**Seed Accounts:**

| Role | Email | Password |
|------|-------|----------|
| Super Admin | admin@staffsource.com | admin123 |
| HR Admin | hr@staffsource.com | hr1234 |
| Manager | manager@staffsource.com | manager123 |
| Employee | syed@staffsource.com | employee123 |
| Employee | aisha@staffsource.com | employee123 |

### 2. Mobile App

```bash
cd mobile
flutter pub get
flutter run              # Device / emulator
```

### 3. Web Dashboard

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

## API Endpoints

| Module | Endpoint | Method | Auth |
|--------|----------|--------|------|
| Health | `/api/health` | GET | ❌ |
| Auth | `/api/auth/register` | POST | ❌ |
| Auth | `/api/auth/login` | POST | ❌ |
| Auth | `/api/auth/refresh` | POST | ❌ |
| Auth | `/api/auth/logout` | POST | ✅ |
| HR | `/api/employees` | GET | ✅ |
| HR | `/api/employees/:id` | GET/PATCH | ✅ |
| Attendance | `/api/attendance/punch-in` | POST | ✅ |
| Attendance | `/api/attendance/punch-out` | POST | ✅ |
| Attendance | `/api/attendance/today` | GET | ✅ |
| Attendance | `/api/attendance/history` | GET | ✅ |
| Attendance | `/api/attendance/team` | GET | ✅ Manager+ |
| Leave | `/api/leave-requests` | POST | ✅ |
| Leave | `/api/leave-requests/me` | GET | ✅ |
| Leave | `/api/leave-requests/balance` | GET | ✅ |
| Leave | `/api/leave-requests/team` | GET | ✅ Manager+ |
| Leave | `/api/leave-requests/:id/approve` | PATCH | ✅ Manager+ |
| Leave | `/api/leave-requests/:id/reject` | PATCH | ✅ Manager+ |
| Payroll | `/api/payslips` | POST | ✅ HR+ |
| Payroll | `/api/payslips/me` | GET | ✅ |
| Payroll | `/api/payslips/:id` | GET | ✅ |

## Roles

| Role | Mobile | Web |
|------|--------|-----|
| **Employee** | Punch-in/out, view payslips, request leaves | Self-service portal |
| **Manager** | + Approve leaves, view team attendance | + Team management |
| **HR Admin** | — | + Create payslips, manage employees |
| **Super Admin** | — | + Full access, tenant management |