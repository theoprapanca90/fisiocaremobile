import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.0, -1.0),
            end: Alignment(0.2, 1.0),
            colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // ── Logo & Title ──────────────────────────────
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.health_and_safety,
                          color: AppColors.primary,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    AppStrings.tagline,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.mint,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Login Card ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              AppStrings.login,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: AppSizes.fontXL,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tab Switcher
                          Obx(() => AppTabSwitcher(
                            selectedIndex: controller.loginTabIndex.value,
                            tabs: const [AppStrings.patient, AppStrings.therapist],
                            onChanged: controller.setLoginTab,
                          )),
                          const SizedBox(height: 24),

                          // Email
                          AppTextField(
                            label: AppStrings.email,
                            hint: 'nama@email.com',
                            icon: Icons.email_outlined,
                            controller: controller.emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: controller.validateEmail,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          AppTextField(
                            label: AppStrings.password,
                            hint: 'Masukkan password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: controller.passwordCtrl,
                            validator: controller.validatePassword,
                          ),
                          const SizedBox(height: 8),

                          // Lupa Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text(
                                AppStrings.forgotPassword,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: AppSizes.fontSM,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login Button
                          Obx(() => AppButton(
                            label: AppStrings.btnLogin,
                            isLoading: controller.isLoading.value,
                            onPressed: controller.login,
                          )),
                          const SizedBox(height: 16),

                          // Register Link
                          Center(
                            child: GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.registerPatient),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: AppSizes.fontSM,
                                    color: AppColors.textSecondary,
                                  ),
                                  children: [
                                    TextSpan(text: AppStrings.noAccount),
                                    TextSpan(
                                      text: AppStrings.registerAsPatient,
                                      style: TextStyle(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.registerTherapist),
                              child: const Text(
                                'Daftar sebagai Fisioterapis',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: AppSizes.fontSM,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Terms
                  const Text(
                    AppStrings.terms,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontXS,
                      color: AppColors.mint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
