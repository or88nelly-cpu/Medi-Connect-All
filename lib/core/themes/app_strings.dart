/// Centralized string constants for localization and UI text.
/// Ensures no hardcoded raw strings are used directly in pages/widgets.
class AppStrings {
  // Common Buttons & Actions
  static const login = "Login";
  static const signup = "Sign Up";
  static const register = "Register";
  static const verify = "Verify";
  static const submit = "Submit";
  static const cancel = "Cancel";
  static const confirm = "Confirm";
  static const next = "Next";
  static const getStarted = "Get Started";
  static const retry = "Retry";
  static const logout = "Logout";

  // Navigation / Features
  static const appointment = "Appointment";
  static const appointments = "Appointments";
  static const chat = "Chat";
  static const consultations = "Consultations";
  static const medicalRecords = "Medical Records";
  static const dietPlans = "Diet Plans";
  static const exercise_plans = "Exercise Plans";
  static const notifications = "Notifications";
  static const profile = "Profile";
  static const payments = "Payments";
  static const dashboard = "Dashboard";
  static const availableBeds = "Available Beds";

  // Authentication & Onboarding
  static const splashTitle = "Medi-Connect";
  static const splashSubtitle = "Smart Healthcare Management Platform";
  static const onboardingTitle1 = "Find Trusted Doctors";
  static const onboardingDesc1 =
      "Connect with certified medical specialists instantly.";
  static const onboardingTitle2 = "Book Appointments easily";
  static const onboardingDesc2 =
      "Schedule physical or video consultation bookings anytime.";
  static const onboardingTitle3 = "Secure Medical Records";
  static const onboardingDesc3 =
      "Store and access reports, tests, and advice securely.";

  static const welcomeBack = "Welcome Back";
  static const signInSubtitle = "Sign in to access your healthcare portal";
  static const emailAddress = "Email Address";
  static const enterEmail = "Enter your email";
  static const password = "Password";
  static const enterPassword = "Enter your password";
  static const forgotPasswordQuestion = "Forgot Password?";
  static const dontHaveAccount = "Don't have an account? ";

  static const createAccount = "Create Account";
  static const registerSubtitle =
      "Join the platform and manage your healthcare journey.";
  static const registerAs = "Register As";
  static const fullName = "Full Name";
  static const enterFullName = "Enter your full name";
  static const phoneNumber = "Phone Number";
  static const enterPhone = "Enter phone number";
  static const alreadyHaveAccount = "Already have an account? ";

  static const forgotPasswordTitle = "Forgot Password";
  static const forgotPasswordDesc =
      "Enter your email to receive a password reset OTP/link.";
  static const resetPasswordTitle = "Reset Password";
  static const resetPasswordDesc = "Create a strong new password for security.";
  static const otpVerificationTitle = "OTP Verification";
  static const otpVerificationDesc =
      "Enter the 6-digit verification code sent to your phone/email.";
  static const resendCode = "Resend Code";
  static const confirmSignOut = "Are you sure you want to sign out?";

  // Validation & Errors
  static const requiredField = "This field is required";
  static const invalidEmail = "Enter a valid email address";
  static const invalidPhone = "Enter a valid phone number";
  static const passwordTooShort = "Password must be at least 8 characters";
  static const genericError = "Something went wrong. Please try again.";
  static const otpInvalid = "Please enter a valid 6-digit OTP code";
  static const passwordMismatch = "Passwords do not match";

  // Dialog & State Texts
  static const success = "Success";
  static const error = "Error";
  static const alert = "Alert";
  static const failedToLoad = "Failed to load";
  static const noData = "No data";
  static const noRecords = "No records found in this category.";

  // Dashboard & Module Titles
  static const welcomeUser = "Welcome Back,";
  static const drUser = "Dr. Healthcare User";
  static const patientDashboardTitle = "Patient Dashboard";
  static const doctorDashboardTitle = "Doctor Dashboard";
  static const staffDashboardTitle = "Staff Dashboard";
  static const adminDashboardTitle = "Admin Dashboard";
  static const adminWebDashboardTitle = "Admin Web Dashboard";
  static const websiteDashboardTitle = "Website Dashboard";
  static const publicWebsiteTitle =
      "Welcome to Medi-Connect Public Website Portal";

  static const appointmentsModule = "Appointments Module";
  static const chatModule = "Chat Module";
  static const medicalRecordsModule = "Medical Records Module";
  static const profileModule = "Profile Module";
  static const paymentsModule = "Payments Module";
  static const videoConsultationModule = "Video Consultation Module";
  static const dietPlansModule = "Diet Plans Module";
  static const exercisePlansModule = "Exercise Plans Module";
  static const notificationsModule = "Notifications Module";
  static const analyticsModule = "Analytics Module";
  static const postModule = "Post Module";

  static const appointmentsModuleDesc =
      "Access your appointments settings and records";
  static const chatModuleDesc = "Access your chat settings and records";
  static const medicalRecordsModuleDesc =
      "Access your medical records settings and records";
  static const profileModuleDesc = "Access your profile settings and records";
  static const paymentsModuleDesc = "Access your payments settings and records";
  static const videoConsultationModuleDesc =
      "Access your video consultation settings and records";
  static const dietPlansModuleDesc =
      "Access your diet plans settings and records";
  static const exercisePlansModuleDesc =
      "Access your exercise plans settings and records";
  static const notificationsModuleDesc =
      "Access your notifications settings and records";
  static const analyticsModuleDesc = "Access platform performance analytics";
  static const postModuleDesc = "Access public posts and healthcare blogs";

  // Dedicated Portal & Admin Login/Signup Strings
  static const adminSignUpTitle = "Admin Sign Up";
  static const adminSignUpSubtitle = "Create your admin account";
  static const adminUsername = "Admin Username";
  static const chooseUsername = "Choose a username";
  static const createPasswordLabel = "Create password";
  static const confirmPasswordLabel = "Confirm Password";
  static const confirmPasswordHint = "Confirm password";
  static const agreeToTerms =
      "I agree to the Terms of Service and Privacy Policy";
  static const termsOfService = "Terms of Service";
  static const privacyPolicy = "Privacy Policy";
  static const alreadyHaveAccountSignIn = "Already have an account? Sign in";
  static const adminLoginTitle = "Admin Login";
  static const adminLoginSubtitle = "Welcome back! Please sign in to continue";
  static const username = "Username";
  static const enterUsername = "Enter your username";
  static const rememberMe = "Remember me";
  static const orDivider = "OR";
  static const loginWithOtp = "Login with OTP";
  static const dontHaveAccountSignUp = "Don't have an account? Sign up";
  static const adminPortalTitle = "Admin Portal";
  static const adminPortalDesc =
      "Platform configuration, logs, and security compliance";
  static const accessAdminPortal = "Access Admin Portal";
  static const patientPortalTitle = "Patient Portal";
  static const patientPortalDesc =
      "Manage your personal appointments and records";
  static const accessPatientPortal = "Access Patient Portal";
  static const doctorPortalTitle = "Doctor Portal";
  static const doctorPortalDesc =
      "Manage your schedule, appointments, and consultations";
  static const accessDoctorPortal = "Access Doctor Portal";
  static const staffPortalTitle = "Staff Portal";
  static const staffPortalDesc =
      "Manage clinic administration, details, and schedules";
  static const accessStaffPortal = "Access Staff Portal";
  static const selectPortalAccess = "Select Portal Access";
  static const selectPortalAccessSubtitle =
      "Select a portal access point below";
  static const backToOnboarding = "Back to Onboarding";
  static const loginAs = "Login as ";
  static const enterCredentialsToEnter =
      "Enter your credentials to enter the panel.";
  static const enterprisePortalManagement = "Enterprise Portal Management";

  // Brand details
  static const brandMedi = "Medi";
  static const brandConnect = "Connect";
  static const brandSlogan = "C A R E .  C O N N E C T .  B E T T E R .";

  // Consent
  static const agreeToTermsPrefix = "I agree to the ";
  static const agreeToTermsAnd = "and ";

  // Role Profile access descriptions
  static const patientAccessProfileDesc =
      "Access your Medi-Connect patient profile.";
  static const doctorAccessProfileDesc =
      "Access your Medi-Connect doctor profile.";
  static const staffAccessProfileDesc =
      "Access your Medi-Connect staff profile.";

  // Profile Completion Page Strings
  static const ok = "OK";
  static const submissionError = "Submission Error";
  static const patientProfileOnboarding = "Patient Profile Onboarding";
  static const doctorProfessionalRegistration =
      "Doctor Professional Registration";
  static const medicalStaffRegistration = "Medical Staff Registration";
  static const adminProfileSetup = "Admin Profile Setup";
  static const patientProfileOnboardingDesc =
      "Please provide details to complete your healthcare profile.";
  static const doctorProfessionalRegistrationDesc =
      "Enter your department, qualification, and specialty to verify.";
  static const medicalStaffRegistrationDesc =
      "Please specify your department and work shift details.";
  static const adminProfileSetupDesc =
      "Complete your administrative account details.";
  static const completeProfileSetup = "Complete Profile Setup";
  static const gender = "Gender";
  static const male = "Male";
  static const female = "Female";
  static const other = "Other";
  static const medicalDepartment = "Medical Department";
  static const professionalQualifications =
      "Professional Qualifications (e.g. MD, MBBS)";
  static const areaOfSpecialty = "Area of Specialty (e.g. Cardiology)";
  static const staffDepartment = "Staff Department";
  static const assignedWorkShift = "Assigned Work Shift";
  static const day = "Day";
  static const night = "Night";
  static const rotational = "Rotational";

  // Dashboard Strings
  static const administrator = "Administrator";
  static const accessLevelSuperAdmin = "Access Level: Super Admin";
  static const analyticsOverview = "Analytics Overview";
  static const doctors = "Doctors";
  static const staff = "Staff";
  static const patients = "Patients";
  static const videoConsults = "Video Consults";
  static const totalRevenue = "Total Revenue";
  static const weeklyRevenueTrend = "Weekly Revenue Trend";
  static const departmentDistribution = "Department Distribution";
  static const errorFetchingAnalytics = "Error fetching analytics: ";
  static const docsLabel = " Docs";
  static const managementConsole = "Management Console";
  static const doctorsDirectory = "Doctors Directory";
  static const doctorsDirectoryDesc =
      "Manage doctors listings, scheduling, and leaves.";
  static const staffDirectory = "Staff Directory";
  static const staffDirectoryDesc =
      "Roster staff, shifts, and check attendance logs.";
  static const patientsDirectory = "Patients Directory";
  static const patientsDirectoryDesc =
      "Access patient profiles and family members.";
  static const systemOperations = "System Operations";
  static const slotConfig = "Slot Config";
  static const slotConfigDesc = "Set global durations & constraints.";
  static const auditLogs = "Audit Logs";
  static const auditLogsDesc = "Track operations and records.";
  static const notificationLogs = "Notification Logs";
  static const notificationLogsDesc = "Monitor push, SMS, and emails.";
  static const masterData = "Master Data";
  static const masterDataDesc = "Departments, roles & positions.";

  // Role Selection (Signup)
  static const selectRole = "Select Role";
  static const chooseYourRole = "Choose your role to get started";
  static const roleAdmin = "Admin";
  static const roleDoctor = "Doctor";
  static const roleStaff = "Staff";
  static const rolePatient = "Patient";

  // Department Module
  static const departments = "Departments";
  static const sections = "Sections";
  static const departmentsTitle = "Departments";
  static const addDepartment = "Add Department";
  static const editDepartment = "Edit Department";
  static const deleteDepartment = "Delete Department";
  static const viewAll = "View All";
  static const viewLess = "View Less";
  static const noDepartments = "No departments found.";
  static const departmentNameLabel = "Department Name";
  static const departmentNameHint = "Enter department name";
  static const departmentDescLabel = "Description (Optional)";
  static const departmentDescHint = "Enter a short description";
  static const departmentImageLabel = "Image URL (Optional)";
  static const departmentImageHint = "Paste an image URL";
  static const duplicateDepartment =
      "A department with this name already exists.";
  static const confirmDeleteDepartment =
      "Are you sure you want to delete this department? This action cannot be undone.";
  static const departmentCreated = "Department created successfully.";
  static const departmentUpdated = "Department updated successfully.";
  static const departmentDeleted = "Department deleted successfully.";

  // Patient Dashboard
  static const upcomingAppointments = "Upcoming Appointments";
  static const myRecords = "My Records";
  static const findDoctor = "Find a Doctor";
  static const healthTips = "Health Tips";
  static const noUpcomingAppointments = "No upcoming appointments.";
  static const bookAppointment = "Book Appointment";
  static const patientQuickActions = "Quick Actions";

  // Doctor Dashboard
  static const todaySchedule = "Today's Schedule";
  static const myPatients = "My Patients";
  static const activeConsultations = "Active Consultations";
  static const doctorQuickActions = "Quick Actions";
  static const noScheduleToday = "No appointments scheduled today.";
  static const startConsultation = "Start Consultation";

  // Staff Dashboard
  static const myTasks = "My Tasks";
  static const shiftInfo = "Shift Information";
  static const roster = "Roster";
  static const currentShift = "Current Shift";
  static const staffQuickActions = "Quick Actions";
  static const noTasksAssigned = "No tasks assigned.";

  // Terminal theme strings
  static const authRequired = "Authentication Required";
  static const terminalIdLabel = "@ TERMINAL_ID (EMAIL)";
  static const terminalIdHint = "user@clinicalops.system";
  static const accessKeyLabel = "ACCESS_KEY (PASSWORD)";
  static const passwordHintDots = "•••••••••••••";
  static const forgotLabel = "FORGOT?";
  static const persistentSession = "Persistent session";
  static const initializeAccess = "Initialize Access";
  static const terminalLocationNode =
      "Authorized use only. Terminal location:\nNODE_92.168.1.1";
  static const unregisteredRequestAccess =
      "UNREGISTERED? REQUEST_ACCESS (SIGN UP)";
  static const unregistered = "UNREGISTERED? ";
  static const requestAccessSignUp = "REQUEST_ACCESS (SIGN UP)";
  static const opsStable = "OPS_STABLE";
  static const createAccountTitle = "Create Account";
  static const registerSubtitleTerminal =
      "Register your credentials to access the secure medical operations dashboard.";
  static const selectYourRole = "SELECT YOUR ROLE";
  static const legalNameLabel = "FULL LEGAL NAME";
  static const legalNameHint = "Johnathan Doe";
  static const clinicalEmailLabel = "CLINICAL EMAIL ADDRESS";
  static const clinicalEmailHint = "j.doe@clinic.org";
  static const securityPasswordLabel = "SECURITY PASSWORD";
  static const hipaaAcknowledgePrefix = "I acknowledge and agree to the ";
  static const hipaaComplianceTerms = "HIPAA Compliance Terms";
  static const andGeneral = " and general ";
  static const privacyProtocol = "Privacy Protocol";
  static const forMedicalDataHandling = " for medical data handling.";
  static const finalizeRegistration = "Finalize Registration";
  static const clinicalOpsVersion = "Clinical Operations v4.2.1-stable";
  static const secureEncryptedEnv = "SECURE END-TO-END ENCRYPTED ENVIRONMENT";
  static const hipaaAgreementError =
      "Please agree to the HIPAA Compliance Terms & Privacy Protocol to continue.";

  // New dashboard and operations strings
  static const realTime = "REAL-TIME";
  static const runAll = "Run All";
  static const inStock = "IN STOCK";
  static const expired = "EXPIRED";
  static const outOfStock = "OUT OF STOCK";
  static const totalTests = "TOTAL TESTS";
  static const pending = "PENDING";
  static const criticalAlerts = "CRITICAL ALERTS";
  static const capacityUtilization = "Capacity utilization by department";
  static const totalThisWeek = "Total this week";
  static const weeklyConsultationAppointments =
      "Weekly consultation appointments count trend";
  static const appointmentSummaryGraph = "Appointment Summary Graph";
  static const pharmacySummary = "Pharmacy Summary";
  static const recentActivity = "Recent Activity";
  static const quickActions = "Quick Actions";
  static const emergencyAlertCodeRed = "EMERGENCY ALERT: CODE RED";
  static const emergencyAlertDesc =
      "Emergency Ward • Room 502 • Triggered 7m ago";
  static const deptTuning = "DEPT TUNING";
  static const deptTuningDesc = "Adjust parameters of active clinics.";
  static const maintenance = "MAINTENANCE";
  static const maintenanceDesc = "Data backups & server health status.";

  static const present = "Present";
  static const absent = "Absent";
  static const onLeave = "On Leave";

  // Section Detail Strings
  static const viewProfile = "View Profile";
  static const editStaff = "Edit Staff";
  static const editDoctor = "Edit Doctor";
  static const supportStaff = "Support Staff";
  static const shiftPrefix = "Shift: ";
  static const yrsExpSuffix = "+ Yrs Exp";
  static const general = "General";
  static const active = "Active";
  static const away = "Away";
  static const inactive = "Inactive";

  // Appointment Details & EMR
  static const patientIdLabel = "Patient ID";
  static const patientNameLabel = "Patient Name";
  static const doctorNameLabel = "Doctor Name";
  static const specialtyLabel = "Specialty";
  static const dateLabel = "Date";
  static const timeLabel = "Time";
  static const tokenNoLabel = "Token No";
  static const viewDetails = "View Details";
  static const markAsCompleted = "Mark as Completed";
  static const viewSummary = "View Summary";
  static const appointmentDetails = "Appointment Details";
  static const ageLabel = "Age";
  static const close = "Close";
  static const vitalsInformation = "Vitals Information";
  static const bloodPressure = "Blood Pressure";
  static const weightLabel = "Weight";
  static const heightLabel = "Height";
  static const temperature = "Temperature";
  static const headCircumference = "Head Circumference";
  static const additionalNotesLabel = "Additional Notes:";
  static const noSummaryAvailable = "No Summary Available";
  static const couldNotRetrieveEmr =
      "Could not retrieve the EMR summary for this completed appointment. It might not have been recorded yet.";
  static const consultationEmrRecord = "Consultation EMR Record";
  static const datePrefix = "Date: ";
  static const generalInformation = "General Information";
  static const invoiceNumber = "Invoice Number";
  static const prescribedMedicines = "Prescribed Medicines";
  static const medicineTotal = "Medicine Total";
  static const medInvoiceNo = "Med Invoice No";
  static const diagnosticLabTests = "Diagnostic Lab Tests";
  static const labTestsTotal = "Lab Tests Total";
  static const labInvoiceNo = "Lab Invoice No";
  static const doctorsAdviceNotes = "Doctor's Advice & Notes";
  static const patientIdPrefix = "PATIENT ID: PAT-";

  // Patient Profile bottom sheet
  static const patientProfile = "Patient Profile";
  static const recentVitals = "Recent Vitals";
  static const recentConsultation = "Recent Consultation";
  static const emrPrescription = "EMR & Prescription";
  static const allergiesPrefix = "Allergies: ";
  static const bloodPrefix = "Blood: ";
  static const agePrefix = "Age: ";
  static const genderPrefix = "Gender: ";
  static const timeSlot = "Time Slot";
  static const typeLabel = "Type";
  static const invoicePdf = "Invoice PDF";
  static const shareRx = "Share Rx";
  static const consultationHistory = "Consultation History";

  // Admin Dashboard Redesign Strings
  static const specialityManagement = "Speciality Management";
  static const specialityManagementDesc =
      "Manage all hospital specialties in one place";
  static const settings = "Settings";
  static const settingsDesc = "Configure system settings and preferences";
  static const welcomeHms = "Welcome back to Hospital Management System";

  static const newPatientRegistered = "New patient registered";
  static const doctorAddedSuccessfully = "Doctor added successfully";
  static const departmentUpdatedActivity = "Department updated";
  static const userRoleChanged = "User role changed";
  static const billingConfigUpdated = "Billing configuration updated";
  static const systemBackupCompleted = "System backup completed";

  // Customer Care Redesign
  static const customerCare = "Customer Care";
  static const smartCareSubtitle = "Smart care begins with every interaction";
  static const dateRange = "Date Range";
  static const speciality = "Speciality";
  static const allSpecialities = "All Specialities";
  static const reset = "Reset";
  static const totalRegistrations = "Total Registrations";
  static const totalAppointments = "Total Appointments";
  static const totalAdmissions = "Total Admissions";
  static const feedbackScore = "Feedback Score";
  static const walkInPatients = "Walk-in Patients";
  static const followUpVisits = "Follow-up Visits";
  static const avgWaitingTime = "Avg. Waiting Time";
  static const enquiriesHandled = "Enquiries Handled";
  static const registrationDesc = "Register new patient manually";
  static const qrRegistration = "QR Registration";
  static const qrRegistrationDesc = "Scan QR code to register new patient";
  static const appointmentDesc = "Book, reschedule or manage appointments";
  static const patientSearch = "Patient Search";
  static const patientSearchDesc = "Search by UHID, phone or name & book visit";
  static const admission = "Admission";
  static const admissionDesc = "New admission & manage stays";
  static const feedback = "Feedback";
  static const feedbackDesc = "View patient feedbacks and ratings";
  static const registrationsTrendDaily = "Registrations Trend (Daily)";
  static const appointmentsTrendDaily = "Appointments Trend (Daily)";
  static const feedbackDistribution = "Feedback Distribution";
  static const visitsBySpeciality = "Visits by Speciality";
  static const lineChart = "Line Chart";
  static const barChart = "Bar Chart";
  static const sort = "Sort";
  static const excellent = "Excellent";
  static const average = "Average";
  static const poor = "Poor";
  static const totalFeedbacks = "Total Feedbacks";
  static const averageRating = "Average Rating";
  static const vsLastPeriod = "vs last period";
  static const thisPeriod = "This Period";
  static const vsLast17Days = "vs last 17 days";
  static const minsSuffix = "mins";

  AppStrings._();
}
