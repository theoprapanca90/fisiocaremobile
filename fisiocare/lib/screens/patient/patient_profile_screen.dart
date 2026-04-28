import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final profile = user?.patientProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.patientProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(AppColors.primaryDark),
                    Color(AppColors.primary)
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: Text(
                      (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? '-',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '-',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (profile != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'No. RM: ${profile.noRm}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Info Pribadi
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Informasi Pribadi'),
                        const SizedBox(height: 12),
                        InfoRow(label: 'Username', value: user?.username ?? '-'),
                        InfoRow(label: 'Telepon', value: user?.phone ?? '-'),
                        InfoRow(
                          label: 'Jenis Kelamin',
                          value: profile?.jenisKelamin == 'L'
                              ? 'Laki-laki'
                              : 'Perempuan',
                        ),
                        InfoRow(
                          label: 'Tgl. Lahir',
                          value: AppHelpers.formatDate(profile?.tanggalLahir),
                        ),
                        InfoRow(
                            label: 'Tempat Lahir',
                            value: profile?.tempatLahir ?? '-'),
                        InfoRow(
                            label: 'Golongan Darah',
                            value: profile?.golDarah ?? '-'),
                        InfoRow(label: 'NIK', value: profile?.nik ?? '-'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Medis
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Informasi Medis'),
                        const SizedBox(height: 12),
                        InfoRow(
                            label: 'Alergi',
                            value: profile?.alergi ?? 'Tidak ada'),
                        InfoRow(
                            label: 'Riwayat Penyakit',
                            value:
                                profile?.riwayatPenyakit ?? 'Tidak ada'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kontak Darurat
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Kontak Darurat'),
                        const SizedBox(height: 12),
                        InfoRow(
                            label: 'Nama',
                            value: profile?.kontakDaruratNama ?? '-'),
                        InfoRow(
                            label: 'Telepon',
                            value: profile?.kontakDaruratPhone ?? '-'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Menu
                  AppCard(
                    child: Column(
                      children: [
                        _MenuItem(
                          icon: Icons.location_on_outlined,
                          label: 'Alamat Saya',
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.patientAddress),
                        ),
                        const Divider(height: 1),
                        _MenuItem(
                          icon: Icons.medical_information_outlined,
                          label: 'Rekam Medis',
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.patientMedicalRecord),
                        ),
                        const Divider(height: 1),
                        _MenuItem(
                          icon: Icons.lock_outline,
                          label: 'Ubah Password',
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _MenuItem(
                          icon: Icons.logout,
                          label: 'Keluar',
                          color: const Color(AppColors.error),
                          onTap: () async {
                            final confirmed = await AppHelpers.showConfirmDialog(
                              context,
                              title: 'Keluar',
                              message: 'Apakah Anda yakin ingin keluar?',
                              isDanger: true,
                            );
                            if (confirmed && context.mounted) {
                              await context.read<AuthProvider>().logout();
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(AppColors.textPrimary);
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: c,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: c.withOpacity(0.5)),
      onTap: onTap,
    );
  }
}
