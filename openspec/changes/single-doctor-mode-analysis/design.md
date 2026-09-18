# Design: Single Doctor Mode – Technical Architecture & UI Design

## 1. Configuration Architecture

```
+---------------------------+
|       EnvConfig           |
|  isSingleDoctor: bool     |
|  singleDoctorId: String   |
|  (FlutterSecureStorage)   |
+----------+----------------+
           |
           v
+---------------------------+
|     AppModeProvider       |  ← LazyLazySingleton in GetIt
|  .isSingleDoctor          |
|  .singleDoctorId          |
+----------+----------------+
           |
    +------+--------+
    |               |
    v               v
Repositories     UI Guards
(auto-inject     (skip steps,
 doctorId)        hide widgets)
```

## 2. Mode-Based Flow Comparison

### Hospital Mode (isSingleDoctor = false)

```
Patient Booking Flow:
  PatientDashboard
       |
       v
  SpecialityListPage  ← Browse specialities
       |
       v
  SpecialityDoctorsPage  ← Select doctor
       |
       v
  DoctorProfileDetailPage  ← View profile
       |
       v
  BookingFlowPage  ← Select slot + date
       |
       v
  BookingPaymentConfirmPage
       |
       v
  BookingSuccessPage

Admin/Doctor Booking Wizard (BookingWizardCubit):
  Step 0: Select Patient
  Step 1: Select Specialty
  Step 2: Select Doctor  ← shown
  Step 3: Select Slot
  Step 4: Confirm
```

### Single Doctor Mode (isSingleDoctor = true)

```
Patient Booking Flow:
  PatientDashboard
       |
       v
  BookingFlowPage  ← singleDoctorId pre-set, speciality skipped
       |
       v
  SlotSelectionView  ← slots loaded for singleDoctorId
       |
       v
  BookingPaymentConfirmPage
       |
       v
  BookingSuccessPage

Admin/Doctor Booking Wizard:
  Step 0: Select Patient
  Step 1: Select Slot  ← specialty + doctor steps SKIPPED
  Step 2: Confirm
```

## 3. BookingWizardCubit Single Doctor Mode Changes

```dart
// BookingWizardCubit initialization (Single Doctor Mode)
if (AppModeProvider.instance.isSingleDoctor) {
  // Auto-set step offset. Steps 1 (specialty) and 2 (doctor) skipped.
  _skipToPatientAndSlot();
  // Auto-load appointment counts for singleDoctorId
  loadAppointmentCountsForSingleDoctor();
}
```

Step mapping:
```
Hospital:  0=Patient  1=Specialty  2=Doctor  3=Slot  4=Confirm
Single:    0=Patient              (skip)    1=Slot  2=Confirm
```

## 4. Repository Pattern for Doctor ID Injection

```
AppointmentsRepository
  +-- getSlots(date, {doctorId})
  |     doctorId = AppModeProvider.isSingleDoctor
  |               ? AppModeProvider.singleDoctorId
  |               : doctorId (passed in)
  |
  +-- createBooking(params)
  |     same pattern
  |
  +-- getPrescriptions({doctorId, patientId})
        same pattern
```

All repositories accept optional `doctorId`. When `isSingleDoctor = true`, the provider overrides.

## 5. Database Schema Changes

### 5.1 admin_settings – Add default_doctor_id
```sql
ALTER TABLE admin_settings
ADD COLUMN IF NOT EXISTS default_doctor_id UUID REFERENCES doctors(id);
```

### 5.2 patient_family_members (NEW)
```sql
CREATE TABLE patient_family_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  date_of_birth DATE,
  gender TEXT CHECK (gender IN ('Male', 'Female', 'Other')),
  relationship TEXT NOT NULL,  -- 'Self', 'Father', 'Mother', 'Spouse', 'Child', 'Other'
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 5.3 consultation_sessions (NEW)
```sql
CREATE TABLE consultation_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id UUID NOT NULL REFERENCES appointments(id),
  doctor_id UUID NOT NULL,
  patient_id UUID NOT NULL,
  provider TEXT NOT NULL,           -- 'agora' | 'jitsi' | 'webrtc'
  channel_name TEXT NOT NULL,
  session_token TEXT,
  status TEXT DEFAULT 'waiting'     -- 'waiting' | 'active' | 'completed' | 'cancelled'
  CHECK (status IN ('waiting', 'active', 'completed', 'cancelled')),
  started_at TIMESTAMPTZ,
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 5.4 Auto-cancellation pg_cron
```sql
SELECT cron.schedule(
  'auto_cancel_unpaid_appointments',
  '*/5 * * * *',
  $$
  UPDATE appointments
  SET status = 'Cancelled', updated_at = NOW()
  WHERE status = 'Pending'
    AND payment_status = 'Unpaid'
    AND (appointment_date::date + appointment_time::time) <= NOW() + INTERVAL '10 minutes';
  $$
);
```

### 5.5 RPC: check_rebooking_fee
```sql
CREATE OR REPLACE FUNCTION check_rebooking_fee(
  p_patient_id UUID,
  p_doctor_id UUID,
  p_new_date DATE
) RETURNS JSON AS $$
DECLARE
  v_last_date DATE;
  v_diff INT;
  v_base_fee NUMERIC;
BEGIN
  SELECT appointment_date::date INTO v_last_date
  FROM appointments
  WHERE patient_id = p_patient_id
    AND doctor_id = p_doctor_id
    AND status != 'Cancelled'
  ORDER BY appointment_date DESC
  LIMIT 1;

  IF v_last_date IS NULL THEN
    RETURN json_build_object('is_follow_up', false, 'fee', 500);
  END IF;

  v_diff := ABS(p_new_date - v_last_date);

  SELECT consultation_fee INTO v_base_fee
  FROM doctors WHERE id = p_doctor_id;

  IF v_diff < 7 THEN
    RETURN json_build_object('is_follow_up', true, 'fee', 0);
  ELSE
    RETURN json_build_object('is_follow_up', false, 'fee', COALESCE(v_base_fee, 500));
  END IF;
END;
$$ LANGUAGE plpgsql;
```

## 6. Localization Architecture

```
assets/
  l10n/
    app_en.arb   ← English (default)
    app_ml.arb   ← Malayalam (example)
    app_hi.arb   ← Hindi (example)

lib/
  core/
    l10n/
      app_localizations.dart  ← generated
      app_localizations_en.dart
      app_localizations_ml.dart
```

`pubspec.yaml` additions:
```yaml
flutter:
  generate: true

flutter_localizations:
  sdk: flutter
intl: ^0.20.2  # already present
```

`l10n.yaml`:
```yaml
arb-dir: assets/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

## 7. Walking Token Design

```
Token Naming Convention:
  Normal:  <Initials>A<3-digit-seq>  →  JDA001, JDA002 ...
  Walking: <Initials>W<3-digit-seq>  →  JDW001, JDW002 ...

Queue Assignment (Walking):
  Ordered by: payment_completed_at ASC (first-paid = first token)

Display on Patient Dashboard:
  +---------------------------+
  |  Your Token: JDW003       |
  |  Queue Position: 3 of 8   |
  |  Status: Waiting          |
  +---------------------------+

Realtime: Supabase Realtime subscription on appointments table
  filter: appointment_date = today AND doctor_id = X
```

## 8. Online Consultation UI (Pending SDK Decision)

```
Doctor View:                    Patient View:
+--------------------+          +--------------------+
| [Video Feed]       |          | [Doctor Video]     |
|                    |          |                    |
| [Patient Thumb]    |          | [My Thumb]         |
+--------------------+          +--------------------+
| Chat  | End | Mute |          | Chat  | Leave      |
+--------------------+          +--------------------+
```

Provider integration will follow selected SDK. A `ConsultationBloc` will manage:
- Session creation (via Supabase RPC)
- Token retrieval
- Connection state
- Chat message stream

## 9. Family Member Booking UI

```
Booking Flow - Select Patient Step:
+----------------------------------+
|  Booking for:                    |
|  [○] Self (John Doe)             |
|  [○] Father (Robert Doe)         |
|  [○] Child (Emily Doe)           |
|  [+ Add Family Member]           |
+----------------------------------+
```

## 10. Settings Screen – Single Doctor Mode Configuration

Admin/Super Admin Settings Page (new section):
```
+---------------------------------------------+
|  Application Mode                            |
|  Single Doctor Mode  [TOGGLE: ON/OFF]        |
|                                              |
|  Configured Doctor ID                        |
|  [Search Doctor...]  [Doctor Name]           |
|                                              |
|  [Save Configuration]                        |
+---------------------------------------------+
```

Changes persist via `EnvConfig` (FlutterSecureStorage) and broadcast through `AppModeProvider`.

## 11. Notification Architecture

```
Supabase Edge Function: send_push_notification
  ↑ triggered by
notification_queue table INSERT
  ↑ populated by
App server actions (booking, payment, cancellation, etc.)
  ↓ delivers to
FCM (Android) / APNs (iOS)
  ↓ received by
Flutter App (firebase_messaging package)
```

## 12. State Management Extensions

New Blocs/Cubits required:
- `ConsultationBloc` – video/chat session management
- `FamilyMemberCubit` – CRUD for patient family members
- `TokenQueueCubit` – realtime token queue display
- `LocalizationCubit` – language selection persistence

Existing Blocs to extend:
- `BookingWizardCubit` – skip steps in single-doctor mode; use RPC for rebooking fee
- `AdminSettingsBloc` – add single-doctor configuration events
- `DoctorAppointmentsBloc` – use singleDoctorId when appropriate

## 13. Gap Analysis Summary

| Module | Status | Gap | Priority |
|--------|--------|-----|----------|
| Single Doctor Config | Partial | DI registration, propagation | High |
| Localization | Missing | ARB files, language switcher | High |
| Doctor Booking Wizard | Exists | Skip doctor step in SD mode | High |
| Doctor Slot Management | Exists | SD mode auto-inject doctorId | Medium |
| Rebooking Fee Rule | Partial | RPC, remove hardcode | High |
| Doctor Profile Edit | Exists | Minor refinements | Low |
| Doctor History | Partial | Cancellation/rebooking history | Medium |
| Prescription CRUD | Partial | Doctor create/edit UI, PDF | High |
| Online Consultation | Missing | SDK + session management | High |
| MRD | Partial | Complete doctor-side review | Medium |
| Lab/Tests Doctor-side | Partial | Create order, view results | Medium |
| Patient Booking (SD) | Exists | Skip specialty + doctor steps | High |
| Patient Cancellation | Partial | Enforce cutoff rule | High |
| Auto-cancellation | Missing | pg_cron trigger | High |
| Walking Token | Partial | Queue ordering by payment_ts | High |
| Token Display Realtime | Partial | Supabase Realtime subscription | Medium |
| Patient Health Records | Partial | Expand content | Medium |
| Prime/Subscription | Partial | Define benefits, payment flow | Medium |
| Patient Video | Missing | SDK integration | High |
| Patient Chat Realtime | Partial | messages table subscription | Medium |
| Patient Family Members | Missing | Table + CRUD + booking select | High |
| Admin Bookings | Exists | SD mode filter by singleDoctorId | Low |
| Admin Payments | Exists | Refund UI | Medium |
| Admin Prescription DL | Partial | Confirm PDF download | Low |
| Super Admin Dashboard | Missing | Distinct role/dashboard | Medium |
| Push Notifications | Missing | FCM + Edge Function | High |
| Video Sessions DB | Missing | consultation_sessions table | High |
| Family Members DB | Missing | patient_family_members table | High |
| Auto-cancel DB | Missing | pg_cron job | High |
| default_doctor_id col | Missing | admin_settings column | High |
| Rebooking Fee RPC | Missing | check_rebooking_fee RPC | High |
