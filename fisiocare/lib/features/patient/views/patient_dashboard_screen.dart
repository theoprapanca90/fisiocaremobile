import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import 'education_screen.dart';
import 'exercise_screen.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientController());
    final authCtrl = Get.find<AuthController>();

    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: controller.navIndex.value,
        children: const [
          _DashboardTab(),
          ScheduleScreen(),
          ExerciseScreen(),
          EducationScreen(),
          PatientProfileScreen(),
        ],
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: controller.navIndex.value,
        onTap: controller.changeNav,
      ),
    ));
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.health_and_safety,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          AppStrings.tagline,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.mint,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Greeting ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withOpacity(0.08), AppColors.primary.withOpacity(0.03)],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang!',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: AppSizes.fontSM,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              'Budi Santoso',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: AppSizes.fontLG,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Quick Action Grid ──────────────────────────
                  const Text(
                    'Layanan Kami',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontLG,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _ServiceCard(
                        icon: Icons.calendar_month,
                        title: 'Jadwal Terapi',
                        subtitle: 'Buat & kelola jadwal',
                        color: const Color(0xFF009689),
                        onTap: () => Get.find<PatientController>().changeNav(1),
                      ),
                      _ServiceCard(
                        icon: Icons.fitness_center,
                        title: 'Program Latihan',
                        subtitle: 'Latihan harian Anda',
                        color: const Color(0xFF6366F1),
                        onTap: () => Get.find<PatientController>().changeNav(2),
                      ),
                      _ServiceCard(
                        icon: Icons.menu_book,
                        title: 'Edukasi',
                        subtitle: 'Artikel kesehatan',
                        color: const Color(0xFFF59E0B),
                        onTap: () => Get.find<PatientController>().changeNav(3),
                      ),
                      _ServiceCard(
                        icon: Icons.chat_outlined,
                        title: 'Konsultasi',
                        subtitle: 'Chat dengan terapis',
                        color: const Color(0xFF22C55E),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Upcoming Session ──────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jadwal Terdekat',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: AppSizes.fontLG,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.find<PatientController>().changeNav(1),
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(color: AppColors.primary, fontSize: AppSizes.fontSM),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _UpcomingSessionCard(
                    therapistName: 'Dr. Rina Susanti, S.Ft',
                    date: 'Senin, 21 April 2026',
                    time: '09:00 - 10:00',
                    type: 'Fisioterapi Muskuloskeletal',
                    status: 'Terkonfirmasi',
                  ),
                  const SizedBox(height: 12),
                  _UpcomingSessionCard(
                    therapistName: 'Dr. Ahmad Fauzi, S.Ft',
                    date: 'Kamis, 24 April 2026',
                    time: '14:00 - 15:00',
                    type: 'Fisioterapi Pasca Operasi',
                    status: 'Menunggu',
                  ),
                  const SizedBox(height: 20),

                  // ── Progress Latihan ──────────────────────────
                  const Text(
                    'Progress Latihan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontLG,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Program Stroke Recovery',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: AppSizes.fontSM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '70%',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: AppSizes.fontXS,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.7,
                            backgroundColor: AppColors.inputBg,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('7 dari 10 latihan selesai', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            Text('3 tersisa', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
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

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: AppSizes.fontSM,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingSessionCard extends StatelessWidget {
  final String therapistName;
  final String date;
  final String time;
  final String type;
  final String status;

  const _UpcomingSessionCard({
    required this.therapistName,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status == 'Terkonfirmasi';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  therapistName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: AppSizes.fontSM,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  type,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 11, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '$date • $time',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (isConfirmed ? AppColors.success : AppColors.warning).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isConfirmed ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
