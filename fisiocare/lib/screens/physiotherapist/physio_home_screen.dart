import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';
import '../patient/booking_list_screen.dart';
import '../patient/notification_screen.dart';
import '../patient/chat_screen.dart';

class PhysioHomeScreen extends StatefulWidget {
  const PhysioHomeScreen({super.key});

  @override
  State<PhysioHomeScreen> createState() => _PhysioHomeScreenState();
}

class _PhysioHomeScreenState extends State<PhysioHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _PhysioHomeTab(),
    const _PhysioBookingsTab(),
    const NotificationScreen(),
    const _PhysioProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
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

class _PhysioHomeTab extends StatefulWidget {
  const _PhysioHomeTab();

  @override
  State<_PhysioHomeTab> createState() => _PhysioHomeTabState();
}

class _PhysioHomeTabState extends State<_PhysioHomeTab> {
  final PhysiotherapistService _physioService = PhysiotherapistService();
  Map<String, dynamic>? _stats;
  bool _isAvailable = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    // Simulate loading stats
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _stats = {
        'total_booking_hari_ini': 3,
        'total_selesai_bulan': 28,
        'rating': 4.8,
        'total_pasien': 45,
      };
      _isLoading = false;
    });
  }

  Future<void> _toggleAvailability(bool val) async {
    try {
      await _physioService.updateAvailability(val);
      setState(() => _isAvailable = val);
      AppHelpers.showSnackBar(
        context,
        val ? 'Status: Tersedia' : 'Status: Tidak Tersedia',
      );
    } catch (e) {
      AppHelpers.showSnackBar(context, 'Gagal update status', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            title: 'Selamat Datang,',
            subtitle: user?.name ?? 'Fisioterapis',
            trailing: Switch(
              value: _isAvailable,
              onChanged: _toggleAvailability,
              activeColor: Colors.white,
              activeTrackColor: const Color(AppColors.success),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Availability hint
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isAvailable
                      ? const Color(AppColors.success).withOpacity(0.1)
                      : const Color(AppColors.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isAvailable ? Icons.check_circle : Icons.cancel,
                      color: _isAvailable
                          ? const Color(AppColors.success)
                          : const Color(AppColors.error),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAvailable
                          ? 'Anda tersedia untuk menerima booking'
                          : 'Anda tidak tersedia saat ini',
                      style: TextStyle(
                        fontSize: 13,
                        color: _isAvailable
                            ? const Color(AppColors.success)
                            : const Color(AppColors.error),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats
              const SectionTitle(title: 'Ringkasan'),
              const SizedBox(height: 12),
              if (_isLoading)
                const SizedBox(
                    height: 80, child: Center(child: CircularProgressIndicator()))
              else
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _StatCard(
                      label: 'Booking Hari Ini',
                      value: '${_stats?['total_booking_hari_ini'] ?? 0}',
                      icon: Icons.today,
                      color: const Color(AppColors.primary),
                    ),
                    _StatCard(
                      label: 'Selesai Bulan Ini',
                      value: '${_stats?['total_selesai_bulan'] ?? 0}',
                      icon: Icons.check_circle_outline,
                      color: const Color(AppColors.success),
                    ),
                    _StatCard(
                      label: 'Rating',
                      value: '${_stats?['rating'] ?? 0}',
                      icon: Icons.star_outline,
                      color: Colors.amber,
                    ),
                    _StatCard(
                      label: 'Total Pasien',
                      value: '${_stats?['total_pasien'] ?? 0}',
                      icon: Icons.people_outline,
                      color: const Color(AppColors.accent),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // Quick Actions
              const SectionTitle(title: 'Menu Cepat'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.schedule,
                      label: 'Jadwal Saya',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.physioSchedule),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.medical_services_outlined,
                      label: 'Rekam Medis',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.physioMedicalRecord),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(AppColors.textSecondary),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(AppColors.primary), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.textPrimary),
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Color(AppColors.textSecondary), size: 18),
          ],
        ),
      ),
    );
  }
}

class _PhysioBookingsTab extends StatefulWidget {
  const _PhysioBookingsTab();

  @override
  State<_PhysioBookingsTab> createState() => _PhysioBookingsTabState();
}

class _PhysioBookingsTabState extends State<_PhysioBookingsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingService _bookingService = BookingService();
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load({String? status}) async {
    setState(() {
      _isLoading = true;
      _selectedStatus = status;
    });
    try {
      final r = await _bookingService.getBookingsByPhysio(status: status);
      if (r['success'] == true) {
        final data = r['data']['data'] as List;
        setState(() {
          _bookings = data.map((e) => Booking.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [null, 'confirmed', 'on_process', 'completed'];
    final labels = ['Semua', 'Konfirmasi', 'Proses', 'Selesai'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Pasien'),
        bottom: TabBar(
          controller: _tabController,
          tabs: labels.map((l) => Tab(text: l)).toList(),
          onTap: (i) => _load(status: statuses[i]),
        ),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat booking...')
          : _bookings.isEmpty
              ? const EmptyStateWidget(
                  title: 'Tidak ada booking',
                  icon: Icons.calendar_today_outlined,
                )
              : RefreshIndicator(
                  onRefresh: () => _load(status: _selectedStatus),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _bookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => BookingCard(booking: _bookings[i]),
                  ),
                ),
    );
  }
}

class _PhysioProfileTab extends StatelessWidget {
  const _PhysioProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final profile = user?.physiotherapistProfile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.physioProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: const Color(AppColors.primary).withOpacity(0.15),
              child: Text(
                (user?.name ?? 'F').substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? '-',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              profile?.spesialisasi ?? 'Fisioterapis',
              style: const TextStyle(color: Color(AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                children: [
                  InfoRow(label: 'No. STR', value: profile?.noStr ?? '-'),
                  InfoRow(
                      label: 'Pengalaman',
                      value: '${profile?.pengalamanTahun ?? 0} tahun'),
                  InfoRow(
                      label: 'Rating',
                      value:
                          '${profile?.ratingAvg.toStringAsFixed(1) ?? 0} / 5.0'),
                  InfoRow(
                      label: 'Total Review',
                      value: '${profile?.totalReviews ?? 0}'),
                  InfoRow(
                      label: 'Tarif',
                      value: AppHelpers.formatCurrency(
                          profile?.tarifDefault ?? 0)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (profile?.bio != null)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Bio'),
                    const SizedBox(height: 8),
                    Text(
                      profile!.bio!,
                      style: const TextStyle(
                        color: Color(AppColors.textSecondary),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(AppColors.error),
                side: const BorderSide(color: Color(AppColors.error)),
              ),
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}
