/// Route paths and names constants used by GoRouter across the applications.
class RouteNames {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const otpVerification = '/otp-verification';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const profileCompletion = '/profile-completion';

  // Role-based main landing pages
  static const patientDashboard = '/patient/dashboard';
  static const doctorDashboard = '/doctor/dashboard';
  static const staffDashboard = '/staff/dashboard';
  static const adminDashboard = '/admin/dashboard';

  // Inner feature screens
  static const appointments = 'appointments';
  static const chat = 'chat';
  static const videoConsultation = 'video-consultation';
  static const medicalRecords = 'medical-records';
  static const dietPlans = 'diet-plans';
  static const exercisePlans = 'exercise-plans';
  static const notifications = 'notifications';
  static const profile = 'profile';
  static const payments = 'payments';
  static const posts = 'posts';

  RouteNames._();
}
