# Proposal: Single Doctor Mode + Full Feature Gap Analysis

## Summary

This change adds **Single Doctor Mode** to the existing Medi-Connect hospital application and completes all missing features across Doctor, Patient, Admin, and Super Admin roles. The result is **one application supporting both Hospital Mode and Single Doctor Mode** with all four existing login roles plus a new Super Admin role.

## Background

The current application is a hospital/multi-doctor management platform built with Flutter, Supabase (PostgreSQL), Bloc/Cubit state management, GetIt DI, and Go Router. It supports four roles: **Admin**, **Doctor**, **Patient**, and **Staff**. The goal is to add a runtime configuration switch (`isSingleDoctor`) that, when enabled, allows the app to serve a single-doctor clinic without breaking existing hospital functionality.

## Architecture Overview (as found in codebase)

```
lib/
  core/
    constants/        → AppStrings, AppTableNames, EnvConfig, AppRouter, AppProviders
    dependency_injection/ → GetIt + Injectable, AppModeProvider
    routes/           → GoRouter, RouteGuards (role-based), RouteNames
    services/         → SecureStorageService, AppLogger, AdService
    network/          → SupabaseService
    theme/            → AppColors, AppTextStyles, ThemeCubit
  features/
    authentication/   → Auth Bloc, UserModel, AdminLoginPage, SignupPage, Onboarding
    common/           → Shared Booking Wizard, Slot Management, Appointment cards
    doctor/           → DoctorDashboard (Schedule/Consults/Patients/Profile tabs)
                        OpInfo (OP daily patient list), IPInfo, Procedures
    patient/          → PatientDashboard (Home/Appointments/Chat/Records/Profile)
                        Booking flow, Find Doctor, Speciality, Prescriptions, Health
    admin/            → AdminHome + 16 management modules
    staff/            → Staff dashboard + patient registration
```

**State management:** Bloc + Cubit. Registered in AppProviders (GetIt/Injectable).
**Backend:** Supabase PostgreSQL. Tables catalogued in AppTableNames (486 constants).
**Configuration:** EnvConfig with FlutterSecureStorage. isSingleDoctor + singleDoctorId already present.
**Routing:** GoRouter + role-based RouteGuards.
**Localization:** AppStrings (English only, 594 constants). No ARB/intl yet.
**Walking tokens:** Prefix-based naming in BookingWizardCubit (e.g. DRA001=normal, DRW001=walking).
**Rebooking:** Follow-up < 7 days = fee 0.0 logic in BookingWizardCubit. Fee hardcoded at 500.0 — must be replaced with RPC.
**Video/Chat:** Route names defined. No video SDK found in pubspec.
**Prescriptions:** DB tables exist. Patient-side UI is a presentation stub.
**Lab/Tests:** Admin-side exists. Doctor-side incomplete.
**MRD:** PendingMrdPage exists. Incomplete.
**Prime:** UI tabs/banners exist. Subscription logic unclear.
**Family members:** No dedicated DB table found.

## Confirmed Decisions (All Open Questions Resolved)

| # | Question | Decision |
|---|----------|----------|
| OQ-1 | Languages | English (default) + **Malayalam** + **Hindi** |
| OQ-2 | Payment gateway | **Razorpay** |
| OQ-3 | Video SDK | **Jitsi Meet** (budget-friendly, open-source) |
| OQ-4 | Super Admin | **Separate role** (`UserRole.superAdmin`) with dedicated dashboard |
| OQ-5 | Cancellation window | **24 hours** before appointment start time |
| OQ-6 | Family member booking | **New patient account** created for each family member, linked to primary patient |
| OQ-7 | Prime benefits | Free video consultations + tiered chat access (free tier: limited; prime: unlimited or expanded) |
| OQ-8 | Auto-cancellation | **Supabase Edge Function** (not pg_cron) |

## Scope Summary

### Stage 0 – Architecture & Configuration (Partially Done)
- EnvConfig.isSingleDoctor + singleDoctorId: DONE
- AppModeProvider: DONE
- DI registration + propagation: PENDING
- New UserRole.superAdmin + routing: PENDING

### Stage 1 – Localization
- AppStrings (English only) → ARB files: English + Malayalam + Hindi
- flutter_localizations integration required
- Language switcher in settings for all roles

### Stage 2 – Doctor Features
- Booking wizard (skip steps in SD mode): EXISTS partially
- Slot management (SD auto-inject): EXISTS
- Rebooking rule < 7 days (replace hardcode with RPC): PARTIAL
- Doctor profile edit: EXISTS
- Prescription create/edit/PDF: DB exists, UI MISSING
- Online consultation (Jitsi): NOT IMPLEMENTED
- MRD: PARTIAL
- Lab/Tests doctor-side: PARTIAL

### Stage 3 – Patient Features
- Booking flow (SD skip steps): EXISTS partially
- Cancellation (24hr rule): PARTIAL enforcement
- Auto-cancellation (Edge Function): NOT IMPLEMENTED
- Walking token + realtime queue: PARTIAL
- Family members (new patient accounts): NOT IMPLEMENTED
- Health records: MINIMAL stub
- Prime (video free + chat tiers): PARTIAL
- Online consultation (Jitsi patient): NOT IMPLEMENTED
- Chat realtime: PARTIAL

### Stage 4 – Admin Features
- All major admin pages exist (bookings, billing, labs, pharmacy)
- SD mode filtering, prescription download, refund UI: PENDING

### Stage 5 – Super Admin (NEW)
- Separate role from Staff
- Dedicated dashboard: NOT IMPLEMENTED
- Doctor management, hospital config, Prime plan config: NOT IMPLEMENTED

### Stage 6 – Backend Gaps
- patient_family_members table: MISSING
- consultation_sessions table: MISSING
- default_doctor_id in admin_settings: MISSING
- check_rebooking_fee RPC: MISSING
- Auto-cancel Edge Function: MISSING
- Razorpay webhook handler: MISSING

### Stage 7 – Payment (Razorpay)
- Razorpay Flutter SDK: NOT ADDED
- Order creation → payment → webhook confirmation: NOT IMPLEMENTED
- Refund API: NOT IMPLEMENTED

### Stage 8 – Notifications
- FCM/APNs integration: NOT FOUND
- Push notification Edge Function: NOT IMPLEMENTED
- Patient notification page: MISSING

### Stage 9 – Online Consultation (Jitsi)
- jitsi_meet_flutter_sdk: NOT ADDED
- Session management: NOT IMPLEMENTED
- Chat via messages table: PARTIAL (UI stub)

### Stage 10 – Testing
- No widget/integration tests found

## Constraints

- All new behaviour behind EnvConfig.isSingleDoctor flag
- Reuse existing blocs, repositories, models, services
- Follow AppStrings, AppTableNames, RouteNames conventions
- Stay with GoRouter, Bloc/Cubit, GetIt/Injectable
- Hospital mode must remain fully functional at all times
- No hardcoded doctor IDs, fees, or user-facing strings
