import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_widgets.dart';

class RegisterPatientScreen extends StatelessWidget {
  const RegisterPatientScreen({super.key});

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
                    width: 36,
                    height: 36,
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
                    Text(
                      AppStrings.registerPatient,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: AppSizes.fontXL,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      AppStrings.registerPatientSub,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: AppSizes.fontSM,
                        color: AppColors.mint,
                      ),
                    ),
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
                  // Card - Informasi Pribadi
                  AppCard(
                    title: AppStrings.personalInfo,
                    child: Column(
                      children: [
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
                        const SizedBox(height: 16),
                        AppTextField(
                          label: AppStrings.birthDate,
                          hint: 'Pilih tanggal lahir',
                          icon: Icons.calendar_today_outlined,
                          controller: controller.birthDateCtrl,
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime(1990),
                              firstDate: DateTime(1940),
                              lastDate: DateTime.now(),
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(primary: AppColors.primary),
                                ),
                                child: child!,
                              ),
                            );
                            if (date != null) {
                              controller.birthDateCtrl.text =
                                  '${date.day}/${date.month}/${date.year}';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        // Jenis Kelamin Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppStrings.gender,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: AppSizes.fontSM,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              hint: const Text(
                                'Pilih jenis kelamin',
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: AppSizes.fontSM,
                                ),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.inputBg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                                DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                              ],
                              onChanged: (v) => controller.genderCtrl.text = v ?? '',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: AppStrings.address,
                          hint: 'Masukkan alamat lengkap',
                          icon: Icons.location_on_outlined,
                          controller: controller.addressCtrl,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card - Informasi Medis
                  AppCard(
                    title: AppStrings.medicalInfo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: AppStrings.medicalHistory,
                          hint: 'Contoh: Diabetes, Hipertensi, Alergi obat, dll.',
                          controller: controller.medicalHistoryCtrl,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Informasi ini membantu terapis memberikan perawatan terbaik',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: AppSizes.fontXS,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card - Akun
                  AppCard(
                    title: 'Buat Password',
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  Obx(() => AppButton(
                    label: 'Daftar Sekarang',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.registerPatient,
                  )),
                  const SizedBox(height: 16),

                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: AppSizes.fontSM,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: AppStrings.hasAccount),
                            TextSpan(
                              text: AppStrings.loginHere,
                              style: TextStyle(color: AppColors.primary),
                            ),
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
