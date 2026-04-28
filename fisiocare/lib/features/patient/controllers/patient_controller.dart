import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/models/app_models.dart';
import '../../auth/controllers/auth_controller.dart';

class PatientController extends GetxController {
  final RxInt navIndex = 0.obs;
  void changeNav(int index) => navIndex.value = index;

  SupabaseClient get _db => SupabaseService.client;
  AuthController get _auth => Get.find<AuthController>();

  // ── Profile State ──────────────────────────────────────────────────
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString birthDate = ''.obs;
  final RxString gender = ''.obs;
  final RxString medicalHistory = ''.obs;
  final RxString allergy = ''.obs;
  final RxString bloodType = ''.obs;
  final RxString noRm = ''.obs;
  final RxString address = ''.obs; // ✅ FIX TAMBAHAN

  // ── Bookings State ─────────────────────────────────────────────────
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxList<Map<String, dynamic>> services = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> therapists = <Map<String, dynamic>>[].obs;

  // ── Loading ────────────────────────────────────────────────────────
  final RxBool isLoadingProfile = false.obs;
  final RxBool isLoadingBookings = false.obs;
  final RxBool isSaving = false.obs;

  // ── Edit Form ──────────────────────────────────────────────────────
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController birthDateCtrl;
  late TextEditingController addressCtrl; // sudah ada
  late TextEditingController medicalHistoryCtrl;
  late TextEditingController allergyCtrl;
  final RxString selectedGender = 'L'.obs;
  final RxString selectedBloodType = 'O+'.obs;
  final editFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    birthDateCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    medicalHistoryCtrl = TextEditingController();
    allergyCtrl = TextEditingController();
    loadProfile();
    loadBookings();
    loadServices();
  }

  // ── Load Profile ───────────────────────────────────────────────────
  Future<void> loadProfile() async {
    isLoadingProfile.value = true;
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      name.value = user.name;
      email.value = user.email ?? '';
      phone.value = user.phone ?? '';

      final profile = _auth.patientProfile.value;
      if (profile != null) {
        noRm.value = profile.noRm;
        gender.value =
            profile.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan';
        bloodType.value = profile.golDarah ?? '';
        allergy.value = profile.alergi ?? 'Tidak ada';
        medicalHistory.value = profile.riwayatPenyakit ?? '';
        address.value = profile.alamat ?? ''; // ✅ FIX

        if (profile.tanggalLahir != null) {
          birthDate.value =
              _formatDateDisplay(profile.tanggalLahir!);
        }
      }

      _syncEditControllers();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: $e',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white);
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void _syncEditControllers() {
    nameCtrl.text = name.value;
    emailCtrl.text = email.value;
    phoneCtrl.text = phone.value;
    birthDateCtrl.text = birthDate.value;
    addressCtrl.text = address.value; // ✅ FIX
    medicalHistoryCtrl.text = medicalHistory.value;
    allergyCtrl.text = allergy.value;
    selectedGender.value = gender.value;
    selectedBloodType.value = bloodType.value;
  }

  void resetEditControllers() => _syncEditControllers();

  // ── Save Profile ───────────────────────────────────────────────────
  Future<void> saveProfile() async {
    if (!editFormKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      // Update users table
      await _db.from('users').update({
        'name': nameCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
      }).eq('id', user.id);

      // Update patient_profiles
      final profile = _auth.patientProfile.value;
      if (profile != null) {
        await _db.from('patient_profiles').update({
          'jenis_kelamin':
              selectedGender.value == 'Laki-laki' ? 'L' : 'P',
          'gol_darah': selectedBloodType.value,
          'alergi': allergyCtrl.text.trim(),
          'riwayat_penyakit': medicalHistoryCtrl.text.trim(),
          'alamat': addressCtrl.text.trim(), // ✅ FIX
        }).eq('user_id', user.id);
      }

      // Update local state
      name.value = nameCtrl.text.trim();
      phone.value = phoneCtrl.text.trim();
      gender.value = selectedGender.value;
      bloodType.value = selectedBloodType.value;
      allergy.value = allergyCtrl.text.trim();
      medicalHistory.value = medicalHistoryCtrl.text.trim();
      address.value = addressCtrl.text.trim(); // ✅ FIX

      Get.back();
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui',
          backgroundColor: const Color(0xFF009689),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white));
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat menyimpan profil: $e',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ── Load Bookings ──────────────────────────────────────────────────
  Future<void> loadBookings() async {
    isLoadingBookings.value = true;
    try {
      final profile = _auth.patientProfile.value;
      if (profile == null) return;

      final data = await _db
          .from('bookings')
          .select()
          .eq('patient_id', profile.id)
          .order('booking_date', ascending: false)
          .limit(20);

      bookings.value = (data as List)
          .map((e) => BookingModel.fromMap(e))
          .toList();
    } catch (_) {}
    isLoadingBookings.value = false;
  }

  // ── Load Services ──────────────────────────────────────────────────
  Future<void> loadServices() async {
    try {
      final data = await _db
          .from('services')
          .select()
          .eq('is_active', true);
      services.value = List<Map<String, dynamic>>.from(data);
    } catch (_) {}
  }

  // ── Load Therapists ────────────────────────────────────────────────
  Future<void> loadTherapists() async {
    try {
      final data = await _db
          .from('physiotherapist_profiles')
          .select('*, users!inner(name, phone)')
          .eq('is_available', true);
      therapists.value =
          List<Map<String, dynamic>>.from(data);
    } catch (_) {}
  }

  // ── Create Booking ─────────────────────────────────────────────────
  Future<bool> createBooking({
    required int serviceId,
    required int? therapistId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required String keluhan,
  }) async {
    try {
      final profile = _auth.patientProfile.value;
      if (profile == null) return false;

      final code =
          'BK-${DateTime.now().millisecondsSinceEpoch}';
      await _db.from('bookings').insert({
        'booking_code': code,
        'patient_id': profile.id,
        'physiotherapist_id': therapistId,
        'service_id': serviceId,
        'booking_date': bookingDate,
        'start_time': startTime,
        'end_time': endTime,
        'keluhan_awal': keluhan,
        'status_booking': 'pending',
        'status_pembayaran': 'unpaid',
      });

      await loadBookings();
      return true;
    } catch (e) {
      Get.snackbar('Gagal',
          'Tidak dapat membuat booking: $e',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white);
      return false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────
  String _formatDateDisplay(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      return '${dt.day} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String getStatusLabel(String status) {
    const map = {
      'pending': 'Menunggu',
      'confirmed': 'Dikonfirmasi',
      'paid': 'Dibayar',
      'on_process': 'Dalam Proses',
      'completed': 'Selesai',
      'cancelled': 'Dibatalkan',
    };
    return map[status] ?? status;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF22C55E);
      case 'confirmed':
      case 'paid':
        return const Color(0xFF009689);
      case 'on_process':
        return const Color(0xFF3B82F6);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    birthDateCtrl.dispose();
    addressCtrl.dispose();
    medicalHistoryCtrl.dispose();
    allergyCtrl.dispose();
    super.onClose();
  }
}