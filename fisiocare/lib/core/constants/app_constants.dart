import 'package:flutter/material.dart';

class AppColors {
  // Primary - Teal/Green dari Figma
  static const Color primary = Color(0xFF009689);
  static const Color primaryDark = Color(0xFF009689);
  static const Color primaryLight = Color(0xFF00BBa7);
  static const Color primaryGradientStart = Color(0xFF00BBa7);
  static const Color primaryGradientEnd = Color(0xFF009689);

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF); // ← FIX: ganti Colors.white
  static const Color cardBg = Color(0xFFFFFFFF); // ← FIX: ganti Colors.white

  // Text
  static const Color textPrimary = Color(0xFF0F172B);
  static const Color textSecondary = Color(0xFF45556C);
  static const Color textMuted = Color(0xFF62748E);
  static const Color textHint = Color(0xFF717182);
  static const Color textDark = Color(0xFF0A0A0A);

  // Input
  static const Color inputBg = Color(0xFFF3F3F5);
  static const Color inputBorder = Color(0x1A000000);

  // Border
  static const Color border = Color(0x1A000000);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Misc
  static const Color divider = Color(0xFFE2E8F0);
  static const Color mint = Color(0xFFCBFBF1);
  static const Color tabBarBg = Color(0xFFECECF0);
}

class AppSizes {
  // Padding
  static const double paddingXS = 4;
  static const double paddingSM = 8;
  static const double paddingMD = 12;
  static const double paddingLG = 16;
  static const double paddingXL = 20;
  static const double paddingXXL = 24;

  // Border Radius
  static const double radiusSM = 8;
  static const double radiusMD = 10;
  static const double radiusLG = 14;
  static const double radiusXL = 20;
  static const double radiusFull = 999;

  // Icon sizes
  static const double iconSM = 16;
  static const double iconMD = 20;
  static const double iconLG = 24;

  // Font sizes
  static const double fontXS = 12;
  static const double fontSM = 14;
  static const double fontMD = 16;
  static const double fontLG = 18;
  static const double fontXL = 20;
  static const double fontXXL = 24;
  static const double fontTitle = 30;
}

class AppStrings {
  static const String appName = 'FisioCare';
  static const String tagline = 'Homecare Fisioterapi';

  // Auth
  static const String login = 'Masuk ke Akun';
  static const String register = 'Daftar';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Lupa password?';
  static const String btnLogin = 'Masuk';
  static const String noAccount = 'Belum punya akun? ';
  static const String registerAsPatient = 'Daftar sebagai Pasien';
  static const String hasAccount = 'Sudah punya akun? ';
  static const String loginHere = 'Masuk di sini';
  static const String terms = 'Dengan masuk, Anda menyetujui Syarat & Ketentuan kami';

  // Patient
  static const String patient = 'Pasien';
  static const String therapist = 'Fisioterapis';
  static const String registerPatient = 'Daftar Pasien';
  static const String registerPatientSub = 'Buat akun untuk layanan fisioterapi';
  static const String registerTherapist = 'Daftar Fisioterapis';

  // Form
  static const String fullName = 'Nama Lengkap *';
  static const String phoneNumber = 'Nomor Telepon *';
  static const String birthDate = 'Tanggal Lahir';
  static const String gender = 'Jenis Kelamin';
  static const String address = 'Alamat';
  static const String medicalHistory = 'Riwayat Penyakit (Opsional)';
  static const String personalInfo = 'Informasi Pribadi';
  static const String medicalInfo = 'Informasi Medis';

  // Navigation
  static const String navHome = 'Beranda';
  static const String navSchedule = 'Jadwal';
  static const String navExercise = 'Latihan';
  static const String navEducation = 'Edukasi';
  static const String navProfile = 'Profil';

  // Therapist Nav
  static const String navDashboard = 'Dashboard';
  static const String navPatients = 'Pasien';
  static const String navReports = 'Laporan';
}
