-- ============================================================================
-- Supabase Schema Setup & Activity Logging Automation Script
-- ============================================================================

-- Create user_status enum if not exists
DO $$ BEGIN
    CREATE TYPE user_status AS ENUM ('Pending Registration', 'Registered', 'Active', 'Inactive', 'Suspended', 'Available', 'Away');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 1. Users Table (Core Identity)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID UNIQUE, -- links to auth.users.id
    email TEXT UNIQUE,
    phone TEXT UNIQUE,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    profile_photo TEXT,
    primary_role TEXT NOT NULL DEFAULT 'patient',
    profile_completed BOOLEAN DEFAULT false,
    onboarding_step INTEGER DEFAULT 1,
    account_status user_status DEFAULT 'Pending Registration',
    last_login TIMESTAMPTZ,
    last_active TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    deleted_at TIMESTAMPTZ
);

-- 2. User Roles Table (Multi-role support)
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE (user_id, role)
);

-- 3. User Devices Table (Push notification devices)
CREATE TABLE IF NOT EXISTS user_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    device_token TEXT NOT NULL UNIQUE,
    device_type TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. User Hospital Roles Table
CREATE TABLE IF NOT EXISTS user_hospital_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    hospital_id UUID, -- References hospitals(id)
    branch_id UUID, -- References hospital_branches(id)
    role TEXT NOT NULL,
    designation TEXT,
    department TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Patients Table
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    patient_id TEXT UNIQUE, -- UHID (Hospital generated ID)
    blood_group TEXT,
    date_of_birth TEXT,
    age INTEGER,
    gender TEXT,
    address TEXT,
    emergency_contact TEXT,
    insurance_provider TEXT,
    insurance_number TEXT,
    allergies TEXT,
    chronic_diseases TEXT,
    marital_status TEXT,
    occupation TEXT,
    national_id TEXT,
    guardian_name TEXT,
    guardian_phone TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 7. Employees Table (Doctors / Nurses / Staff)
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    employee_id TEXT UNIQUE,
    joining_date TEXT,
    department TEXT,
    designation TEXT,
    qualification TEXT,
    staff_role TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. Doctors Table
CREATE TABLE IF NOT EXISTS doctors (
    id UUID PRIMARY KEY REFERENCES employees(id) ON DELETE CASCADE,
    medical_registration_number TEXT UNIQUE,
    experience INTEGER,
    specialization TEXT,
    consultation_fee NUMERIC(10, 2),
    availability_status TEXT DEFAULT 'Available',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 9. Admins Table
CREATE TABLE IF NOT EXISTS admins (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    access_level TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 10. Doctor Specialties
CREATE TABLE IF NOT EXISTS doctor_specialities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id UUID REFERENCES doctors(id) ON DELETE CASCADE,
    speciality TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 11. Patient Medical Profile
CREATE TABLE IF NOT EXISTS patient_medical_profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE UNIQUE,
    height NUMERIC(5, 2),
    weight NUMERIC(5, 2),
    bmi NUMERIC(5, 2),
    medical_history TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 12. Patient Accounts
CREATE TABLE IF NOT EXISTS patient_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE UNIQUE,
    balance NUMERIC(10, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 13. Patient Allergies
CREATE TABLE IF NOT EXISTS patient_allergies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
    allergy TEXT NOT NULL,
    severity TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE (patient_id, allergy)
);

-- 14. Patient History
CREATE TABLE IF NOT EXISTS patient_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
    condition TEXT NOT NULL,
    diagnosis_date TEXT,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 15. Patient Insurance
CREATE TABLE IF NOT EXISTS patient_insurance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE UNIQUE,
    provider TEXT NOT NULL,
    policy_number TEXT NOT NULL,
    valid_till TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 16. Patient Emergency Contacts
CREATE TABLE IF NOT EXISTS patient_emergency_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    relationship TEXT NOT NULL,
    phone TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 17. Hospitals Table
CREATE TABLE IF NOT EXISTS hospitals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 18. Hospital Branches Table
CREATE TABLE IF NOT EXISTS hospital_branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hospital_id UUID REFERENCES hospitals(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 19. Buildings Table
CREATE TABLE IF NOT EXISTS buildings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES hospital_branches(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 20. Floors Table
CREATE TABLE IF NOT EXISTS floors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    number INTEGER NOT NULL,
    name TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 21. Wings Table
CREATE TABLE IF NOT EXISTS wings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    floor_id UUID REFERENCES floors(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 22. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wing_id UUID REFERENCES wings(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 23. Rooms Table
CREATE TABLE IF NOT EXISTS rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    department_id UUID REFERENCES departments(id) ON DELETE CASCADE,
    number TEXT NOT NULL,
    type TEXT DEFAULT 'General',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 24. Beds Table
CREATE TABLE IF NOT EXISTS beds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
    number TEXT NOT NULL,
    is_occupied BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 25. Pharmacy Inventory
CREATE TABLE IF NOT EXISTS pharmacy_inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    category TEXT NOT NULL,
    buy_price NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    sell_price NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    dosage TEXT NOT NULL DEFAULT '',
    image_url TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 26. Lab Records
CREATE TABLE IF NOT EXISTS lab_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_name TEXT NOT NULL,
    test_name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Pending',
    priority TEXT NOT NULL DEFAULT 'Normal',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 27. Staff Attendance
CREATE TABLE IF NOT EXISTS staff_attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_id UUID,
    staff_name TEXT NOT NULL,
    role TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Absent',
    check_in_time TEXT,
    check_out_time TEXT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 28. Emergency Alerts
CREATE TABLE IF NOT EXISTS emergency_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message TEXT NOT NULL,
    level TEXT NOT NULL DEFAULT 'Medium',
    is_resolved BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 29. Activity Logs
CREATE TABLE IF NOT EXISTS activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'System',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 30. Invoices
CREATE TABLE IF NOT EXISTS invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_name TEXT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    status TEXT NOT NULL DEFAULT 'Pending',
    payment_method TEXT NOT NULL DEFAULT 'Cash',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 31. Admin Settings
CREATE TABLE IF NOT EXISTS admin_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 32. Appointments
CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES users(id),
    patient_name TEXT,
    doctor_id UUID REFERENCES users(id),
    doctor_name TEXT,
    specialty TEXT,
    appointment_date DATE,
    appointment_time TEXT,
    status TEXT DEFAULT 'Pending',
    type TEXT DEFAULT 'Consultation',
    token TEXT,
    bp TEXT,
    weight TEXT,
    height TEXT,
    fever TEXT,
    head_circumference TEXT,
    additional_vitals TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 33. EMR Records
CREATE TABLE IF NOT EXISTS emr_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID,
    patient_name TEXT NOT NULL,
    doctor_id UUID,
    doctor_name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    appointment_id UUID,
    medicines TEXT,
    lab_tests TEXT,
    prescription_notes TEXT,
    invoice_number TEXT,
    amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    payment_method TEXT NOT NULL DEFAULT 'Cash',
    medicine_payment_status TEXT NOT NULL DEFAULT 'Pending',
    lab_payment_status TEXT NOT NULL DEFAULT 'Pending',
    medicine_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    lab_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    medicine_invoice_number TEXT,
    lab_invoice_number TEXT,
    recorded_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================================
-- AUTOMATED ACTIVITY LOGGING TRIGGERS
-- ============================================================================

CREATE OR REPLACE FUNCTION automate_activity_logs()
RETURNS TRIGGER AS $$
DECLARE
    log_message TEXT;
    log_category TEXT;
BEGIN
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- DISABLE ROW LEVEL SECURITY (RLS) FOR DEVELOPMENT
-- ============================================================================
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_devices DISABLE ROW LEVEL SECURITY;
ALTER TABLE notifications DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_hospital_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE patients DISABLE ROW LEVEL SECURITY;
ALTER TABLE employees DISABLE ROW LEVEL SECURITY;
ALTER TABLE doctors DISABLE ROW LEVEL SECURITY;
ALTER TABLE admins DISABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_specialities DISABLE ROW LEVEL SECURITY;
ALTER TABLE patient_medical_profile DISABLE ROW LEVEL SECURITY;
ALTER TABLE patient_accounts DISABLE ROW LEVEL SECURITY;
ALTER TABLE patient_allergies DISABLE ROW LEVEL SECURITY;
ALTER TABLE patient_history DISABLE ROW LEVEL SECURITY;
ALTER TABLE patient_insurance DISABLE ROW LEVEL SECURITY;
ALTER TABLE patient_emergency_contacts DISABLE ROW LEVEL SECURITY;
ALTER TABLE hospitals DISABLE ROW LEVEL SECURITY;
ALTER TABLE hospital_branches DISABLE ROW LEVEL SECURITY;
ALTER TABLE buildings DISABLE ROW LEVEL SECURITY;
ALTER TABLE floors DISABLE ROW LEVEL SECURITY;
ALTER TABLE wings DISABLE ROW LEVEL SECURITY;
ALTER TABLE departments DISABLE ROW LEVEL SECURITY;
ALTER TABLE rooms DISABLE ROW LEVEL SECURITY;
ALTER TABLE beds DISABLE ROW LEVEL SECURITY;
ALTER TABLE pharmacy_inventory DISABLE ROW LEVEL SECURITY;
ALTER TABLE lab_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE staff_attendance DISABLE ROW LEVEL SECURITY;
ALTER TABLE emergency_alerts DISABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE invoices DISABLE ROW LEVEL SECURITY;
ALTER TABLE admin_settings DISABLE ROW LEVEL SECURITY;
ALTER TABLE appointments DISABLE ROW LEVEL SECURITY;
ALTER TABLE emr_records DISABLE ROW LEVEL SECURITY;

-- ============================================================================
-- DATABASE PRIVILEGE GRANTS
-- ============================================================================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;

-- Ensure cache reloads
NOTIFY pgrst, 'reload schema';
