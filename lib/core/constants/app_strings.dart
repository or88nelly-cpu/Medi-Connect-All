import 'package:easy_localization/easy_localization.dart';

/// Centralized string constants for localization and UI text.
/// Ensures no hardcoded raw strings are used directly in pages/widgets.
class AppStrings {
  // Common Buttons & Actions
  static String get login => "login".tr();
  static String get signup => "signup".tr();
  static String get register => "register".tr();
  static String get verify => "verify".tr();
  static String get submit => "submit".tr();
  static String get cancel => "cancel".tr();
  static String get confirm => "confirm".tr();

  static String get next => "next".tr();
  static String get back => "back".tr();
  static String get skip => "skip".tr();
  static String get getStarted => "getStarted".tr();
  static String get retry => "retry".tr();
  static String get logout => "logout".tr();
  static String get completePayment => "completePayment".tr();
  static String get selectPaymentMethod => "selectPaymentMethod".tr();
  static String get payViaQRCode => "payViaQRCode".tr();
  static String get scanUpiPrompt => "scanUpiPrompt".tr();
  static String get payAtCounter => "payAtCounter".tr();
  static String get payAtCounterDesc => "payAtCounterDesc".tr();
  static String get upiQrPayment => "upiQrPayment".tr();
  static String get scanToCompletePay => "scanToCompletePay".tr();
  static String get secureUpiGateway => "secureUpiGateway".tr();
  static String get confirmPaymentBtn => "confirmPaymentBtn".tr();

  // Onboarding / Profile Completion
  static String get completeYourProfile => "completeYourProfile".tr();
  static String get patientRegistrationTitle => "patientRegistrationTitle".tr();
  static String get stepOf => "stepOf".tr(); // used as "Step 1 of 3"
  static String get basicInformation => "basicInformation".tr();
  static String get additionalInformation => "additionalInformation".tr();
  static String get reviewAndConfirm => "reviewAndConfirm".tr();
  static String get idCardDownloadStarted => "idCardDownloadStarted".tr();

  // Navigation / Features
  static String get appointment => "appointment".tr();
  static String get appointments => "appointments".tr();
  static String get chat => "chat".tr();
  static String get consultations => "consultations".tr();
  static String get medicalRecords => "medicalRecords".tr();
  static String get dietPlans => "dietPlans".tr();
  static String get exercise_plans => "exercise_plans".tr();
  static String get notifications => "notifications".tr();
  static String get profile => "profile".tr();
  static String get payments => "payments".tr();
  static String get dashboard => "dashboard".tr();
  static String get availableBeds => "availableBeds".tr();

  // Authentication & Onboarding
  static String get splashTitle => "splashTitle".tr();
  static String get splashSubtitle => "splashSubtitle".tr();
  static String get onboardingTitle1 => "onboardingTitle1".tr();
  static String get onboardingDesc1 => "onboardingDesc1".tr();
  static String get onboardingTitle2 => "onboardingTitle2".tr();
  static String get onboardingDesc2 => "onboardingDesc2".tr();
  static String get onboardingTitle3 => "onboardingTitle3".tr();
  static String get onboardingDesc3 => "onboardingDesc3".tr();

  static String get welcomeBack => "welcomeBack".tr();
  static String get signInSubtitle => "signInSubtitle".tr();
  static String get emailAddress => "emailAddress".tr();
  static String get enterEmail => "enterEmail".tr();
  static String get password => "password".tr();
  static String get enterPassword => "enterPassword".tr();
  static String get forgotPasswordQuestion => "forgotPasswordQuestion".tr();
  static String get dontHaveAccount => "dontHaveAccount".tr();

  static String get createAccount => "createAccount".tr();
  static String get registerSubtitle => "registerSubtitle".tr();
  static String get registerAs => "registerAs".tr();
  static String get fullName => "fullName".tr();
  static String get enterFullName => "enterFullName".tr();
  static String get phoneNumber => "phoneNumber".tr();
  static String get enterPhone => "enterPhone".tr();
  static String get alreadyHaveAccount => "alreadyHaveAccount".tr();

  static String get forgotPasswordTitle => "forgotPasswordTitle".tr();
  static String get forgotPasswordDesc => "forgotPasswordDesc".tr();
  static String get resetPasswordTitle => "resetPasswordTitle".tr();
  static String get resetPasswordDesc => "resetPasswordDesc".tr();
  static String get otpVerificationTitle => "otpVerificationTitle".tr();
  static String get otpVerificationDesc => "otpVerificationDesc".tr();
  static String get resendCode => "resendCode".tr();
  static String get confirmSignOut => "confirmSignOut".tr();

  // Validation & Errors
  static String get requiredField => "requiredField".tr();
  static String get invalidEmail => "invalidEmail".tr();
  static String get invalidPhone => "invalidPhone".tr();
  static String get passwordTooShort => "passwordTooShort".tr();
  static String get genericError => "genericError".tr();
  static String get otpInvalid => "otpInvalid".tr();
  static String get passwordMismatch => "passwordMismatch".tr();

  // Dialog & State Texts
  static String get success => "success".tr();
  static String get error => "error".tr();
  static String get alert => "alert".tr();
  static String get failedToLoad => "failedToLoad".tr();
  static String get noData => "noData".tr();
  static String get noRecords => "noRecords".tr();

  // Dashboard & Module Titles
  static String get welcomeUser => "welcomeUser".tr();
  static String get drUser => "drUser".tr();
  static String get patientDashboardTitle => "patientDashboardTitle".tr();
  static String get doctorDashboardTitle => "doctorDashboardTitle".tr();
  static String get staffDashboardTitle => "staffDashboardTitle".tr();
  static String get adminDashboardTitle => "adminDashboardTitle".tr();
  static String get adminWebDashboardTitle => "adminWebDashboardTitle".tr();
  static String get websiteDashboardTitle => "websiteDashboardTitle".tr();
  static String get publicWebsiteTitle => "publicWebsiteTitle".tr();

  static String get appointmentsModule => "appointmentsModule".tr();
  static String get chatModule => "chatModule".tr();
  static String get medicalRecordsModule => "medicalRecordsModule".tr();
  static String get profileModule => "profileModule".tr();
  static String get paymentsModule => "paymentsModule".tr();
  static String get videoConsultationModule => "videoConsultationModule".tr();
  static String get dietPlansModule => "dietPlansModule".tr();
  static String get exercisePlansModule => "exercisePlansModule".tr();
  static String get notificationsModule => "notificationsModule".tr();
  static String get analyticsModule => "analyticsModule".tr();
  static String get postModule => "postModule".tr();

  static String get appointmentsModuleDesc => "appointmentsModuleDesc".tr();
  static String get chatModuleDesc => "chatModuleDesc".tr();
  static String get medicalRecordsModuleDesc => "medicalRecordsModuleDesc".tr();
  static String get profileModuleDesc => "profileModuleDesc".tr();
  static String get paymentsModuleDesc => "paymentsModuleDesc".tr();
  static String get videoConsultationModuleDesc =>
      "videoConsultationModuleDesc".tr();
  static String get dietPlansModuleDesc => "dietPlansModuleDesc".tr();
  static String get exercisePlansModuleDesc => "exercisePlansModuleDesc".tr();
  static String get notificationsModuleDesc => "notificationsModuleDesc".tr();
  static String get analyticsModuleDesc => "analyticsModuleDesc".tr();
  static String get postModuleDesc => "postModuleDesc".tr();

  // Dedicated Portal & Admin Login/Signup Strings
  static String get adminSignUpTitle => "adminSignUpTitle".tr();
  static String get adminSignUpSubtitle => "adminSignUpSubtitle".tr();
  static String get adminUsername => "adminUsername".tr();
  static String get chooseUsername => "chooseUsername".tr();
  static String get createPasswordLabel => "createPasswordLabel".tr();
  static String get confirmPasswordLabel => "confirmPasswordLabel".tr();
  static String get confirmPasswordHint => "confirmPasswordHint".tr();
  static String get agreeToTerms => "agreeToTerms".tr();
  static String get termsOfService => "termsOfService".tr();
  static String get privacyPolicy => "privacyPolicy".tr();
  static String get alreadyHaveAccountSignIn => "alreadyHaveAccountSignIn".tr();
  static String get adminLoginTitle => "adminLoginTitle".tr();
  static String get adminLoginSubtitle => "adminLoginSubtitle".tr();
  static String get username => "username".tr();
  static String get enterUsername => "enterUsername".tr();
  static String get rememberMe => "rememberMe".tr();
  static String get orDivider => "orDivider".tr();
  static String get loginWithOtp => "loginWithOtp".tr();
  static String get dontHaveAccountSignUp => "dontHaveAccountSignUp".tr();
  static String get adminPortalTitle => "adminPortalTitle".tr();
  static String get adminPortalDesc => "adminPortalDesc".tr();
  static String get accessAdminPortal => "accessAdminPortal".tr();
  static String get patientPortalTitle => "patientPortalTitle".tr();
  static String get patientPortalDesc => "patientPortalDesc".tr();
  static String get accessPatientPortal => "accessPatientPortal".tr();
  static String get doctorPortalTitle => "doctorPortalTitle".tr();
  static String get doctorPortalDesc => "doctorPortalDesc".tr();
  static String get accessDoctorPortal => "accessDoctorPortal".tr();
  static String get staffPortalTitle => "staffPortalTitle".tr();
  static String get staffPortalDesc => "staffPortalDesc".tr();
  static String get accessStaffPortal => "accessStaffPortal".tr();
  static String get selectPortalAccess => "selectPortalAccess".tr();
  static String get selectPortalAccessSubtitle =>
      "selectPortalAccessSubtitle".tr();
  static String get backToOnboarding => "backToOnboarding".tr();
  static String get loginAs => "loginAs".tr();
  static String get enterCredentialsToEnter => "enterCredentialsToEnter".tr();
  static String get enterprisePortalManagement =>
      "enterprisePortalManagement".tr();

  // Brand details
  static String get brandMedi => "brandMedi".tr();
  static String get brandConnect => "brandConnect".tr();
  static String get brandSlogan => "brandSlogan".tr();

  // Consent
  static String get agreeToTermsPrefix => "agreeToTermsPrefix".tr();
  static String get agreeToTermsAnd => "agreeToTermsAnd".tr();

  // Role Profile access descriptions
  static String get patientAccessProfileDesc => "patientAccessProfileDesc".tr();
  static String get doctorAccessProfileDesc => "doctorAccessProfileDesc".tr();
  static String get staffAccessProfileDesc => "staffAccessProfileDesc".tr();

  // Profile Completion Page Strings
  static String get ok => "ok".tr();
  static String get submissionError => "submissionError".tr();
  static String get patientProfileOnboarding => "patientProfileOnboarding".tr();
  static String get doctorProfessionalRegistration =>
      "doctorProfessionalRegistration".tr();
  static String get medicalStaffRegistration => "medicalStaffRegistration".tr();
  static String get adminProfileSetup => "adminProfileSetup".tr();
  static String get patientProfileOnboardingDesc =>
      "patientProfileOnboardingDesc".tr();
  static String get doctorProfessionalRegistrationDesc =>
      "doctorProfessionalRegistrationDesc".tr();
  static String get medicalStaffRegistrationDesc =>
      "medicalStaffRegistrationDesc".tr();
  static String get adminProfileSetupDesc => "adminProfileSetupDesc".tr();
  static String get completeProfileSetup => "completeProfileSetup".tr();
  static String get gender => "gender".tr();
  static String get male => "male".tr();
  static String get female => "female".tr();
  static String get other => "other".tr();
  static String get medicalDepartment => "medicalDepartment".tr();
  static String get professionalQualifications =>
      "professionalQualifications".tr();
  static String get areaOfSpecialty => "areaOfSpecialty".tr();
  static String get staffDepartment => "staffDepartment".tr();
  static String get assignedWorkShift => "assignedWorkShift".tr();
  static String get day => "day".tr();
  static String get night => "night".tr();
  static String get rotational => "rotational".tr();

  // Dashboard Strings
  static String get administrator => "administrator".tr();
  static String get accessLevelSuperAdmin => "accessLevelSuperAdmin".tr();
  static String get analyticsOverview => "analyticsOverview".tr();
  static String get doctors => "doctors".tr();
  static String get staff => "staff".tr();
  static String get patients => "patients".tr();
  static String get videoConsults => "videoConsults".tr();
  static String get totalRevenue => "totalRevenue".tr();
  static String get weeklyRevenueTrend => "weeklyRevenueTrend".tr();
  static String get departmentDistribution => "departmentDistribution".tr();
  static String get errorFetchingAnalytics => "errorFetchingAnalytics".tr();
  static String get docsLabel => "docsLabel".tr();
  static String get managementConsole => "managementConsole".tr();
  static String get doctorsDirectory => "doctorsDirectory".tr();
  static String get doctorsDirectoryDesc => "doctorsDirectoryDesc".tr();
  static String get staffDirectory => "staffDirectory".tr();
  static String get staffDirectoryDesc => "staffDirectoryDesc".tr();
  static String get patientsDirectory => "patientsDirectory".tr();
  static String get patientsDirectoryDesc => "patientsDirectoryDesc".tr();
  static String get systemOperations => "systemOperations".tr();
  static String get slotConfig => "slotConfig".tr();
  static String get slotConfigDesc => "slotConfigDesc".tr();
  static String get auditLogs => "auditLogs".tr();
  static String get auditLogsDesc => "auditLogsDesc".tr();
  static String get notificationLogs => "notificationLogs".tr();
  static String get notificationLogsDesc => "notificationLogsDesc".tr();
  static String get masterData => "masterData".tr();
  static String get masterDataDesc => "masterDataDesc".tr();

  // Role Selection (Signup)
  static String get selectRole => "selectRole".tr();
  static String get chooseYourRole => "chooseYourRole".tr();
  static String get roleAdmin => "roleAdmin".tr();
  static String get roleDoctor => "roleDoctor".tr();
  static String get roleStaff => "roleStaff".tr();
  static String get rolePatient => "rolePatient".tr();

  // Department Module
  static String get departments => "departments".tr();
  static String get sections => "sections".tr();
  static String get departmentsTitle => "departmentsTitle".tr();
  static String get addDepartment => "addDepartment".tr();
  static String get editDepartment => "editDepartment".tr();
  static String get deleteDepartment => "deleteDepartment".tr();
  static String get viewAll => "viewAll".tr();
  static String get viewLess => "viewLess".tr();
  static String get noDepartments => "noDepartments".tr();
  static String get departmentNameLabel => "departmentNameLabel".tr();
  static String get departmentNameHint => "departmentNameHint".tr();
  static String get departmentDescLabel => "departmentDescLabel".tr();
  static String get departmentDescHint => "departmentDescHint".tr();
  static String get departmentImageLabel => "departmentImageLabel".tr();
  static String get departmentImageHint => "departmentImageHint".tr();
  static String get duplicateDepartment => "duplicateDepartment".tr();
  static String get confirmDeleteDepartment => "confirmDeleteDepartment".tr();
  static String get departmentCreated => "departmentCreated".tr();
  static String get departmentUpdated => "departmentUpdated".tr();
  static String get departmentDeleted => "departmentDeleted".tr();

  // Patient Dashboard
  static String get upcomingAppointments => "upcomingAppointments".tr();
  static String get myRecords => "myRecords".tr();
  static String get findDoctor => "findDoctor".tr();
  static String get healthTips => "healthTips".tr();
  static String get noUpcomingAppointments => "noUpcomingAppointments".tr();
  static String get bookAppointment => "bookAppointment".tr();
  static String get patientQuickActions => "patientQuickActions".tr();

  // Doctor Dashboard
  static String get goodMorning => "goodMorning".tr();
  static String get goodAfternoon => "goodAfternoon".tr();
  static String get goodEvening => "goodEvening".tr();
  static String get todaySchedule => "todaySchedule".tr();
  static String get myPatients => "myPatients".tr();
  static String get activeConsultations => "activeConsultations".tr();
  static String get doctorQuickActions => "doctorQuickActions".tr();
  static String get noScheduleToday => "noScheduleToday".tr();
  static String get startConsultation => "startConsultation".tr();
  static String get opInfoTitle => "opInfoTitle".tr();
  static String get opInfoSubtitle => "opInfoSubtitle".tr();
  static String get opInfoTodaysDate => "opInfoTodaysDate".tr();
  static String get opInfoTodaysAppointments => "opInfoTodaysAppointments".tr();
  static String get opInfoSearchHint => "opInfoSearchHint".tr();
  static String get opInfoTotalProcedures => "opInfoTotalProcedures".tr();
  static String get opInfoPendingProcedures => "opInfoPendingProcedures".tr();
  static String get opInfoCompletedProcedures =>
      "opInfoCompletedProcedures".tr();
  static String get opInfoCancelledProcedures =>
      "opInfoCancelledProcedures".tr();
  static String get opInfoFilterAll => "opInfoFilterAll".tr();
  static String get opInfoFilterPending => "opInfoFilterPending".tr();
  static String get opInfoFilterCompleted => "opInfoFilterCompleted".tr();
  static String get opInfoFilterCancelled => "opInfoFilterCancelled".tr();
  static String get outPatients => "outPatients".tr();
  static String get ipInfoTitle => "ipInfoTitle".tr();
  static String get ipInfoSubtitle => "ipInfoSubtitle".tr();
  static String get opProceduresTitle => "opProceduresTitle".tr();
  static String get opProceduresSubtitle => "opProceduresSubtitle".tr();
  static String get ipProceduresTitle => "ipProceduresTitle".tr();
  static String get ipProceduresSubtitle => "ipProceduresSubtitle".tr();
  static String get surgeriesTitle => "surgeriesTitle".tr();
  static String get surgeriesSubtitle => "surgeriesSubtitle".tr();
  static String get medicalCertificatesTitle => "medicalCertificatesTitle".tr();
  static String get medicalCertificatesSubtitle =>
      "medicalCertificatesSubtitle".tr();
  static String get pendingMrdTitle => "pendingMrdTitle".tr();
  static String get pendingMrdSubtitle => "pendingMrdSubtitle".tr();
  static String get slotConfigTitle => "slotConfigTitle".tr();
  static String get slotConfigSubtitle => "slotConfigSubtitle".tr();
  static String get slotConfigManage => "slotConfigManage".tr();

  // Staff Dashboard
  static String get myTasks => "myTasks".tr();
  static String get shiftInfo => "shiftInfo".tr();
  static String get roster => "roster".tr();
  static String get currentShift => "currentShift".tr();
  static String get staffQuickActions => "staffQuickActions".tr();
  static String get noTasksAssigned => "noTasksAssigned".tr();

  // Terminal theme strings
  static String get authRequired => "authRequired".tr();
  static String get terminalIdLabel => "terminalIdLabel".tr();
  static String get terminalIdHint => "terminalIdHint".tr();
  static String get accessKeyLabel => "accessKeyLabel".tr();
  static String get passwordHintDots => "passwordHintDots".tr();
  static String get forgotLabel => "forgotLabel".tr();
  static String get persistentSession => "persistentSession".tr();
  static String get initializeAccess => "initializeAccess".tr();
  static String get terminalLocationNode => "terminalLocationNode".tr();
  static String get unregisteredRequestAccess =>
      "unregisteredRequestAccess".tr();
  static String get unregistered => "unregistered".tr();
  static String get requestAccessSignUp => "requestAccessSignUp".tr();
  static String get opsStable => "opsStable".tr();
  static String get createAccountTitle => "createAccountTitle".tr();
  static String get registerSubtitleTerminal => "registerSubtitleTerminal".tr();
  static String get selectYourRole => "selectYourRole".tr();
  static String get legalNameLabel => "legalNameLabel".tr();
  static String get legalNameHint => "legalNameHint".tr();
  static String get clinicalEmailLabel => "clinicalEmailLabel".tr();
  static String get clinicalEmailHint => "clinicalEmailHint".tr();
  static String get securityPasswordLabel => "securityPasswordLabel".tr();
  static String get hipaaAcknowledgePrefix => "hipaaAcknowledgePrefix".tr();
  static String get hipaaComplianceTerms => "hipaaComplianceTerms".tr();
  static String get andGeneral => "andGeneral".tr();
  static String get privacyProtocol => "privacyProtocol".tr();
  static String get forMedicalDataHandling => "forMedicalDataHandling".tr();
  static String get finalizeRegistration => "finalizeRegistration".tr();
  static String get clinicalOpsVersion => "clinicalOpsVersion".tr();
  static String get secureEncryptedEnv => "secureEncryptedEnv".tr();
  static String get hipaaAgreementError => "hipaaAgreementError".tr();

  // New dashboard and operations strings
  static String get realTime => "realTime".tr();
  static String get runAll => "runAll".tr();
  static String get inStock => "inStock".tr();
  static String get expired => "expired".tr();
  static String get outOfStock => "outOfStock".tr();
  static String get totalTests => "totalTests".tr();
  static String get pending => "pending".tr();
  static String get criticalAlerts => "criticalAlerts".tr();
  static String get capacityUtilization => "capacityUtilization".tr();
  static String get totalThisWeek => "totalThisWeek".tr();
  static String get weeklyConsultationAppointments =>
      "weeklyConsultationAppointments".tr();
  static String get appointmentSummaryGraph => "appointmentSummaryGraph".tr();
  static String get pharmacySummary => "pharmacySummary".tr();
  static String get recentActivity => "recentActivity".tr();
  static String get quickActions => "quickActions".tr();
  static String get emergencyAlertCodeRed => "emergencyAlertCodeRed".tr();
  static String get emergencyAlertDesc => "emergencyAlertDesc".tr();
  static String get deptTuning => "deptTuning".tr();
  static String get deptTuningDesc => "deptTuningDesc".tr();
  static String get maintenance => "maintenance".tr();
  static String get maintenanceDesc => "maintenanceDesc".tr();

  static String get present => "present".tr();
  static String get absent => "absent".tr();
  static String get onLeave => "onLeave".tr();

  // Section Detail Strings
  static String get viewProfile => "viewProfile".tr();
  static String get editStaff => "editStaff".tr();
  static String get editDoctor => "editDoctor".tr();
  static String get supportStaff => "supportStaff".tr();
  static String get shiftPrefix => "shiftPrefix".tr();
  static String get yrsExpSuffix => "yrsExpSuffix".tr();
  static String get general => "general".tr();
  static String get active => "active".tr();
  static String get away => "away".tr();
  static String get inactive => "inactive".tr();

  // Appointment Details & EMR
  static String get patientIdLabel => "patientIdLabel".tr();
  static String get patientNameLabel => "patientNameLabel".tr();
  static String get doctorNameLabel => "doctorNameLabel".tr();
  static String get specialtyLabel => "specialtyLabel".tr();
  static String get dateLabel => "dateLabel".tr();
  static String get timeLabel => "timeLabel".tr();
  static String get tokenNoLabel => "tokenNoLabel".tr();
  static String get viewDetails => "viewDetails".tr();
  static String get markAsCompleted => "markAsCompleted".tr();
  static String get viewSummary => "viewSummary".tr();
  static String get appointmentDetails => "appointmentDetails".tr();
  static String get ageLabel => "ageLabel".tr();
  static String get close => "close".tr();
  static String get vitalsInformation => "vitalsInformation".tr();
  static String get bloodPressure => "bloodPressure".tr();
  static String get weightLabel => "weightLabel".tr();
  static String get heightLabel => "heightLabel".tr();
  static String get temperature => "temperature".tr();
  static String get headCircumference => "headCircumference".tr();
  static String get additionalNotesLabel => "additionalNotesLabel".tr();
  static String get noSummaryAvailable => "noSummaryAvailable".tr();
  static String get couldNotRetrieveEmr => "couldNotRetrieveEmr".tr();
  static String get consultationEmrRecord => "consultationEmrRecord".tr();
  static String get datePrefix => "datePrefix".tr();
  static String get generalInformation => "generalInformation".tr();
  static String get invoiceNumber => "invoiceNumber".tr();
  static String get prescribedMedicines => "prescribedMedicines".tr();
  static String get medicineTotal => "medicineTotal".tr();
  static String get medInvoiceNo => "medInvoiceNo".tr();
  static String get diagnosticLabTests => "diagnosticLabTests".tr();
  static String get labTestsTotal => "labTestsTotal".tr();
  static String get labInvoiceNo => "labInvoiceNo".tr();
  static String get doctorsAdviceNotes => "doctorsAdviceNotes".tr();
  static String get patientIdPrefix => "patientIdPrefix".tr();

  // Patient Profile bottom sheet
  static String get patientProfile => "patientProfile".tr();
  static String get recentVitals => "recentVitals".tr();
  static String get recentConsultation => "recentConsultation".tr();
  static String get emrPrescription => "emrPrescription".tr();
  static String get allergiesPrefix => "allergiesPrefix".tr();
  static String get bloodPrefix => "bloodPrefix".tr();
  static String get agePrefix => "agePrefix".tr();
  static String get genderPrefix => "genderPrefix".tr();
  static String get timeSlot => "timeSlot".tr();
  static String get typeLabel => "typeLabel".tr();
  static String get invoicePdf => "invoicePdf".tr();
  static String get shareRx => "shareRx".tr();
  static String get consultationHistory => "consultationHistory".tr();

  // Admin Dashboard Redesign Strings
  static String get specialityManagement => "specialityManagement".tr();
  static String get specialityManagementDesc => "specialityManagementDesc".tr();
  static String get settings => "settings".tr();
  static String get settingsDesc => "settingsDesc".tr();
  static String get welcomeHms => "welcomeHms".tr();

  static String get newPatientRegistered => "newPatientRegistered".tr();
  static String get doctorAddedSuccessfully => "doctorAddedSuccessfully".tr();
  static String get departmentUpdatedActivity =>
      "departmentUpdatedActivity".tr();
  static String get userRoleChanged => "userRoleChanged".tr();
  static String get billingConfigUpdated => "billingConfigUpdated".tr();
  static String get systemBackupCompleted => "systemBackupCompleted".tr();

  // Customer Care Redesign
  static String get customerCare => "customerCare".tr();
  static String get smartCareSubtitle => "smartCareSubtitle".tr();
  static String get dateRange => "dateRange".tr();
  static String get speciality => "speciality".tr();
  static String get allSpecialities => "allSpecialities".tr();
  static String get reset => "reset".tr();
  static String get totalRegistrations => "totalRegistrations".tr();
  static String get totalAppointments => "totalAppointments".tr();
  static String get totalAdmissions => "totalAdmissions".tr();
  static String get feedbackScore => "feedbackScore".tr();
  static String get walkInPatients => "walkInPatients".tr();
  static String get followUpVisits => "followUpVisits".tr();
  static String get avgWaitingTime => "avgWaitingTime".tr();
  static String get enquiriesHandled => "enquiriesHandled".tr();
  static String get registrationDesc => "registrationDesc".tr();
  static String get qrRegistration => "qrRegistration".tr();
  static String get qrRegistrationDesc => "qrRegistrationDesc".tr();
  static String get appointmentDesc => "appointmentDesc".tr();
  static String get patientSearch => "patientSearch".tr();
  static String get patientSearchDesc => "patientSearchDesc".tr();
  static String get admission => "admission".tr();
  static String get admissionDesc => "admissionDesc".tr();
  static String get feedback => "feedback".tr();
  static String get feedbackDesc => "feedbackDesc".tr();
  static String get registrationsTrendDaily => "registrationsTrendDaily".tr();
  static String get appointmentsTrendDaily => "appointmentsTrendDaily".tr();
  static String get feedbackDistribution => "feedbackDistribution".tr();
  static String get visitsBySpeciality => "visitsBySpeciality".tr();
  static String get lineChart => "lineChart".tr();
  static String get barChart => "barChart".tr();
  static String get sort => "sort".tr();
  static String get excellent => "excellent".tr();
  static String get average => "average".tr();
  static String get poor => "poor".tr();
  static String get totalFeedbacks => "totalFeedbacks".tr();
  static String get averageRating => "averageRating".tr();
  static String get vsLastPeriod => "vsLastPeriod".tr();
  static String get thisPeriod => "thisPeriod".tr();
  static String get vsLast17Days => "vsLast17Days".tr();
  static String get minsSuffix => "minsSuffix".tr();

  // Admin Control Center & Department Details
  static String get hospitalControlCenter => "hospitalControlCenter".tr();
  static String get controlCenterSubtitle => "controlCenterSubtitle".tr();
  static String get searchModulesPlaceholder => "searchModulesPlaceholder".tr();
  static String get welcomeBackAdmin => "welcomeBackAdmin".tr();
  static String get goPremium => "goPremium".tr();
  static String get goPremiumDesc => "goPremiumDesc".tr();
  static String get upgradeNow => "upgradeNow".tr();
  static String get departmentDetailsTitle => "departmentDetailsTitle".tr();
  static String get departmentDetailsSubtitle =>
      "departmentDetailsSubtitle".tr();
  static String get gridView => "gridView".tr();
  static String get tableView => "tableView".tr();
  static String get departmentName => "departmentName".tr();
  static String get departmentCode => "departmentCode".tr();
  static String get headOfDepartment => "headOfDepartment".tr();
  static String get totalStaff => "totalStaff".tr();
  static String get totalDoctors => "totalDoctors".tr();
  static String get status => "status".tr();
  static String get actions => "actions".tr();

  static String get superAdmin => "superAdmin".tr();
  static String get mediConnectBrand => "mediConnectBrand".tr();
  static String get hospitalPlatform => "hospitalPlatform".tr();
  static String get departmentSearchPlaceholder =>
      "departmentSearchPlaceholder".tr();
  static String get deptPrefix => "deptPrefix".tr();
  static String get unassignedDoctor => "unassignedDoctor".tr();
  static String get notificationCountDefault => "notificationCountDefault".tr();
  static String get staffSuffix => "staffSuffix".tr();
  static String get doctorsSuffix => "doctorsSuffix".tr();
  static String get noMatchingModules => "noMatchingModules".tr();
  static String get noDepartmentsFound => "noDepartmentsFound".tr();

  AppStrings._();
}
