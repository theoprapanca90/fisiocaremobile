import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

// Supabase
import 'core/services/supabase_service.dart';

// Routes
import 'routes/app_routes.dart';

// Theme
import 'core/theme/app_theme.dart';

// Controllers
import 'features/auth/controllers/auth_controller.dart';
import 'features/patient/controllers/patient_controller.dart';
import 'features/therapist/controllers/therapist_controller.dart';

// ── Splash (pakai yang lama tapi dimodifikasi untuk Supabase) ──
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Init format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  // 2. Init Supabase
  await SupabaseService.initialize();

  runApp(const FisioCareApp());
}

class FisioCareApp extends StatelessWidget {
  const FisioCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FisioCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Halaman pertama yang dibuka
      home: const SplashPage(),

      // Daftar semua route
      getPages: AppRoutes.pages,
    );
  }
}

// ================================================================
// SPLASH PAGE (menggantikan splash_screen lama yang pakai Provider)
// Cek session Supabase → arahkan ke halaman yang sesuai role
// ================================================================
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Animasi fade + scale
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _animCtrl.forward();

    _checkSession();
  }

  Future<void> _checkSession() async {
    // Tunggu animasi selesai minimal 2 detik
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    // Daftarkan AuthController via GetX
    final authController = Get.put(AuthController());

    // Tunggu sebentar agar AuthController sempat load session
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final session = SupabaseService.auth.currentSession;

    if (session == null) {
      // Belum login → ke halaman Login
      Get.offAllNamed(AppRoutes.login);
    } else {
      // Sudah login → cek role dan arahkan
      final user = authController.currentUser.value;
      if (user == null) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      if (user.isPatient) {
        // Daftarkan PatientController
        Get.put(PatientController());
        Get.offAllNamed(AppRoutes.patientDashboard);
      } else if (user.isTherapist) {
        // Daftarkan TherapistController
        Get.put(TherapistController());
        Get.offAllNamed(AppRoutes.therapistDashboard);
      } else {
        // Admin → ke login dulu (belum ada admin dashboard di GetX)
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.health_and_safety,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nama App
                const Text(
                  'FisioCare',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Homecare Fisioterapi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 48),

                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
