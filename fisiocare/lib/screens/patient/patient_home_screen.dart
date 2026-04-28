import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';
import '../patient/booking_list_screen.dart';
import '../patient/physiotherapist_list_screen.dart';
import '../patient/notification_screen.dart';
import '../patient/patient_profile_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const BookingListScreen(),
    const NotificationScreen(),
    const PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Selamat Pagi'
        : hour < 17
            ? 'Selamat Siang'
            : 'Selamat Malam';

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            title: '$greeting,',
            subtitle: user?.name ?? 'Pengguna',
            trailing: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Services Card
              _QuickMenu(
                title: 'Layanan Kami',
                items: [
                  _QuickMenuItem(
                    icon: Icons.home_repair_service,
                    label: 'Home Visit',
                    color: const Color(AppColors.primary),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.physiotherapistList,
                      arguments: {'mode': 'home_visit'},
                    ),
                  ),
                  _QuickMenuItem(
                    icon: Icons.video_call,
                    label: 'Telekonsul',
                    color: const Color(AppColors.secondary),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.physiotherapistList,
                      arguments: {'mode': 'telekonsul'},
                    ),
                  ),
                  _QuickMenuItem(
                    icon: Icons.medical_services_outlined,
                    label: 'Rekam Medis',
                    color: const Color(AppColors.accent),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.patientMedicalRecord,
                    ),
                  ),
                  _QuickMenuItem(
                    icon: Icons.history,
                    label: 'Riwayat',
                    color: const Color(AppColors.success),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.patientBooking,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Banner
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(AppColors.primary), Color(AppColors.secondary)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Icon(
                        Icons.health_and_safety,
                        size: 80,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Fisioterapi Profesional\ndi Depan Pintu Anda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(AppColors.primary),
                              minimumSize: const Size(120, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.physiotherapistList,
                            ),
                            child: const Text('Booking Sekarang'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Find Physiotherapist
              SectionTitle(
                title: 'Temukan Fisioterapis',
                actionLabel: 'Lihat Semua',
                onAction: () => Navigator.pushNamed(
                  context,
                  AppRoutes.physiotherapistList,
                ),
              ),
              const SizedBox(height: 12),
              PhysiotherapistListScreen.buildPhysioListPreview(context),
            ]),
          ),
        ),
      ],
    );
  }
}

class _QuickMenu extends StatelessWidget {
  final String title;
  final List<_QuickMenuItem> items;

  const _QuickMenu({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        ),
      ],
    );
  }
}

class _QuickMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(AppColors.textPrimary),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
