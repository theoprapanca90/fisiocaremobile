class AppConfig {
  static const String appName = 'FisioCare';
  static const String baseUrl = 'http://localhost:8000/api/v1'; // Ganti dengan URL API Anda
  static const String apiVersion = 'v1';
  static const String apiUrl = '$baseUrl/$apiVersion';

  // Timeout
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
}

class AppColors {
  static const primary = 0xFF2E86AB;
  static const primaryLight = 0xFF5BA8C9;
  static const primaryDark = 0xFF1A6080;
  static const secondary = 0xFF48CAE4;
  static const accent = 0xFFF4A261;
  static const success = 0xFF2DC653;
  static const warning = 0xFFF7B731;
  static const error = 0xFFE63946;
  static const background = 0xFFF5F9FC;
  static const surface = 0xFFFFFFFF;
  static const textPrimary = 0xFF1A1A2E;
  static const textSecondary = 0xFF6C757D;
  static const border = 0xFFE0E7EF;
  static const divider = 0xFFF0F4F8;
}

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Patient
  static const patientHome = '/patient/home';
  static const patientProfile = '/patient/profile';
  static const patientBooking = '/patient/booking';
  static const patientBookingDetail = '/patient/booking/detail';
  static const patientMedicalRecord = '/patient/medical-record';
  static const patientNotification = '/patient/notification';
  static const patientChat = '/patient/chat';
  static const patientReview = '/patient/review';
  static const patientAddress = '/patient/address';
  static const physiotherapistList = '/patient/physiotherapist';
  static const physiotherapistDetail = '/patient/physiotherapist/detail';
  static const serviceList = '/patient/services';

  // Physiotherapist
  static const physioHome = '/physio/home';
  static const physioProfile = '/physio/profile';
  static const physioSchedule = '/physio/schedule';
  static const physioBookings = '/physio/bookings';
  static const physioBookingDetail = '/physio/booking/detail';
  static const physioSession = '/physio/session';
  static const physioMedicalRecord = '/physio/medical-record';
  static const physioChat = '/physio/chat';

  // Admin
  static const adminHome = '/admin/home';
  static const adminUsers = '/admin/users';
  static const adminBookings = '/admin/bookings';
  static const adminPayments = '/admin/payments';
  static const adminServices = '/admin/services';
  static const adminReviews = '/admin/reviews';
  static const adminReports = '/admin/reports';
}
