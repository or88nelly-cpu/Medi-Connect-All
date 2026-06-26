-- ============================================================================
-- Supabase Schema Setup & Activity Logging Automation Script
-- ============================================================================

-- 0. Users Profile
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT,
    name TEXT,
    phone TEXT,
    role TEXT NOT NULL DEFAULT 'patient',
    profile_completion_status BOOLEAN DEFAULT false,
    status TEXT DEFAULT 'Pending Registration',
    department TEXT,
    qualification TEXT,
    metadata JSONB,
    first_name TEXT,
    last_name TEXT,
    date_of_birth TEXT,
    age INTEGER,
    gender TEXT,
    profile_image TEXT,
    address TEXT,
    emergency_contact TEXT,
    blood_group TEXT,
    marital_status TEXT,
    employee_id TEXT,
    patient_id TEXT,
    medical_registration_number TEXT,
    experience INTEGER,
    specialization TEXT,
    consultation_fee NUMERIC(10, 2),
    availability_status TEXT DEFAULT 'Available',
    staff_role TEXT,
    joining_date TEXT,
    allergies TEXT,
    chronic_diseases TEXT,
    insurance_provider TEXT,
    insurance_number TEXT,
    designation TEXT,
    access_level TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 1. Pharmacy Inventory
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

-- 2. Lab Records
CREATE TABLE IF NOT EXISTS lab_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_name TEXT NOT NULL,
    test_name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Pending',
    priority TEXT NOT NULL DEFAULT 'Normal',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Staff Attendance
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

-- 4. Emergency Alerts
CREATE TABLE IF NOT EXISTS emergency_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message TEXT NOT NULL,
    level TEXT NOT NULL DEFAULT 'Medium',
    is_resolved BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Activity Logs
CREATE TABLE IF NOT EXISTS activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'System',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Invoices
CREATE TABLE IF NOT EXISTS invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_name TEXT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    status TEXT NOT NULL DEFAULT 'Pending',
    payment_method TEXT NOT NULL DEFAULT 'Cash',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 7. Admin Settings
CREATE TABLE IF NOT EXISTS admin_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. Appointments
DROP TABLE IF EXISTS appointments CASCADE;
CREATE TABLE appointments (
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
    created_at TIMESTAMPTZ DEFAULT now()
);


-- 9. EMR Records
DROP TABLE IF EXISTS emr_records CASCADE;
CREATE TABLE emr_records (
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
    log_category := TG_TABLE_NAME;
    
    IF TG_TABLE_NAME = 'pharmacy_inventory' THEN
        log_category := 'Pharmacy';
        IF TG_OP = 'INSERT' THEN
            log_message := 'New pharmacy item added: ' || NEW.name || ' (' || NEW.stock || ' units)';
        ELSIF TG_OP = 'UPDATE' THEN
            log_message := 'Pharmacy item updated: ' || NEW.name || ' (stock: ' || NEW.stock || ')';
        ELSIF TG_OP = 'DELETE' THEN
            log_message := 'Pharmacy item deleted: ' || OLD.name;
        END IF;
        
    ELSIF TG_TABLE_NAME = 'lab_records' THEN
        log_category := 'Lab';
        IF TG_OP = 'INSERT' THEN
            log_message := 'Lab record created: ' || NEW.test_name || ' for patient ' || NEW.patient_name;
        ELSIF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
            log_message := 'Lab test status for ' || NEW.patient_name || ' updated from ' || OLD.status || ' to ' || NEW.status;
        ELSE
            RETURN NEW;
        END IF;
        
    ELSIF TG_TABLE_NAME = 'staff_attendance' THEN
        log_category := 'Attendance';
        IF TG_OP = 'INSERT' THEN
            log_message := 'Attendance logged for ' || NEW.staff_name || ' (' || NEW.role || ') as ' || NEW.status;
        ELSIF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
            log_message := 'Attendance for ' || NEW.staff_name || ' updated to ' || NEW.status;
        ELSE
            RETURN NEW;
        END IF;
        
    ELSIF TG_TABLE_NAME = 'emergency_alerts' THEN
        log_category := 'Emergency';
        IF TG_OP = 'INSERT' THEN
            log_message := 'Emergency triggered: [' || NEW.level || '] ' || NEW.message;
        ELSIF TG_OP = 'UPDATE' AND OLD.is_resolved = false AND NEW.is_resolved = true THEN
            log_message := 'Emergency resolved: ' || NEW.message;
        ELSE
            RETURN NEW;
        END IF;
        
    ELSIF TG_TABLE_NAME = 'invoices' THEN
        log_category := 'Billing';
        IF TG_OP = 'INSERT' THEN
            log_message := 'New invoice generated for ' || NEW.patient_name || ' of amount $' || NEW.amount || ' (' || NEW.status || ')';
        ELSIF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
            log_message := 'Invoice status for ' || NEW.patient_name || ' updated to ' || NEW.status;
        ELSE
            RETURN NEW;
        END IF;
        
    ELSIF TG_TABLE_NAME = 'admin_settings' THEN
        log_category := 'System';
        IF TG_OP = 'UPDATE' AND OLD.value != NEW.value THEN
            log_message := 'Admin setting "' || NEW.key || '" changed from ' || OLD.value || ' to ' || NEW.value;
        ELSE
            RETURN NEW;
        END IF;
        
    ELSIF TG_TABLE_NAME = 'appointments' THEN
        log_category := 'Appointment';
        IF TG_OP = 'INSERT' THEN
            log_message := 'Appointment booked with ' || NEW.doctor_name || ' for patient ' || NEW.patient_name || ' on ' || NEW.appointment_date || ' at ' || NEW.appointment_time;
        ELSIF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
            log_message := 'Appointment status for ' || NEW.patient_name || ' with ' || NEW.doctor_name || ' updated to ' || NEW.status;
        ELSIF TG_OP = 'DELETE' THEN
            log_message := 'Appointment cancelled for patient ' || OLD.patient_name;
        END IF;
    END IF;

    -- Insert into activity_logs if a message was defined
    IF log_message IS NOT NULL THEN
        INSERT INTO activity_logs (message, category)
        VALUES (log_message, log_category);
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Bind triggers to the tables to automate logging
DROP TRIGGER IF EXISTS trg_pharmacy_activity ON pharmacy_inventory;
CREATE TRIGGER trg_pharmacy_activity
AFTER INSERT OR UPDATE OR DELETE ON pharmacy_inventory
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();

DROP TRIGGER IF EXISTS trg_labs_activity ON lab_records;
CREATE TRIGGER trg_labs_activity
AFTER INSERT OR UPDATE ON lab_records
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();

DROP TRIGGER IF EXISTS trg_attendance_activity ON staff_attendance;
CREATE TRIGGER trg_attendance_activity
AFTER INSERT OR UPDATE ON staff_attendance
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();

DROP TRIGGER IF EXISTS trg_emergency_activity ON emergency_alerts;
CREATE TRIGGER trg_emergency_activity
AFTER INSERT OR UPDATE ON emergency_alerts
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();

DROP TRIGGER IF EXISTS trg_invoice_activity ON invoices;
CREATE TRIGGER trg_invoice_activity
AFTER INSERT OR UPDATE ON invoices
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();

DROP TRIGGER IF EXISTS trg_settings_activity ON admin_settings;
CREATE TRIGGER trg_settings_activity
AFTER UPDATE ON admin_settings
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();

DROP TRIGGER IF EXISTS trg_appointments_activity ON appointments;
CREATE TRIGGER trg_appointments_activity
AFTER INSERT OR UPDATE OR DELETE ON appointments
FOR EACH ROW EXECUTE FUNCTION automate_activity_logs();
-- ============================================================================
-- DISABLE ROW LEVEL SECURITY (RLS) FOR DEVELOPMENT
-- ============================================================================
ALTER TABLE pharmacy_inventory DISABLE ROW LEVEL SECURITY;
ALTER TABLE lab_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE staff_attendance DISABLE ROW LEVEL SECURITY;
ALTER TABLE emergency_alerts DISABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE invoices DISABLE ROW LEVEL SECURITY;
ALTER TABLE admin_settings DISABLE ROW LEVEL SECURITY;
ALTER TABLE appointments DISABLE ROW LEVEL SECURITY;
ALTER TABLE emr_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Add Vitals columns to Appointments table
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS bp TEXT;
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS weight TEXT;
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS height TEXT;
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS fever TEXT;
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS head_circumference TEXT;
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS additional_vitals TEXT;

-- Add pricing and dosage columns to Pharmacy Inventory table
ALTER TABLE pharmacy_inventory ADD COLUMN IF NOT EXISTS buy_price NUMERIC(10, 2) NOT NULL DEFAULT 0.00;
ALTER TABLE pharmacy_inventory ADD COLUMN IF NOT EXISTS sell_price NUMERIC(10, 2) NOT NULL DEFAULT 0.00;
ALTER TABLE pharmacy_inventory ADD COLUMN IF NOT EXISTS dosage TEXT NOT NULL DEFAULT '';
ALTER TABLE pharmacy_inventory ADD COLUMN IF NOT EXISTS image_url TEXT NOT NULL DEFAULT '';

-- Add token column to Appointments table
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS token TEXT;


