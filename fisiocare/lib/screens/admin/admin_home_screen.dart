import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _AdminDashboardTab(),
    const _AdminUsersTab(),
    const _AdminBookingsTab(),
    const _AdminPaymentsTab(),
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
            icon: Icon(Icons.people_outlined),
            activeIcon: Icon(Icons.people),
            label: 'Pengguna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: Icon(Icons.payment),
            label: 'Pembayaran',
          ),
        ],
      ),
    );
  }
}

class _AdminDashboardTab extends StatefulWidget {
  const _AdminDashboardTab();

  @override
  State<_AdminDashboardTab> createState() => _AdminDashboardTabState();
}

class _AdminDashboardTabState extends State<_AdminDashboardTab> {
  final AdminService _adminService = AdminService();
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final r = await _adminService.getDashboard();
      if (r['success'] == true) {
        setState(() {
          _data = r['data'];
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat dashboard...')
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(AppColors.primaryDark),
                            Color(AppColors.primary)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang, ${user?.name ?? 'Admin'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Panel Administrasi FisioCare',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stats
                    const SectionTitle(title: 'Statistik'),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _AdminStatCard(
                          label: 'Total Pengguna',
                          value: '${_data?['total_users'] ?? 0}',
                          icon: Icons.people,
                          color: const Color(AppColors.primary),
                        ),
                        _AdminStatCard(
                          label: 'Total Booking',
                          value: '${_data?['total_bookings'] ?? 0}',
                          icon: Icons.calendar_month,
                          color: const Color(AppColors.secondary),
                        ),
                        _AdminStatCard(
                          label: 'Booking Hari Ini',
                          value: '${_data?['booking_today'] ?? 0}',
                          icon: Icons.today,
                          color: const Color(AppColors.accent),
                        ),
                        _AdminStatCard(
                          label: 'Pembayaran Pending',
                          value: '${_data?['payment_pending'] ?? 0}',
                          icon: Icons.pending_actions,
                          color: const Color(AppColors.warning),
                        ),
                        _AdminStatCard(
                          label: 'Total Fisioterapis',
                          value: '${_data?['total_physio'] ?? 0}',
                          icon: Icons.medical_services,
                          color: Colors.purple,
                        ),
                        _AdminStatCard(
                          label: 'Total Pasien',
                          value: '${_data?['total_patients'] ?? 0}',
                          icon: Icons.person,
                          color: const Color(AppColors.success),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Quick Links
                    const SectionTitle(title: 'Menu Admin'),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        _AdminMenuTile(
                          icon: Icons.verified_user_outlined,
                          label: 'Verifikasi Pembayaran',
                          subtitle: 'Cek dan verifikasi pembayaran pasien',
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.adminPayments),
                        ),
                        _AdminMenuTile(
                          icon: Icons.design_services_outlined,
                          label: 'Kelola Layanan',
                          subtitle: 'Tambah & edit layanan fisioterapi',
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.adminServices),
                        ),
                        _AdminMenuTile(
                          icon: Icons.rate_review_outlined,
                          label: 'Moderasi Ulasan',
                          subtitle: 'Setujui atau tolak ulasan pasien',
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.adminReviews),
                        ),
                        _AdminMenuTile(
                          icon: Icons.bar_chart,
                          label: 'Laporan',
                          subtitle: 'Lihat laporan statistik & keuangan',
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.adminReports),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminMenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(AppColors.primary), size: 22),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(AppColors.textSecondary),
          ),
        ),
        trailing: const Icon(Icons.chevron_right,
            color: Color(AppColors.textSecondary)),
        onTap: onTap,
      ),
    );
  }
}

// Placeholder tabs for Admin
class _AdminUsersTab extends StatelessWidget {
  const _AdminUsersTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Pengguna')),
      body: const Center(child: Text('Daftar pengguna akan tampil di sini')),
    );
  }
}

class _AdminBookingsTab extends StatelessWidget {
  const _AdminBookingsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Booking')),
      body: const Center(child: Text('Daftar booking akan tampil di sini')),
    );
  }
}

class _AdminPaymentsTab extends StatelessWidget {
  const _AdminPaymentsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: const Center(child: Text('Daftar pembayaran akan tampil di sini')),
    );
  }
}
