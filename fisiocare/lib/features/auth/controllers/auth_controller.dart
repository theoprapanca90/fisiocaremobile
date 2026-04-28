import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/models/app_models.dart';
import '../../../routes/app_routes.dart';

enum UserRole { patient, therapist, admin }

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxInt loginTabIndex = 0.obs;
  final Rxn<UserRole> currentRole = Rxn<UserRole>();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final Rxn<PatientProfileModel> patientProfile = Rxn<PatientProfileModel>();
  final Rxn<TherapistProfileModel> therapistProfile = Rxn<TherapistProfileModel>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final medicalHistoryCtrl = TextEditingController();
  final birthDateCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final strNoCtrl = TextEditingController();
  final specializationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  SupabaseClient get _db => SupabaseService.client;

  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = _db.auth.currentSession;
    if (session != null) {
      await _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final email = _db.auth.currentUser?.email;
      if (email == null) return;

      final userData = await _db
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (userData == null) return;

      final user = UserModel.fromMap(userData);
      currentUser.value = user;

      if (user.isPatient) {
        currentRole.value = UserRole.patient;
        final profileData = await _db
            .from('patient_profiles')
            .select()
            .eq('user_id', user.id)
            .maybeSingle();
        if (profileData != null) {
          patientProfile.value = PatientProfileModel.fromMap(profileData);
        }
        Get.offAllNamed(AppRoutes.patientDashboard);
      } else if (user.isTherapist) {
        currentRole.value = UserRole.therapist;
        final profileData = await _db
            .from('physiotherapist_profiles')
            .select()
            .eq('user_id', user.id)
            .maybeSingle();
        if (profileData != null) {
          therapistProfile.value = TherapistProfileModel.fromMap(profileData);
        }
        Get.offAllNamed(AppRoutes.therapistDashboard);
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    usernameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    medicalHistoryCtrl.dispose();
    birthDateCtrl.dispose();
    genderCtrl.dispose();
    strNoCtrl.dispose();
    specializationCtrl.dispose();
    experienceCtrl.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void setLoginTab(int index) => loginTabIndex.value = index;

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final response = await _db.auth.signInWithPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      if (response.user == null) {
        _showError('Login gagal', 'Email atau password salah');
        return;
      }
      await _loadUserData();
    } on AuthException catch (e) {
      _showError('Login gagal', _translateAuthError(e.message));
    } catch (e) {
      _showError('Login gagal', 'Terjadi kesalahan, coba lagi');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerPatient() async {
    if (!registerFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final response = await _db.auth.signUp(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      if (response.user == null) {
        _showError('Registrasi gagal', 'Tidak dapat membuat akun');
        return;
      }

      final userInsert = await _db.from('users').insert({
        'role_id': 2,
        'name': nameCtrl.text.trim(),
        'username': emailCtrl.text.split('@').first,
        'email': emailCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'status_akun': 'active',
        'password': 'supabase_auth',
      }).select().single();

      final noRm = 'RM-${DateTime.now().millisecondsSinceEpoch}';
      await _db.from('patient_profiles').insert({
        'user_id': userInsert['id'],
        'no_rm': noRm,
        'jenis_kelamin': genderCtrl.text.isNotEmpty ? genderCtrl.text : 'L',
        'tanggal_lahir': birthDateCtrl.text.isNotEmpty
            ? _parseDateToISO(birthDateCtrl.text)
            : null,
        'riwayat_penyakit': medicalHistoryCtrl.text.trim(),
      });

      _showSuccess('Registrasi Berhasil', 'Akun pasien berhasil dibuat');
      Get.offAllNamed(AppRoutes.login);
    } on AuthException catch (e) {
      _showError('Registrasi gagal', _translateAuthError(e.message));
    } catch (e) {
      _showError('Registrasi gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerTherapist({
    required String strNo,
    required String specialization,
    required String experience,
  }) async {
    if (!registerFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final response = await _db.auth.signUp(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      if (response.user == null) {
        _showError('Registrasi gagal', 'Tidak dapat membuat akun');
        return;
      }

      final userInsert = await _db.from('users').insert({
        'role_id': 3,
        'name': nameCtrl.text.trim(),
        'username': emailCtrl.text.split('@').first,
        'email': emailCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'status_akun': 'pending',
        'password': 'supabase_auth',
      }).select().single();

      await _db.from('physiotherapist_profiles').insert({
        'user_id': userInsert['id'],
        'no_str': strNo.isNotEmpty ? strNo : null,
        'spesialisasi': specialization.isNotEmpty ? specialization : null,
        'pengalaman_tahun': int.tryParse(experience) ?? 0,
        'is_available': false,
      });

      _showSuccess('Registrasi Berhasil',
          'Akun fisioterapis dibuat, menunggu verifikasi admin');
      Get.offAllNamed(AppRoutes.login);
    } on AuthException catch (e) {
      _showError('Registrasi gagal', _translateAuthError(e.message));
    } catch (e) {
      _showError('Registrasi gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              await _db.auth.signOut();
              currentRole.value = null;
              currentUser.value = null;
              patientProfile.value = null;
              therapistProfile.value = null;
              Get.offAllNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009689)),
            child:
                const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showError(String title, String message) => Get.snackbar(
        title, message,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );

  void _showSuccess(String title, String message) => Get.snackbar(
        title, message,
        backgroundColor: const Color(0xFF009689),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

  String _translateAuthError(String msg) {
    if (msg.contains('Invalid login credentials')) return 'Email atau password salah';
    if (msg.contains('Email not confirmed')) return 'Email belum dikonfirmasi';
    if (msg.contains('User already registered')) return 'Email sudah terdaftar';
    if (msg.contains('Password should be at least')) return 'Password minimal 6 karakter';
    return msg;
  }

  String? _parseDateToISO(String dateStr) {
    try {
      final months = {
        'januari': '01', 'februari': '02', 'maret': '03',
        'april': '04', 'mei': '05', 'juni': '06',
        'juli': '07', 'agustus': '08', 'september': '09',
        'oktober': '10', 'november': '11', 'desember': '12',
      };
      final parts = dateStr.toLowerCase().split(' ');
      if (parts.length == 3) {
        return '${parts[2]}-${months[parts[1]] ?? '01'}-${parts[0].padLeft(2, '0')}';
      }
    } catch (_) {}
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    if (!GetUtils.isEmail(value)) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName tidak boleh kosong';
    return null;
  }
}
