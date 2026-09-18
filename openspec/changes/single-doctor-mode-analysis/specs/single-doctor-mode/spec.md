# Spec: Single Doctor Mode – Full Feature Specification

## Purpose

Define every behavioural requirement for the Medi-Connect application operating in both Hospital Mode (`isSingleDoctor = false`) and Single Doctor Mode (`isSingleDoctor = true`), covering all four roles and all functional areas.

---

## STAGE 0 – Architecture & Configuration

### REQ-CFG-001
The application shall expose a runtime boolean `EnvConfig.isSingleDoctor` (default: `false`) stored in `FlutterSecureStorage` under key `SINGLE_DOCTOR_MODE`.

### REQ-CFG-002
The application shall expose a runtime string `EnvConfig.singleDoctorId` stored in `FlutterSecureStorage` under key `SINGLE_DOCTOR_ID`.

### REQ-CFG-003
When `isSingleDoctor = false`, the entire existing hospital multi-doctor workflow shall remain unchanged.

### REQ-CFG-004
When `isSingleDoctor = true`, `singleDoctorId` shall be used automatically in place of any user-selected doctor ID across: slots, bookings, payments, rebooking, prescriptions, history, online consultation, tests, MRD, doctor profile, consultation charge, and walking tokens.

### REQ-CFG-005
`AppModeProvider` shall be registered in GetIt as a lazy singleton and expose `isSingleDoctor` and `singleDoctorId` synchronously after `EnvConfig.initialize()`.

### REQ-CFG-006
All repositories that accept a `doctorId` parameter shall check `AppModeProvider.isSingleDoctor` and substitute `singleDoctorId` when true, without breaking existing call sites that pass an explicit ID.

### REQ-CFG-007
Super Admin / Admin shall be able to toggle `isSingleDoctor` and configure `singleDoctorId` from a settings screen, persisting via `EnvConfig`.

---

## STAGE 1 – Localization

### REQ-L10N-001
The application shall support a minimum of two languages: **English** (default) and at least one additional language (to be confirmed via open question).

### REQ-L10N-002
All user-facing strings shall be defined in ARB files (e.g., `app_en.arb`, `app_XX.arb`) and accessed via the generated `AppLocalizations` class.

### REQ-L10N-003
The existing `AppStrings` class shall be kept for backward compatibility but new strings added for Single Doctor Mode features shall be defined in ARB files.

### REQ-L10N-004
A language selector shall be available in the settings screens for Admin, Doctor, and Patient roles.

### REQ-L10N-005
All status values (appointment status, payment status, token status), error messages, dialogs, validation messages, and notification text shall be localized.

### REQ-L10N-006
API-provided text (e.g., doctor names, speciality labels) is excluded from localization unless translated server-side.

---

## STAGE 2 – Doctor Role

### 2.1 Booking (Doctor-Initiated)

#### REQ-DOC-BK-001
Doctor shall be able to initiate a booking from their dashboard by selecting an existing patient via search.

#### REQ-DOC-BK-002
Doctor shall be able to create a new patient record inline during the booking flow.

#### REQ-DOC-BK-003
Doctor shall be able to choose an available slot from the day's schedule.

#### REQ-DOC-BK-004
Doctor shall be able to confirm payment status (paid / unpaid / pay-at-counter) on the booking.

#### REQ-DOC-BK-005
Doctor shall be able to cancel a booking from the appointment detail view.

#### REQ-DOC-BK-006
In Single Doctor Mode, the doctor selection step of the booking wizard shall be skipped; `singleDoctorId` shall be used automatically.

#### REQ-DOC-BK-007
Walking token bookings shall be managed separately from normal slot bookings.

### 2.2 Slot Management

#### REQ-DOC-SL-001
Doctor shall be able to view their slots day-by-day via a date picker strip.

#### REQ-DOC-SL-002
Doctor shall be able to create a new slot specifying time, type (normal/walking), and capacity.

#### REQ-DOC-SL-003
Doctor shall be able to edit an existing slot's time or capacity.

#### REQ-DOC-SL-004
Doctor shall be able to delete an unbooked slot.

#### REQ-DOC-SL-005
Doctor shall be able to enable or disable a slot without deleting it.

#### REQ-DOC-SL-006
Doctor shall see real-time booking count per slot (normal and waiting/walking).

#### REQ-DOC-SL-007
In Single Doctor Mode, slot management shall automatically use `singleDoctorId`; no doctor selection is required.

### 2.3 Rebooking

#### REQ-DOC-RB-001
If the new appointment date is within 7 calendar days of the previous appointment date for the same patient-doctor pair, the rebooking shall be treated as a follow-up with zero consultation fee.

#### REQ-DOC-RB-002
If the new date is more than 7 days from the previous appointment, the standard consultation fee shall apply.

#### REQ-DOC-RB-003
Rebooking business logic shall reside in the repository/use-case layer, not in UI widgets.

#### REQ-DOC-RB-004
Both Doctor and Patient rebooking shall follow the same fee rule (REQ-DOC-RB-001 and REQ-DOC-RB-002).

### 2.4 Doctor Profile Edit

#### REQ-DOC-PR-001
Doctor shall be able to edit: name, profile photo, qualification, specialization, experience (years), consultation charge, clinic/hospital details, contact information, and consultation timings.

#### REQ-DOC-PR-002
Profile photo shall be uploaded to Supabase Storage bucket `medi_connect_store`.

#### REQ-DOC-PR-003
Changes to consultation charge shall propagate to new bookings (existing bookings unaffected).

### 2.5 Appointment History

#### REQ-DOC-HI-001
Doctor shall be able to view a paginated list of all past appointments filtered by: date range, patient name, status (completed/cancelled/rebooked).

#### REQ-DOC-HI-002
Doctor shall be able to view individual patient consultation history from the appointment detail.

#### REQ-DOC-HI-003
Cancellation and rebooking events shall appear in history.

### 2.6 Prescription

#### REQ-DOC-RX-001
Doctor shall be able to create a prescription linked to a specific appointment and patient.

#### REQ-DOC-RX-002
Prescription shall include: diagnosis, medicines (name, dosage, frequency, duration, instructions), advice, follow-up date.

#### REQ-DOC-RX-003
Doctor shall be able to view and edit a prescription within a configurable time window after creation.

#### REQ-DOC-RX-004
Doctor shall be able to generate a PDF of the prescription (using the existing `pdf` package).

#### REQ-DOC-RX-005
Patient shall be able to view (read-only) their own prescriptions.

### 2.7 Online Consultation

#### REQ-DOC-OC-001
Doctor shall be able to initiate or join a video consultation session for a confirmed online appointment.

#### REQ-DOC-OC-002
Doctor shall be able to send and receive chat messages within the consultation session.

#### REQ-DOC-OC-003
The video provider (Agora/Jitsi/WebRTC) shall be selected based on open question resolution.

#### REQ-DOC-OC-004
Session creation, token generation, and expiry shall be managed server-side (Supabase Edge Function or RPC).

#### REQ-DOC-OC-005
Consultation status (waiting/active/completed) shall be visible on the doctor dashboard.

### 2.8 MRD (Medical Record Department)

#### REQ-DOC-MRD-001
Doctor shall be able to view pending MRD items from the `PendingMrdPage`.

#### REQ-DOC-MRD-002
Doctor shall be able to access a patient's complete medical record: EMR records, documents, previous consultations, reports.

#### REQ-DOC-MRD-003
Doctor shall be able to mark MRD items as reviewed.

### 2.9 Lab / Tests

#### REQ-DOC-LB-001
Doctor shall be able to create a lab order (test request) linked to a patient and appointment.

#### REQ-DOC-LB-002
Doctor shall be able to view test results when available.

#### REQ-DOC-LB-003
Doctor shall receive an in-app notification when test results are ready.

---

## STAGE 3 – Patient Role

### 3.1 Booking Flow

#### REQ-PAT-BK-001 – Hospital Mode
```
Patient → Select Speciality → Select Doctor → View Available Slots → Select Slot → Payment → Confirmation
```

#### REQ-PAT-BK-002 – Single Doctor Mode
```
Patient → View Available Slots (singleDoctorId pre-set) → Select Slot → Payment → Confirmation
```
Doctor selection step shall not be shown when `isSingleDoctor = true`.

#### REQ-PAT-BK-003
Patient shall be able to select a family member for whom the booking is made.

#### REQ-PAT-BK-004
Walking token option shall be presented where the selected slot supports walking patients.

#### REQ-PAT-BK-005
After successful payment (or pay-at-counter selection), a booking confirmation screen shall be shown with appointment summary and token number.

### 3.2 Cancellation

#### REQ-PAT-CA-001
Patient may cancel an appointment up to 23:59 of the calendar day before the appointment date.

#### REQ-PAT-CA-002
Cancellation within the allowed window shall trigger a refund initiation (where payment was made online).

#### REQ-PAT-CA-003
Cancellation outside the allowed window shall be blocked with an appropriate message.

### 3.3 Unpaid Booking Auto-Cancellation

#### REQ-PAT-AC-001
If a booking's payment status remains `unpaid` and the appointment is within 10 minutes of its scheduled start, the booking shall be automatically cancelled.

#### REQ-PAT-AC-002
Auto-cancellation shall be enforced via a Supabase scheduled function (pg_cron or Edge Function), not client-side only.

#### REQ-PAT-AC-003
Patient shall receive a push notification when their booking is auto-cancelled.

#### REQ-PAT-AC-004
Cancelled slot shall become available for rebooking.

### 3.4 Walking Token Assignment

#### REQ-PAT-WT-001
Walking tokens shall be assigned in order of payment completion timestamp (first-paid = first token).

#### REQ-PAT-WT-002
Token format: `<DoctorInitials>W<sequence>` (e.g., `JDW001`).

#### REQ-PAT-WT-003
Maximum walking patient capacity per day/session shall be configurable per slot.

### 3.5 Token Display

#### REQ-PAT-TD-001
Patient shall see their token number on the appointment detail and dashboard.

#### REQ-PAT-TD-002
Patient shall see total queue count and their position.

#### REQ-PAT-TD-003
Token status (waiting/called/completed) shall update in near real-time via Supabase realtime subscription.

### 3.6 Health Records

#### REQ-PAT-HR-001
Patient shall be able to view their complete medical history: consultations, prescriptions, lab results, documents.

#### REQ-PAT-HR-002
Patient shall be able to download a PDF of any prescription.

#### REQ-PAT-HR-003
Patient shall be able to view uploaded medical documents.

### 3.7 Prime Subscription

#### REQ-PAT-PRM-001
Prime subscription shall unlock benefits (to be confirmed via open question).

#### REQ-PAT-PRM-002
Subscription payment shall follow the same payment flow as appointment payment.

#### REQ-PAT-PRM-003
Prime status shall be persisted in the `subscription` table and checked at login.

### 3.8 Online Consultation (Patient)

#### REQ-PAT-OC-001
Patient shall be able to join a video consultation from their appointment detail or appointments tab.

#### REQ-PAT-OC-002
Patient shall be able to send/receive chat messages.

#### REQ-PAT-OC-003
Patient shall receive a reminder notification before the consultation start time.

### 3.9 History

#### REQ-PAT-HI-001
Patient shall be able to view all past appointments with status (completed/cancelled/rebooked).

#### REQ-PAT-HI-002
History shall include: date, doctor name, speciality, fee paid, prescription availability.

### 3.10 Rebooking (Patient)

Follows same rule as REQ-DOC-RB-001 through REQ-DOC-RB-004.

### 3.11 Profile & Family Members

#### REQ-PAT-FM-001
Patient shall be able to add family members with: name, date of birth, gender, relationship.

#### REQ-PAT-FM-002
Patient shall be able to edit and remove family members.

#### REQ-PAT-FM-003
Patient shall be able to set a default profile (self or a family member) for bookings.

#### REQ-PAT-FM-004
Booking flow shall allow selection of self or any registered family member.

#### REQ-PAT-FM-005
Family member health records shall be scoped to that member.

---

## STAGE 4 – Admin Role

### REQ-ADM-BK-001
Admin shall be able to view all bookings with filters (date, doctor, status, payment).

### REQ-ADM-BK-002
Admin shall be able to create bookings on behalf of patients using the existing booking wizard.

### REQ-ADM-BK-003
Admin shall be able to cancel a booking and trigger refund workflow.

### REQ-ADM-BK-004
Admin shall be able to manage walking-token bookings (assign, remove, update status).

### REQ-ADM-RB-001
Admin shall be able to view and process rebooking requests.

### REQ-ADM-RX-001
Admin shall be able to view (read-only) and download prescriptions.

### REQ-ADM-PAY-001
Admin shall be able to view payment history, payment status, and failed/refunded payments.

### REQ-ADM-CFG-001
Admin shall be able to configure `isSingleDoctor` and `singleDoctorId` from the settings page.

---

## STAGE 5 – Super Admin Role

### REQ-SA-001
Super Admin shall have access to all Admin functionality plus hospital-level management.

### REQ-SA-002
Super Admin shall be able to manage doctors: create, edit, deactivate.

### REQ-SA-003
Super Admin shall be able to manage admins: create, edit, deactivate.

### REQ-SA-004
Super Admin shall be able to view system-wide reports: booking totals, revenue, cancellations.

### REQ-SA-005
Super Admin shall be able to configure Prime subscription plans.

### REQ-SA-006
Super Admin shall be able to set the `default_doctor_id` at the hospital configuration level.

### REQ-SA-007
In Single Doctor Mode deployment, Super Admin shall have a simplified view scoped to the single doctor.

---

## STAGE 6 – Backend / Database Requirements

### REQ-BE-001 – default_doctor_id
Add column `default_doctor_id UUID` to `admin_settings` or `hospital_settings` table to store the configured single doctor.

### REQ-BE-002 – family_members table
Create table `patient_family_members (id, patient_id, name, dob, gender, relationship, created_at)` with FK to `patients`.

### REQ-BE-003 – Auto-cancellation
Create Supabase pg_cron job or Edge Function: every 5 minutes, cancel `appointments` where `status = 'Pending'`, `payment_status = 'Unpaid'`, and `appointment_datetime <= now() + 10 minutes`.

### REQ-BE-004 – Walking token queue ordering
`appointments.token` format enforced via DB trigger or backend function. Queue position computed by token sequence number.

### REQ-BE-005 – Online consultation sessions
Create table `consultation_sessions (id, appointment_id, doctor_id, patient_id, provider, session_token, status, started_at, ended_at)`.

### REQ-BE-006 – Rebooking rule
RPC `check_rebooking_fee(patient_id, doctor_id, new_date)` returns `{is_follow_up: bool, fee: numeric}`. Replace hardcoded 500.0 in BookingWizardCubit.

### REQ-BE-007 – Multilingual static content
Add `content_translations (key, language_code, value)` table for server-side translatable strings (optional, pending language decision).

### REQ-BE-008 – Notification push integration
Configure Supabase Edge Function to send FCM push notifications from `notification_queue` entries.

---

## STAGE 7 – Payment

### REQ-PAY-001
Payment flow: `Booking Created → Payment Initiated → Gateway/QR → Success/Failure → Booking Confirmed/Cancelled`.

### REQ-PAY-002
Supported payment methods (to confirm via open question): UPI QR static, Pay-at-counter, and optionally Razorpay/Stripe.

### REQ-PAY-003
Payment timeout: if payment not completed within the slot's cutoff window, booking auto-cancelled (REQ-PAT-AC-001).

### REQ-PAY-004
Refund record shall be created in the `refunds` table on cancellation of a paid booking.

### REQ-PAY-005
Consultation charge for follow-up (< 7 days) shall be 0. Standard charge otherwise (fetched from doctor profile, not hardcoded).

---

## STAGE 8 – Notifications

### REQ-NOT-001
Push notifications (FCM) shall be sent for: booking confirmation, payment success, payment failure, cancellation, auto-cancellation, rebooking confirmation, slot reminder (24h before), walking token called, online consultation reminder (15 min before), prescription available, test results available.

### REQ-NOT-002
In-app notifications shall be persisted in the `notifications` table and shown in `AdminNotificationsPage` (admin) and a new patient notifications page.

### REQ-NOT-003
Notification templates shall be stored in `notification_templates` and support localization via language_code.

---

## STAGE 9 – Online Consultation

### REQ-OC-001
Video and chat shall use a single SDK (provider to be confirmed via open question).

### REQ-OC-002
Doctor initiates session; patient joins via a deep link or in-app notification.

### REQ-OC-003
Session tokens shall be generated server-side with expiry.

### REQ-OC-004
Chat messages shall be persisted in the `messages` table (already defined in AppTableNames).

### REQ-OC-005
Video session recording (optional) is out of scope unless confirmed.

---

## STAGE 10 – Testing & Regression

### REQ-TST-001
Every new feature shall have unit tests for the corresponding Bloc/Cubit and repository.

### REQ-TST-002
Widget tests shall cover: booking wizard (hospital vs single-doctor), slot management, cancellation flow.

### REQ-TST-003
Integration tests shall verify end-to-end flows for both modes.

### REQ-TST-004
Hospital mode regression: all existing behaviour with `isSingleDoctor = false` shall pass after each stage.

### REQ-TST-005
Single Doctor Mode tests: `isSingleDoctor = true`, `singleDoctorId` set, verify doctor selection bypassed in all affected screens.

---

## Acceptance Criteria (Cross-Cutting)

- `isSingleDoctor = false` → No change to existing hospital behaviour.
- `isSingleDoctor = true` → `singleDoctorId` used automatically everywhere a doctor ID is needed.
- All 4 login roles functional in both modes.
- No hard-coded doctor IDs or user-facing strings in new code.
- All new screens localized.
- Business rules (rebooking fee, cancellation window, auto-cancellation) enforced server-side.
