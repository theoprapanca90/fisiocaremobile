import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/patient_controller.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final patientCtrl = Get.find<PatientController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: () => _showEditProfileSheet(context, patientCtrl),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                  label: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10),
                                ],
                              ),
                              child: const Icon(Icons.person, color: AppColors.primary, size: 46),
                            ),
                            GestureDetector(
                              onTap: () => Get.snackbar(
                                'Info',
                                'Fitur ganti foto akan segera hadir',
                                snackPosition: SnackPosition.TOP,
                              ),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Text(
                          patientCtrl.name.value,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )),
                        const Text(
                          'Pasien',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.mint),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Stats ──────────────────────────────────────────
                  Row(
                    children: [
                      _StatCard(label: 'Total Sesi', value: '12', icon: Icons.calendar_month, color: AppColors.primary),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Program Aktif', value: '2', icon: Icons.fitness_center, color: const Color(0xFF6366F1)),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Artikel Dibaca', value: '8', icon: Icons.menu_book, color: const Color(0xFFF59E0B)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Data Diri ──────────────────────────────────────
                  Obx(() => _SectionCard(
                    title: 'Data Diri',
                    onEdit: () => _showEditProfileSheet(context, patientCtrl),
                    items: [
                      _InfoItem(icon: Icons.person_outline, label: 'Nama', value: patientCtrl.name.value),
                      _InfoItem(icon: Icons.email_outlined, label: 'Email', value: patientCtrl.email.value),
                      _InfoItem(icon: Icons.phone_outlined, label: 'Telepon', value: patientCtrl.phone.value),
                      _InfoItem(icon: Icons.calendar_today_outlined, label: 'Tanggal Lahir', value: patientCtrl.birthDate.value),
                      _InfoItem(icon: Icons.person_outline, label: 'Jenis Kelamin', value: patientCtrl.gender.value),
                      _InfoItem(icon: Icons.location_on_outlined, label: 'Alamat', value: patientCtrl.address.value),
                    ],
                  )),
                  const SizedBox(height: 12),

                  // ── Informasi Medis ────────────────────────────────
                  Obx(() => _SectionCard(
                    title: 'Informasi Medis',
                    onEdit: () => _showEditProfileSheet(context, patientCtrl),
                    items: [
                      _InfoItem(icon: Icons.medical_information_outlined, label: 'Riwayat Penyakit', value: patientCtrl.medicalHistory.value),
                      _InfoItem(icon: Icons.healing_outlined, label: 'Alergi', value: patientCtrl.allergy.value),
                      _InfoItem(icon: Icons.bloodtype_outlined, label: 'Golongan Darah', value: patientCtrl.bloodType.value),
                    ],
                  )),
                  const SizedBox(height: 12),

                  // ── Pengaturan ─────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _SettingItem(icon: Icons.notifications_outlined, label: 'Notifikasi', onTap: () {}),
                        const Divider(height: 1, indent: 52, color: AppColors.divider),
                        _SettingItem(icon: Icons.lock_outline, label: 'Ubah Password', onTap: () {}),
                        const Divider(height: 1, indent: 52, color: AppColors.divider),
                        _SettingItem(icon: Icons.help_outline, label: 'Bantuan', onTap: () {}),
                        const Divider(height: 1, indent: 52, color: AppColors.divider),
                        _SettingItem(icon: Icons.info_outline, label: 'Tentang Aplikasi', onTap: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Logout ─────────────────────────────────────────
                  GestureDetector(
                    onTap: authCtrl.logout,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: AppColors.error, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: AppSizes.fontSM,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet Edit Profil ───────────────────────────────────────
  void _showEditProfileSheet(BuildContext context, PatientController ctrl) {
    ctrl.resetEditControllers();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(ctrl: ctrl),
    );
  }
}

// ── Edit Profile Bottom Sheet ──────────────────────────────────────────────────
class _EditProfileSheet extends StatelessWidget {
  final PatientController ctrl;
  const _EditProfileSheet({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontLG,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Obx(() => ctrl.isSaving.value
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      )
                    : GestureDetector(
                        onTap: ctrl.saveProfile,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: AppSizes.fontSM,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: Form(
                key: ctrl.editFormKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [

                    // ── Foto Profil ──────────────────────────────────
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.mint,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Icon(Icons.person, color: AppColors.primary, size: 48),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Section: Data Diri ───────────────────────────
                    _SectionHeader(title: 'Data Diri', icon: Icons.person_outline),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.nameCtrl,
                      label: 'Nama Lengkap',
                      icon: Icons.person_outline,
                      validator: (v) => v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.emailCtrl,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                        if (!v.contains('@')) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.phoneCtrl,
                      label: 'Nomor Telepon',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.birthDateCtrl,
                      label: 'Tanggal Lahir',
                      icon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: Get.context!,
                          initialDate: DateTime(1985, 3, 15),
                          firstDate: DateTime(1940),
                          lastDate: DateTime.now(),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(primary: AppColors.primary),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          const months = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
                          ctrl.birthDateCtrl.text = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Jenis Kelamin Dropdown
                    Obx(() => _DropdownField(
                      label: 'Jenis Kelamin',
                      icon: Icons.wc_outlined,
                      value: ctrl.selectedGender.value,
                      items: const ['Laki-laki', 'Perempuan'],
                      onChanged: (v) => ctrl.selectedGender.value = v!,
                    )),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.addressCtrl,
                      label: 'Alamat',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // ── Section: Informasi Medis ─────────────────────
                    _SectionHeader(title: 'Informasi Medis', icon: Icons.medical_information_outlined),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.medicalHistoryCtrl,
                      label: 'Riwayat Penyakit',
                      icon: Icons.medical_information_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    _EditField(
                      controller: ctrl.allergyCtrl,
                      label: 'Alergi',
                      icon: Icons.healing_outlined,
                    ),
                    const SizedBox(height: 12),

                    // Golongan Darah Dropdown
                    Obx(() => _DropdownField(
                      label: 'Golongan Darah',
                      icon: Icons.bloodtype_outlined,
                      value: ctrl.selectedBloodType.value,
                      items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      onChanged: (v) => ctrl.selectedBloodType.value = v!,
                    )),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.mint,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 16),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: AppSizes.fontMD,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    ],
  );
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    maxLines: maxLines,
    readOnly: readOnly,
    onTap: onTap,
    style: const TextStyle(
      fontFamily: 'Inter',
      fontSize: AppSizes.fontSM,
      color: AppColors.textPrimary,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: AppSizes.fontSM,
        color: AppColors.textMuted,
      ),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),
  );
}

class _DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value,
    onChanged: onChanged,
    style: const TextStyle(
      fontFamily: 'Inter',
      fontSize: AppSizes.fontSM,
      color: AppColors.textPrimary,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: AppSizes.fontSM,
        color: AppColors.textMuted,
      ),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    items: items.map((item) => DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM)),
    )).toList(),
  );
}

// ── Section Card & Info Item ───────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;
  final VoidCallback? onEdit;
  const _SectionCard({required this.title, required this.items, this.onEdit});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: AppSizes.fontMD,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 13, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.divider),
        ...items.map((item) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textMuted)),
                      const SizedBox(height: 2),
                      Text(item.value, style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            if (item != items.last) const Divider(height: 1, indent: 46, color: AppColors.divider),
          ],
        )),
      ],
    ),
  );
}

class _InfoItem {
  final IconData icon;
  final String label, value;
  const _InfoItem({required this.icon, required this.label, required this.value});
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: AppColors.textSecondary, size: 20),
    title: Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, color: AppColors.textPrimary)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
  );
}
