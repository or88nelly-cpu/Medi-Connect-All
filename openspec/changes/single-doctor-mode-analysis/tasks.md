# Implementation Tasks – Single Doctor Mode & Full Feature Completion

> Implementation order follows dependency graph. Each stage must pass regression before the next begins.
> Hospital mode (`isSingleDoctor = false`) must remain fully functional after every task.

---

## STAGE 0 – Architecture & Configuration

### TASK-CFG-001 – Register AppModeProvider in GetIt
**Role:** Common | **Priority:** Critical | **Status:** Not Started
**Current:** AppModeProvider created in `app_mode_provider.dart` but not registered in injection.config.dart.
**Required:** Register as `@lazySingleton` via Injectable. Ensure it is initialized after `EnvConfig.initialize()` in `main.dart`.
**Files:** `lib/core/dependency_injection/app_mode_provider.dart`, `lib/core/dependency_injection/injection.dart`, `lib/main.dart`
**Dependencies:** None

### TASK-CFG-002 – Propagate singleDoctorId to repositories
**Role:** Common | **Priority:** Critical | **Status:** Not Started
**Current:** Repositories receive doctorId as parameter. No automatic substitution.
**Required:** Each repository that accepts `doctorId` shall check `AppModeProvider.isSingleDoctor` and override with `singleDoctorId`.
**Files:** All repository files under `lib/features/*/data/repository/`
**Dependencies:** TASK-CFG-001

### TASK-CFG-003 – Admin settings screen: Single Doctor Mode toggle
**Role:** Admin | **Priority:** High | **Status:** Not Started
**Current:** `AdminSettingsPage` exists but has no single-doctor configuration section.
**Required:** Add toggle + doctor search/set UI. Persist via `EnvConfig`. Broadcast via `AppModeProvider`.
**Files:** `lib/features/common/dashboard/presentation/pages/admin/admin_settings_page.dart`, `AdminSettingsBloc`
**Backend:** No schema change needed (uses FlutterSecureStorage)
**Dependencies:** TASK-CFG-001

### TASK-CFG-004 – Add default_doctor_id to admin_settings table
**Role:** Backend | **Priority:** High | **Status:** Not Started
**Required:** `ALTER TABLE admin_settings ADD COLUMN IF NOT EXISTS default_doctor_id UUID REFERENCES doctors(id);`
**Files:** `migration.sql`
**Dependencies:** None

---

## STAGE 1 – Localization

### TASK-L10N-001 – Set up flutter_localizations + ARB infrastructure
**Role:** Common | **Priority:** High | **Status:** Not Started
**Current:** AppStrings class (English only, 594 constants). No ARB files.
**Required:** Add `flutter_localizations` to pubspec. Create `l10n.yaml`. Create `assets/l10n/app_en.arb` with all existing AppStrings values. Generate `AppLocalizations`.
**Files:** `pubspec.yaml`, `l10n.yaml`, `assets/l10n/app_en.arb`, `lib/main.dart`
**Dependencies:** None

### TASK-L10N-002 – Add second language ARB file
**Role:** Common | **Priority:** High | **Status:** Blocked on Open Question (language choice)
**Required:** Create `app_XX.arb` for confirmed second language. Translate all keys.
**Dependencies:** TASK-L10N-001, Open Question resolution

### TASK-L10N-003 – Language switcher in settings
**Role:** Common | **Priority:** Medium | **Status:** Not Started
**Required:** Add language selection UI in Admin, Doctor, Patient settings screens. Persist selection in SecureStorage. Apply via `LocalizationCubit`.
**Files:** Admin/Doctor/Patient settings pages, new `LocalizationCubit`
**Dependencies:** TASK-L10N-001

### TASK-L10N-004 – Localize all new feature strings
**Role:** Common | **Priority:** High | **Status:** Ongoing
**Required:** Every new string added during Stages 2–9 must be defined in ARB files, not hardcoded.
**Dependencies:** TASK-L10N-001

---

## STAGE 2 – Backend Database Gaps

### TASK-BE-001 – Create patient_family_members table
**Role:** Backend | **Priority:** High | **Status:** Not Started
**Required:**
```sql
CREATE TABLE patient_family_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  date_of_birth DATE,
  gender TEXT CHECK (gender IN ('Male','Female','Other')),
  relationship TEXT NOT NULL,
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```
**Files:** `migration.sql`
**Dependencies:** None

### TASK-BE-002 – Create consultation_sessions table
**Role:** Backend | **Priority:** High | **Status:** Not Started
**Required:** See design.md §5.3
**Files:** `migration.sql`
**Dependencies:** None

### TASK-BE-003 – Auto-cancellation pg_cron job
**Role:** Backend | **Priority:** High | **Status:** Not Started
**Required:** Schedule pg_cron every 5 min to cancel unpaid appointments within 10-minute cutoff. See design.md §5.4.
**Files:** `migration.sql` or Supabase Edge Function
**Dependencies:** None

### TASK-BE-004 – RPC: check_rebooking_fee
**Role:** Backend | **Priority:** High | **Status:** Not Started
**Required:** See design.md §5.5. Replace hardcoded 500.0 in BookingWizardCubit with RPC call.
**Files:** `migration.sql`, `booking_wizard_cubit.dart`
**Dependencies:** None

### TASK-BE-005 – Push notification Edge Function
**Role:** Backend | **Priority:** High | **Status:** Not Started
**Required:** Supabase Edge Function that reads `notification_queue` and sends FCM/APNs via Firebase Admin SDK.
**Files:** `supabase/functions/send_push/index.ts`
**Dependencies:** TASK-NOT-001

---

## STAGE 3 – Doctor Role

### TASK-DOC-001 – Skip doctor step in booking wizard (Single Doctor Mode)
**Role:** Doctor/Admin | **Priority:** Critical | **Status:** Not Started
**Current:** BookingWizardCubit has 5 steps (0=Patient, 1=Specialty, 2=Doctor, 3=Slot, 4=Confirm).
**Required:** When `isSingleDoctor = true`, skip steps 1 and 2. Auto-set selectedDoctor from singleDoctorId. Adjust step indicators accordingly.
**Files:** `booking_wizard_cubit.dart`, `doctor_step.dart`, `specialty_step.dart`, `step_indicator.dart`
**Dependencies:** TASK-CFG-001

### TASK-DOC-002 – Replace hardcoded rebooking fee with RPC
**Role:** Doctor/Common | **Priority:** High | **Status:** Not Started
**Current:** `checkFollowUpStatus()` in BookingWizardCubit queries appointments directly and hardcodes 500.0 fee.
**Required:** Call `check_rebooking_fee` RPC. Remove hardcoded 500.0. Fetch base fee from doctor profile.
**Files:** `booking_wizard_cubit.dart`
**Dependencies:** TASK-BE-004

### TASK-DOC-003 – Prescription create/edit UI (Doctor)
**Role:** Doctor | **Priority:** High | **Status:** Not Started
**Current:** `prescriptions` and `prescription_items` tables exist. No doctor-side create/edit UI found.
**Required:** Create `DoctorPrescriptionPage` with form: diagnosis, medicine list (name/dosage/frequency/duration/instructions), advice, follow-up date. Save to Supabase. Link to appointment.
**Files:** New `lib/features/doctor/op_procedures/prescription/` module
**Dependencies:** None

### TASK-DOC-004 – Prescription PDF generation
**Role:** Doctor | **Priority:** Medium | **Status:** Not Started
**Required:** Generate PDF from prescription data using existing `pdf` package. Share/download.
**Files:** New `prescription_pdf_service.dart`
**Dependencies:** TASK-DOC-003

### TASK-DOC-005 – Doctor appointment history (cancellation + rebooking)
**Role:** Doctor | **Priority:** Medium | **Status:** Not Started
**Current:** `DoctorConsultsTab` shows appointments. Cancellation/rebooking history not confirmed.
**Required:** Expand history to include cancelled/rebooked entries with reason and original date.
**Files:** `doctor_consults_tab.dart`, `DoctorAppointmentsBloc`
**Dependencies:** None

### TASK-DOC-006 – Lab order creation (Doctor-side)
**Role:** Doctor | **Priority:** Medium | **Status:** Not Started
**Current:** Admin-side lab management exists. Doctor-side lab order creation not found.
**Required:** Doctor can create `lab_orders` linked to patient + appointment. View results when available.
**Files:** New `lib/features/doctor/op_procedures/lab/` module
**Dependencies:** None

### TASK-DOC-007 – MRD completion
**Role:** Doctor | **Priority:** Medium | **Status:** Not Started
**Current:** `PendingMrdPage` exists but is incomplete.
**Required:** List pending MRD items, mark as reviewed, view patient EMR records from `emr_records` table.
**Files:** `pending_mrd_page.dart`, `PendingMrdPage`, new MRD bloc
**Dependencies:** None

### TASK-DOC-008 – Online consultation session (Doctor)
**Role:** Doctor | **Priority:** High | **Status:** Blocked on SDK decision
**Required:** Doctor can initiate/join video session. Integrated chat. Session managed via `ConsultationBloc` + Supabase RPC.
**Files:** New `lib/features/doctor/op_info/online_consultation/` module
**Dependencies:** TASK-BE-002, Open Question (SDK)

### TASK-DOC-009 – Single Doctor Mode: auto-inject doctorId in slot management
**Role:** Doctor | **Priority:** High | **Status:** Not Started
**Current:** `AdminManageSlotsPage` and `DoctorScheduleTab` require explicit doctor selection.
**Required:** When `isSingleDoctor = true`, skip doctor selection; load slots for `singleDoctorId` directly.
**Files:** `admin_manage_slots_page.dart`, `doctor_schedule_tab.dart`, slot management blocs
**Dependencies:** TASK-CFG-001

---

## STAGE 4 – Patient Role

### TASK-PAT-001 – Skip specialty + doctor steps in booking flow (Single Doctor Mode)
**Role:** Patient | **Priority:** Critical | **Status:** Not Started
**Current:** `BookingFlowPage` → `SpecialityDoctorsPage` → slot selection.
**Required:** When `isSingleDoctor = true`, navigate directly to slot selection with `singleDoctorId` pre-loaded. Hide speciality/doctor selection UI.
**Files:** `booking_flow_page.dart`, `speciality_doctors_page.dart`, `patient_booking_bottom_sheet.dart`, `patient_services_grid.dart`
**Dependencies:** TASK-CFG-001

### TASK-PAT-002 – Cancellation rule enforcement
**Role:** Patient | **Priority:** High | **Status:** Not Started
**Current:** Cancel option visible in `PatientAppointmentDetailPage`. No cutoff enforcement confirmed.
**Required:** Allow cancellation only before 23:59 of the day before. Show error message otherwise. Trigger refund on cancel of paid booking.
**Files:** `patient_appointment_detail_page.dart`, `AdminAppointmentsBloc`
**Dependencies:** None

### TASK-PAT-003 – Walking token display with realtime queue
**Role:** Patient | **Priority:** High | **Status:** Not Started
**Current:** Token number shown in appointment detail. No realtime queue position update.
**Required:** Subscribe to Supabase Realtime on `appointments` for today's doctor. Show: token number, queue position, status. Update without page refresh.
**Files:** New `TokenQueueCubit`, `patient_appointment_detail_page.dart`, `patient_appointments_tab.dart`
**Dependencies:** None

### TASK-PAT-004 – Family member CRUD
**Role:** Patient | **Priority:** High | **Status:** Not Started
**Current:** No family member feature found.
**Required:** Add/edit/remove family members in patient profile. Set default. All data in `patient_family_members` table.
**Files:** New `lib/features/patient/profile/family_member/` module, `PatientProfileTab`
**Dependencies:** TASK-BE-001

### TASK-PAT-005 – Family member selection in booking
**Role:** Patient | **Priority:** High | **Status:** Not Started
**Required:** During booking, patient selects: Self or a family member. Selected member's ID used for the appointment record.
**Files:** `booking_flow_page.dart`, `BookingWizardCubit` (patient path)
**Dependencies:** TASK-PAT-004

### TASK-PAT-006 – Patient health records expansion
**Role:** Patient | **Priority:** Medium | **Status:** Not Started
**Current:** `PatientRecordsTab` exists as a stub.
**Required:** Show: prescriptions (with PDF download), lab results, uploaded documents, consultation notes.
**Files:** `patient_records_tab.dart`, new repositories for prescriptions/labs
**Dependencies:** TASK-DOC-004

### TASK-PAT-007 – Patient prescription view + PDF download
**Role:** Patient | **Priority:** High | **Status:** Not Started
**Current:** `patient/prescriptions` directory exists (presentation stub only).
**Required:** List prescriptions linked to patient. View detail. Download PDF.
**Files:** `lib/features/patient/prescriptions/presentation/`
**Dependencies:** TASK-DOC-003, TASK-DOC-004

### TASK-PAT-008 – Prime subscription flow
**Role:** Patient | **Priority:** Medium | **Status:** Blocked on open question
**Current:** Prime tabs/banners exist. Subscription logic unclear.
**Required:** Define benefits (per open question). Implement subscription purchase flow using payment integration. Persist in `subscription` table.
**Files:** `patient_premium_tab.dart`, `patient_premium_banner.dart`, new `PrimeBloc`
**Dependencies:** TASK-PAY-001, Open Question

### TASK-PAT-009 – Patient online consultation join
**Role:** Patient | **Priority:** High | **Status:** Blocked on SDK decision
**Required:** Patient joins video from appointment detail. Chat messages in session. Notification 15 min before.
**Files:** `patient_appointment_detail_page.dart`, new `ConsultationBloc`
**Dependencies:** TASK-BE-002, TASK-DOC-008

### TASK-PAT-010 – Patient chat (realtime)
**Role:** Patient | **Priority:** Medium | **Status:** Not Started
**Current:** `PatientChatTab` exists as UI stub.
**Required:** Connect to `messages` table via Supabase Realtime. Send/receive messages scoped to doctor-patient pair.
**Files:** `patient_chat_tab.dart`, new `ChatBloc`
**Dependencies:** None

---

## STAGE 5 – Admin Role

### TASK-ADM-001 – Filter admin appointments by singleDoctorId (Single Doctor Mode)
**Role:** Admin | **Priority:** High | **Status:** Not Started
**Current:** `AdminAppointmentsPage` shows all appointments.
**Required:** When `isSingleDoctor = true`, default filter to `singleDoctorId`. Allow admin to override.
**Files:** `admin_appointments_page.dart`, `AdminAppointmentsBloc`
**Dependencies:** TASK-CFG-001

### TASK-ADM-002 – Prescription download for Admin
**Role:** Admin | **Priority:** Medium | **Status:** Not Started
**Required:** Admin can view and download prescriptions from patient detail or appointment detail.
**Files:** `admin_patients_page.dart`, `PatientRegistrationRecordDetailPage`
**Dependencies:** TASK-DOC-004

### TASK-ADM-003 – Refund UI
**Role:** Admin | **Priority:** Medium | **Status:** Not Started
**Current:** `refunds` table exists, no admin UI found.
**Required:** Admin can initiate/view refunds from `AdminBillingPage`.
**Files:** `admin_billing_page.dart`, new `RefundBloc`
**Dependencies:** None

---

## STAGE 6 – Super Admin Role

### TASK-SA-001 – Clarify Super Admin role (vs Staff)
**Role:** Super Admin | **Priority:** High | **Status:** Blocked on open question
**Required:** Determine if super-admin is a new `UserRole.superAdmin` or uses existing Staff role. Create dedicated dashboard if separate.
**Files:** `app_enum.dart`, `route_guards.dart`, new dashboard page
**Dependencies:** Open Question

### TASK-SA-002 – Super Admin doctor management
**Role:** Super Admin | **Priority:** High | **Status:** Not Started
**Required:** Create, edit, deactivate doctors. Set default doctor for single-doctor mode.
**Files:** Extend existing `admin/staff_management` or new super-admin module
**Dependencies:** TASK-SA-001

---

## STAGE 7 – Payment

### TASK-PAY-001 – Confirm and complete payment gateway integration
**Role:** Common | **Priority:** High | **Status:** Not Started
**Current:** UPI QR and pay-at-counter strings exist. No SDK found in pubspec.
**Required:** Integrate confirmed gateway (per open question). Handle success/failure callbacks. Update appointment payment_status.
**Files:** `booking_payment_confirm_page.dart`, `BookingFlowPage`, payment repository
**Dependencies:** Open Question (gateway)

### TASK-PAY-002 – Dynamic consultation fee from doctor profile
**Role:** Common | **Priority:** High | **Status:** Not Started
**Current:** Fee hardcoded as 500.0 in BookingWizardCubit.
**Required:** Fetch `consultation_fee` from `doctors` table for the selected/configured doctor.
**Files:** `booking_wizard_cubit.dart`, doctor repository
**Dependencies:** TASK-BE-004

### TASK-PAY-003 – Refund initiation on cancellation
**Role:** Common | **Priority:** Medium | **Status:** Not Started
**Required:** On appointment cancellation (paid), create `refunds` record. Trigger refund via payment gateway API.
**Files:** Appointment cancellation logic, new RefundRepository
**Dependencies:** TASK-PAY-001

---

## STAGE 8 – Notifications

### TASK-NOT-001 – Add firebase_messaging to pubspec
**Role:** Common | **Priority:** High | **Status:** Not Started
**Required:** Add `firebase_messaging`, `firebase_core`. Configure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS). Register device token in `user_devices` table.
**Files:** `pubspec.yaml`, `main.dart`, `android/app/`, `ios/Runner/`
**Dependencies:** Firebase project setup

### TASK-NOT-002 – Push notification handler in app
**Role:** Common | **Priority:** High | **Status:** Not Started
**Required:** Handle foreground/background/terminated notifications. Route to appropriate screen on tap (appointment detail, token display, etc.).
**Files:** `main.dart`, new `NotificationService`
**Dependencies:** TASK-NOT-001, TASK-BE-005

### TASK-NOT-003 – In-app notification page for Patient
**Role:** Patient | **Priority:** Medium | **Status:** Not Started
**Current:** `AdminNotificationsPage` exists for admin. No patient notification page.
**Required:** Patient notification list from `notifications` table, scoped to patient_id.
**Files:** New `patient_notifications_page.dart`
**Dependencies:** None

---

## STAGE 9 – Online Consultation

### TASK-OC-001 – Select and integrate video SDK
**Role:** Common | **Priority:** High | **Status:** Blocked on Open Question
**Required:** Add SDK to pubspec (e.g., `agora_rtc_engine` or `jitsi_meet_flutter_sdk`). Create `ConsultationService`.
**Files:** `pubspec.yaml`, new `ConsultationService`
**Dependencies:** Open Question

### TASK-OC-002 – ConsultationBloc
**Role:** Common | **Priority:** High | **Status:** Not Started
**Required:** Manage: session creation (via Supabase RPC), token retrieval, connection state, chat stream, session end.
**Files:** New `lib/features/common/consultation/bloc/consultation_bloc.dart`
**Dependencies:** TASK-BE-002, TASK-OC-001

### TASK-OC-003 – Doctor consultation screen
**Role:** Doctor | **Priority:** High | **Status:** Not Started
**Required:** Video feed + chat panel + session controls (mute, end).
**Files:** New `lib/features/doctor/op_info/online_consultation/doctor_consultation_page.dart`
**Dependencies:** TASK-OC-002

### TASK-OC-004 – Patient consultation screen
**Role:** Patient | **Priority:** High | **Status:** Not Started
**Required:** Join video session, chat, leave session.
**Files:** New `lib/features/patient/booking/presentation/pages/patient_consultation_page.dart`
**Dependencies:** TASK-OC-002

---

## STAGE 10 – Testing & Regression

### TASK-TST-001 – Unit tests: AppModeProvider + EnvConfig
**Role:** QA | **Priority:** High | **Status:** Not Started
**Files:** `test/core/dependency_injection/app_mode_provider_test.dart`
**Dependencies:** TASK-CFG-001

### TASK-TST-002 – Unit tests: BookingWizardCubit (both modes)
**Role:** QA | **Priority:** High | **Status:** Not Started
**Required:** Test step skipping in single-doctor mode. Test rebooking fee calculation via mocked RPC.
**Files:** `test/features/common/dashboard/booking_wizard_cubit_test.dart`
**Dependencies:** TASK-DOC-001, TASK-DOC-002

### TASK-TST-003 – Widget tests: booking flow (hospital vs single-doctor)
**Role:** QA | **Priority:** High | **Status:** Not Started
**Files:** `test/features/patient/booking/`
**Dependencies:** TASK-PAT-001

### TASK-TST-004 – Widget tests: cancellation cutoff enforcement
**Role:** QA | **Priority:** High | **Status:** Not Started
**Dependencies:** TASK-PAT-002

### TASK-TST-005 – Integration tests: end-to-end booking both modes
**Role:** QA | **Priority:** High | **Status:** Not Started
**Dependencies:** All Stage 3 tasks

### TASK-TST-006 – Regression: hospital mode after each stage
**Role:** QA | **Priority:** Critical | **Status:** Ongoing
**Required:** After each stage merged, run smoke test with `isSingleDoctor = false`. Verify all existing pages load and booking flow works unchanged.

---

## Dependency-Based Implementation Sequence

```
TASK-CFG-001 (AppModeProvider DI)
  ↓
TASK-CFG-002 (Repo propagation)   TASK-BE-001..005 (DB migrations)
  ↓                                        ↓
TASK-L10N-001 (ARB setup)         TASK-BE-004 (RPC rebooking fee)
  ↓                                        ↓
TASK-DOC-001 (Wizard SD mode)    TASK-DOC-002 (Fee from RPC)
  ↓
TASK-PAT-001 (Patient booking SD mode)
TASK-PAT-004 (Family members)
  ↓
TASK-PAT-005 (Family in booking)
TASK-DOC-003 (Prescription create)
  ↓
TASK-DOC-004 (Prescription PDF)
TASK-PAT-007 (Patient prescription view)
  ↓
TASK-NOT-001 (Firebase setup)
TASK-BE-005 (Edge Function push)
  ↓
TASK-NOT-002 (In-app notification handler)
TASK-PAT-002 (Cancellation rule)
TASK-PAT-003 (Token realtime)
  ↓
TASK-PAY-001 (Payment gateway)    [Open Question resolved]
TASK-OC-001  (Video SDK)          [Open Question resolved]
  ↓
TASK-OC-002 (ConsultationBloc)
TASK-OC-003 (Doctor UI)
TASK-OC-004 (Patient UI)
  ↓
TASK-TST-001..006 (Tests + Regression)
```

---

## Open Questions (must resolve before dependent tasks)

| # | Question | Blocks |
|---|----------|--------|
| OQ-1 | Languages beyond English? | TASK-L10N-002 |
| OQ-2 | Payment gateway: Razorpay / Stripe / UPI static only? | TASK-PAY-001 |
| OQ-3 | Video SDK: Agora / Jitsi / WebRTC? | TASK-OC-001 |
| OQ-4 | Super Admin: separate role or Staff role? | TASK-SA-001 |
| OQ-5 | Cancellation: calendar day or 24 hours? | TASK-PAT-002 |
| OQ-6 | Family booking: linked record or new patient account? | TASK-PAT-004 |
| OQ-7 | Prime benefits list? | TASK-PAT-008 |
| OQ-8 | Auto-cancel enforcement: pg_cron or Edge Function? | TASK-BE-003 |
