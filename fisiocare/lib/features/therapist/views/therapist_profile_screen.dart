import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/therapist_controller.dart';

class TherapistProfileScreen extends StatelessWidget {
  const TherapistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final ctrl = Get.find<TherapistController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: () => _showEditSheet(context, ctrl),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                  label: const Text('Edit', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const SizedBox(height: 32),
                      Stack(alignment: Alignment.bottomRight, children: [
                        Container(width: 88, height: 88,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 50)),
                        Container(width: 28, height: 28,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14)),
                      ]),
                      const SizedBox(height: 10),
                      Obx(() => Text(ctrl.name.value,
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))),
                      Obx(() => Text(ctrl.spesialisasi.value.isNotEmpty ? ctrl.spesialisasi.value : 'Fisioterapis',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.mint))),
                      const SizedBox(height: 8),
                      Obx(() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.star, color: Color(0xFFEAB308), size: 16),
                        const SizedBox(width: 4),
                        Text(ctrl.ratingAvg.value.toStringAsFixed(1),
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(width: 4),
                        Text('(${ctrl.totalReviews.value} ulasan)',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white.withOpacity(0.7))),
                      ])),
                    ]),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // ── Stats ─────────────────────────────────────────────
                Obx(() => Row(children: [
                  _StatCard(label: 'Pengalaman', value: '${ctrl.pengalaman.value} thn', icon: Icons.work_outline),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Tarif/sesi', value: 'Rp ${_fmt(ctrl.tarif.value)}', icon: Icons.payments_outlined),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Status', value: ctrl.isAvailable.value ? 'Aktif' : 'Nonaktif', icon: Icons.circle,
                      valueColor: ctrl.isAvailable.value ? AppColors.success : AppColors.error),
                ])),
                const SizedBox(height: 16),

                // ── Toggle Ketersediaan ────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(color: AppColors.border)),
                  child: Obx(() => Row(children: [
                    const Icon(Icons.toggle_on_outlined, color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Ketersediaan Layanan',
                        style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                    Switch(
                      value: ctrl.isAvailable.value,
                      onChanged: (_) => ctrl.toggleAvailability(),
                      activeColor: AppColors.primary,
                    ),
                  ])),
                ),
                const SizedBox(height: 16),

                // ── Bio ────────────────────────────────────────────────
                Obx(() {
                  if (ctrl.bio.value.isEmpty) return const SizedBox();
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Tentang Saya', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      Text(ctrl.bio.value, style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, color: AppColors.textSecondary, height: 1.5)),
                    ]),
                  );
                }),
                const SizedBox(height: 16),

                // ── Info Akun ──────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(color: AppColors.border)),
                  child: Column(children: [
                    Obx(() => _InfoRow(icon: Icons.phone_outlined, label: 'Telepon', value: ctrl.phone.value.isNotEmpty ? ctrl.phone.value : '-')),
                    const Divider(height: 1, indent: 16),
                    Obx(() => _InfoRow(icon: Icons.medical_services_outlined, label: 'Spesialisasi', value: ctrl.spesialisasi.value.isNotEmpty ? ctrl.spesialisasi.value : '-')),
                  ]),
                ),
                const SizedBox(height: 16),

                // ── Logout ─────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: authCtrl.logout,
                    icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
                    label: const Text('Keluar', style: TextStyle(color: AppColors.error, fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSM)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, TherapistController ctrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Edit Profil', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: ctrl.profileFormKey,
                  child: Column(children: [
                    _EditField(label: 'Nama Lengkap', controller: ctrl.nameCtrl, icon: Icons.person_outline),
                    const SizedBox(height: 12),
                    _EditField(label: 'Telepon', controller: ctrl.phoneCtrl, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _EditField(label: 'Spesialisasi', controller: ctrl.spesialisasiCtrl, icon: Icons.medical_services_outlined),
                    const SizedBox(height: 12),
                    _EditField(label: 'Bio / Deskripsi', controller: ctrl.bioCtrl, icon: Icons.info_outline, maxLines: 3),
                    const SizedBox(height: 12),
                    _EditField(label: 'Pengalaman (tahun)', controller: ctrl.pengalamanCtrl, icon: Icons.work_outline, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _EditField(label: 'Tarif per Sesi (Rp)', controller: ctrl.tarifCtrl, icon: Icons.payments_outlined, keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ctrl.isSaving.value ? null : ctrl.saveProfile,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                        child: ctrl.isSaving.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Simpan', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    )),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  static String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color? valueColor;
  const _StatCard({required this.label, required this.value, required this.icon, this.valueColor});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusMD), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ]),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, color: AppColors.textSecondary)),
      const Spacer(),
      Flexible(child: Text(value, style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.end)),
    ]),
  );
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  const _EditField({required this.label, required this.controller, required this.icon, this.keyboardType, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
      filled: true, fillColor: AppColors.inputBg,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    ),
  );
}
