import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_widgets.dart';

class RegisterTherapistScreen extends StatelessWidget {
  const RegisterTherapistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 48, 22, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daftar Fisioterapis',
                      style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontXL, fontWeight: FontWeight.w500, color: Colors.white)),
                    Text('Bergabung sebagai fisioterapis profesional',
                      style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, color: AppColors.mint)),
                  ],
                ),
              ],
            ),
          ),

          // ── Form Body ─────────────────────────────────────────────
          Expanded(
            child: Form(
              key: controller.registerFormKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Informasi Pribadi
                  AppCard(
                    title: AppStrings.personalInfo,
                    child: Column(children: [
                      AppTextField(
                        label: AppStrings.fullName,
                        hint: 'Masukkan nama lengkap',
                        icon: Icons.person_outline,
                        controller: controller.nameCtrl,
                        validator: (v) => controller.validateRequired(v, 'Nama lengkap'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: '${AppStrings.email} *',
                        hint: 'nama@email.com',
                        icon: Icons.email_outlined,
                        controller: controller.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: AppStrings.phoneNumber,
                        hint: '+62 812 3456 7890',
                        icon: Icons.phone_outlined,
                        controller: controller.phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (v) => controller.validateRequired(v, 'Nomor telepon'),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Informasi Profesional
                  AppCard(
                    title: 'Informasi Profesional',
                    child: Column(children: [
                      AppTextField(
                        label: 'Nomor STR *',
                        hint: 'Masukkan nomor STR',
                        icon: Icons.badge_outlined,
                        controller: controller.strNoCtrl,
                        validator: (v) => controller.validateRequired(v, 'Nomor STR'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Spesialisasi *',
                        hint: 'Contoh: Fisioterapi Muskuloskeletal',
                        icon: Icons.medical_services_outlined,
                        controller: controller.specializationCtrl,
                        validator: (v) => controller.validateRequired(v, 'Spesialisasi'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Pengalaman (tahun)',
                        hint: 'Contoh: 5',
                        icon: Icons.work_outline,
                        controller: controller.experienceCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AppCard(
                    title: 'Buat Password',
                    child: Column(children: [
                      AppTextField(
                        label: '${AppStrings.password} *',
                        hint: 'Minimal 6 karakter',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: controller.passwordCtrl,
                        validator: controller.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Konfirmasi Password *',
                        hint: 'Ulangi password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (v) {
                          if (v != controller.passwordCtrl.text) return 'Password tidak sama';
                          return null;
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),

                  // Info verifikasi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                    ),
                    child: const Row(children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Akun akan diverifikasi oleh admin sebelum dapat digunakan',
                          style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontXS, color: AppColors.primary),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  // Tombol daftar - panggil registerTherapist dengan param
                  Obx(() => AppButton(
                    label: 'Daftar sebagai Fisioterapis',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.registerTherapist(
                      strNo: controller.strNoCtrl.text,
                      specialization: controller.specializationCtrl.text,
                      experience: controller.experienceCtrl.text,
                    ),
                  )),
                  const SizedBox(height: 16),

                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, color: AppColors.textSecondary),
                          children: [
                            TextSpan(text: AppStrings.hasAccount),
                            TextSpan(text: AppStrings.loginHere, style: TextStyle(color: AppColors.primary)),
                          ],
                        ),
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
}
