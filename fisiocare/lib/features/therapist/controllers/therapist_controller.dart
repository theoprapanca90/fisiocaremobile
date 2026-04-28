import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/models/app_models.dart';
import '../../auth/controllers/auth_controller.dart';

class TherapistController extends GetxController {
  final RxInt navIndex = 0.obs;
  void changeNav(int index) => navIndex.value = index;

  SupabaseClient get _db => SupabaseService.client;
  AuthController get _auth => Get.find<AuthController>();

  // ── State ──────────────────────────────────────────────────────────
  final RxList<BookingModel> activeBookings = <BookingModel>[].obs;
  final RxList<BookingModel> historyBookings = <BookingModel>[].obs;
  final RxList<Map<String, dynamic>> mySchedules = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingBookings = false.obs;
  final RxBool isLoadingSchedules = false.obs;
  final RxBool isSaving = false.obs;

  // ── Profile edit ───────────────────────────────────────────────────
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString spesialisasi = ''.obs;
  final RxString bio = ''.obs;
  final RxInt pengalaman = 0.obs;
  final RxDouble tarif = 0.0.obs;
  final RxBool isAvailable = true.obs;
  final RxDouble ratingAvg = 0.0.obs;
  final RxInt totalReviews = 0.obs;

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController spesialisasiCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController pengalamanCtrl;
  late TextEditingController tarifCtrl;
  final profileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    spesialisasiCtrl = TextEditingController();
    bioCtrl = TextEditingController();
    pengalamanCtrl = TextEditingController();
    tarifCtrl = TextEditingController();
    loadProfile();
    loadActiveBookings();
    loadSchedules();
  }

  // ── Load Profile ───────────────────────────────────────────────────
  void loadProfile() {
    final user = _auth.currentUser.value;
    final profile = _auth.therapistProfile.value;
    if (user != null) {
      name.value = user.name;
      phone.value = user.phone ?? '';
      nameCtrl.text = user.name;
      phoneCtrl.text = user.phone ?? '';
    }
    if (profile != null) {
      spesialisasi.value = profile.spesialisasi ?? '';
      bio.value = profile.bio ?? '';
      pengalaman.value = profile.pengalamanTahun;
      tarif.value = profile.tarifDefault;
      isAvailable.value = profile.isAvailable;
      ratingAvg.value = profile.ratingAvg;
      totalReviews.value = profile.totalReviews;
      spesialisasiCtrl.text = profile.spesialisasi ?? '';
      bioCtrl.text = profile.bio ?? '';
      pengalamanCtrl.text = profile.pengalamanTahun.toString();
      tarifCtrl.text = profile.tarifDefault.toStringAsFixed(0);
    }
  }

  // ── Save Profile ───────────────────────────────────────────────────
  Future<void> saveProfile() async {
    isSaving.value = true;
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      await _db.from('users').update({
        'name': nameCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
      }).eq('id', user.id);

      await _db.from('physiotherapist_profiles').update({
        'spesialisasi': spesialisasiCtrl.text.trim(),
        'bio': bioCtrl.text.trim(),
        'pengalaman_tahun': int.tryParse(pengalamanCtrl.text) ?? 0,
        'tarif_default': double.tryParse(tarifCtrl.text) ?? 0,
        'is_available': isAvailable.value,
      }).eq('user_id', user.id);

      name.value = nameCtrl.text.trim();
      phone.value = phoneCtrl.text.trim();
      spesialisasi.value = spesialisasiCtrl.text.trim();
      bio.value = bioCtrl.text.trim();

      Get.back();
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui',
          backgroundColor: const Color(0xFF009689),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white));
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat menyimpan: $e',
          backgroundColor: const Color(0xFFEF4444), colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ── Toggle Availability ────────────────────────────────────────────
  Future<void> toggleAvailability() async {
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;
      final newVal = !isAvailable.value;
      await _db.from('physiotherapist_profiles').update({
        'is_available': newVal,
      }).eq('user_id', user.id);
      isAvailable.value = newVal;
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat mengubah status: $e',
          backgroundColor: const Color(0xFFEF4444), colorText: Colors.white);
    }
  }

  // ── Load Active Bookings ───────────────────────────────────────────
  Future<void> loadActiveBookings() async {
    isLoadingBookings.value = true;
    try {
      final profile = _auth.therapistProfile.value;
      if (profile == null) return;

      final data = await _db
          .from('bookings')
          .select()
          .eq('physiotherapist_id', profile.id)
          .inFilter('status_booking', ['pending', 'confirmed', 'paid', 'on_process'])
          .order('booking_date');

      activeBookings.value =
          (data as List).map((e) => BookingModel.fromMap(e)).toList();

      final hist = await _db
          .from('bookings')
          .select()
          .eq('physiotherapist_id', profile.id)
          .inFilter('status_booking', ['completed', 'cancelled'])
          .order('booking_date', ascending: false)
          .limit(10);

      historyBookings.value =
          (hist as List).map((e) => BookingModel.fromMap(e)).toList();
    } catch (_) {}
    isLoadingBookings.value = false;
  }

  // ── Update Booking Status ──────────────────────────────────────────
  Future<void> updateBookingStatus(int bookingId, String newStatus) async {
    try {
      await _db.from('bookings').update({
        'status_booking': newStatus,
      }).eq('id', bookingId);

      await _db.from('booking_status_histories').insert({
        'booking_id': bookingId,
        'status_baru': newStatus,
      });

      await loadActiveBookings();
      Get.snackbar('Berhasil', 'Status booking diperbarui',
          backgroundColor: const Color(0xFF009689), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat mengubah status: $e',
          backgroundColor: const Color(0xFFEF4444), colorText: Colors.white);
    }
  }

  // ── Load Schedules ─────────────────────────────────────────────────
  Future<void> loadSchedules() async {
    isLoadingSchedules.value = true;
    try {
      final profile = _auth.therapistProfile.value;
      if (profile == null) return;

      final data = await _db
          .from('schedules')
          .select()
          .eq('physiotherapist_id', profile.id)
          .order('hari');

      mySchedules.value = List<Map<String, dynamic>>.from(data);
    } catch (_) {}
    isLoadingSchedules.value = false;
  }

  // ── Helpers ────────────────────────────────────────────────────────
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
      case 'completed': return const Color(0xFF22C55E);
      case 'confirmed':
      case 'paid': return const Color(0xFF009689);
      case 'on_process': return const Color(0xFF3B82F6);
      case 'cancelled': return const Color(0xFFEF4444);
      default: return const Color(0xFFF59E0B);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    spesialisasiCtrl.dispose();
    bioCtrl.dispose();
    pengalamanCtrl.dispose();
    tarifCtrl.dispose();
    super.onClose();
  }
}
