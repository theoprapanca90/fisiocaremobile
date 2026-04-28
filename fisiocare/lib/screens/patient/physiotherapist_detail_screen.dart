import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../config/app_config.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class PhysiotherapistDetailScreen extends StatefulWidget {
  const PhysiotherapistDetailScreen({super.key});

  @override
  State<PhysiotherapistDetailScreen> createState() =>
      _PhysiotherapistDetailScreenState();
}

class _PhysiotherapistDetailScreenState
    extends State<PhysiotherapistDetailScreen>
    with SingleTickerProviderStateMixin {
  final PhysiotherapistService _service = PhysiotherapistService();
  late TabController _tabController;
  PhysiotherapistProfile? _physio;
  List<Schedule> _schedules = [];
  List<Review> _reviews = [];
  bool _isLoading = true;
  int? _physioId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _physioId = ModalRoute.of(context)?.settings.arguments as int?;
    if (_physioId != null) _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final r = await _service.getPhysiotherapistDetail(_physioId!);
      final sr = await _service.getSchedules(_physioId!);
      final rr = await _service.getReviews(_physioId!);

      setState(() {
        if (r['success'] == true) {
          _physio = PhysiotherapistProfile.fromJson(r['data']);
        }
        if (sr['success'] == true) {
          _schedules = (sr['data'] as List)
              .map((e) => Schedule.fromJson(e))
              .toList();
        }
        if (rr['success'] == true) {
          _reviews = (rr['data']['data'] as List)
              .map((e) => Review.fromJson(e))
              .toList();
        }
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat profil...')
          : _physio == null
              ? const ErrorStateWidget(message: 'Fisioterapis tidak ditemukan')
              : CustomScrollView(
                  slivers: [
                    // Header
                    SliverAppBar(
                      expandedHeight: 280,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(AppColors.primaryDark),
                                Color(AppColors.primary)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 60),
                              CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    Colors.white.withOpacity(0.3),
                                backgroundImage:
                                    _physio!.user?.profilePhoto != null
                                        ? CachedNetworkImageProvider(
                                            _physio!.user!.profilePhoto!)
                                        : null,
                                child: _physio!.user?.profilePhoto == null
                                    ? Text(
                                        (_physio!.user?.name ?? 'F')
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 36,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _physio!.user?.name ?? '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _physio!.spesialisasi ?? 'Fisioterapis',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RatingBarIndicator(
                                    rating: _physio!.ratingAvg,
                                    itemCount: 5,
                                    itemSize: 16,
                                    itemBuilder: (_, __) => const Icon(
                                        Icons.star,
                                        color: Colors.amber),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${_physio!.ratingAvg.toStringAsFixed(1)} (${_physio!.totalReviews} ulasan)',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Stats Row
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                _InfoChip(
                                  label: '${_physio!.pengalamanTahun} thn',
                                  icon: Icons.work_outline,
                                ),
                                const SizedBox(width: 8),
                                _InfoChip(
                                  label: AppHelpers.formatCurrency(
                                      _physio!.tarifDefault),
                                  icon: Icons.attach_money,
                                ),
                                const SizedBox(width: 8),
                                _InfoChip(
                                  label: _physio!.isAvailable
                                      ? 'Tersedia'
                                      : 'Tidak Tersedia',
                                  icon: _physio!.isAvailable
                                      ? Icons.check_circle_outline
                                      : Icons.cancel_outlined,
                                  color: _physio!.isAvailable
                                      ? const Color(AppColors.success)
                                      : const Color(AppColors.error),
                                ),
                              ],
                            ),
                          ),

                          // Book Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton.icon(
                              onPressed: _physio!.isAvailable
                                  ? () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.patientBooking,
                                        arguments: {
                                          'physioId': _physio!.id
                                        },
                                      )
                                  : null,
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Booking Sekarang'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tabs
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Profil'),
                              Tab(text: 'Jadwal'),
                              Tab(text: 'Ulasan'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SliverFillRemaining(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Profile Tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_physio!.bio != null) ...[
                                  const Text(
                                    'Bio',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _physio!.bio!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(AppColors.textSecondary),
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                const Text(
                                  'Informasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InfoRow(
                                    label: 'No. STR',
                                    value: _physio!.noStr ?? '-'),
                                InfoRow(
                                    label: 'Spesialisasi',
                                    value:
                                        _physio!.spesialisasi ?? '-'),
                                InfoRow(
                                    label: 'Pengalaman',
                                    value:
                                        '${_physio!.pengalamanTahun} tahun'),
                              ],
                            ),
                          ),

                          // Schedule Tab
                          _schedules.isEmpty
                              ? const EmptyStateWidget(
                                  title: 'Belum ada jadwal',
                                  icon: Icons.schedule,
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _schedules.length,
                                  itemBuilder: (_, i) {
                                    final s = _schedules[i];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        leading: const Icon(Icons.schedule,
                                            color: Color(AppColors.primary)),
                                        title: Text(
                                          AppHelpers.getHariLabel(s.hari),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${AppHelpers.formatTime(s.jamMulai)} - ${AppHelpers.formatTime(s.jamSelesai)}',
                                        ),
                                        trailing: StatusBadge(
                                          label: s.isAvailable
                                              ? 'Tersedia'
                                              : 'Penuh',
                                          color: s.isAvailable
                                              ? const Color(
                                                  AppColors.success)
                                              : const Color(
                                                  AppColors.error),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                          // Reviews Tab
                          _reviews.isEmpty
                              ? const EmptyStateWidget(
                                  title: 'Belum ada ulasan',
                                  icon: Icons.star_outline,
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _reviews.length,
                                  itemBuilder: (_, i) {
                                    final r = _reviews[i];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor: const Color(
                                                          AppColors.border),
                                                  child: Text(
                                                    (r.patient?.name ??
                                                            'P')
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        r.patient?.name ??
                                                            'Pasien',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        AppHelpers.formatDate(
                                                            r.createdAt),
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Color(AppColors
                                                              .textSecondary),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RatingBarIndicator(
                                                  rating:
                                                      r.rating.toDouble(),
                                                  itemCount: 5,
                                                  itemSize: 14,
                                                  itemBuilder: (_, __) =>
                                                      const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (r.review != null) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                r.review!,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(AppColors
                                                      .textSecondary),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;

  const _InfoChip({
    required this.label,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(AppColors.primary);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: c.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: c,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
