import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../config/app_config.dart';
import '../../models/user_model.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class PhysiotherapistListScreen extends StatefulWidget {
  const PhysiotherapistListScreen({super.key});

  static Widget buildPhysioListPreview(BuildContext context) {
    return const _PhysioPreviewList();
  }

  @override
  State<PhysiotherapistListScreen> createState() =>
      _PhysiotherapistListScreenState();
}

class _PhysiotherapistListScreenState extends State<PhysiotherapistListScreen> {
  final PhysiotherapistService _service = PhysiotherapistService();
  List<PhysiotherapistProfile> _physios = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _selectedMode = args?['mode'];
      _load();
    });
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _service.getPhysiotherapists(
        serviceMode: _selectedMode,
      );
      if (response['success'] == true) {
        final data = response['data']['data'] as List;
        setState(() {
          _physios =
              data.map((e) => PhysiotherapistProfile.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fisioterapis')),
      body: Column(
        children: [
          // Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Semua',
                  selected: _selectedMode == null,
                  onTap: () => setState(() {
                    _selectedMode = null;
                    _load();
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Home Visit',
                  selected: _selectedMode == 'home_visit',
                  onTap: () => setState(() {
                    _selectedMode = 'home_visit';
                    _load();
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Telekonsul',
                  selected: _selectedMode == 'telekonsul',
                  onTap: () => setState(() {
                    _selectedMode = 'telekonsul';
                    _load();
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingWidget(message: 'Memuat fisioterapis...')
                : _error != null
                    ? ErrorStateWidget(message: _error!, onRetry: _load)
                    : _physios.isEmpty
                        ? const EmptyStateWidget(
                            title: 'Tidak ada fisioterapis',
                            subtitle: 'Belum ada fisioterapis yang tersedia',
                            icon: Icons.person_search,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _physios.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) =>
                                PhysioCard(physio: _physios[i]),
                          ),
          ),
        ],
      ),
    );
  }
}

class _PhysioPreviewList extends StatefulWidget {
  const _PhysioPreviewList();

  @override
  State<_PhysioPreviewList> createState() => _PhysioPreviewListState();
}

class _PhysioPreviewListState extends State<_PhysioPreviewList> {
  final PhysiotherapistService _service = PhysiotherapistService();
  List<PhysiotherapistProfile> _physios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await _service.getPhysiotherapists();
      if (response['success'] == true) {
        final data = (response['data']['data'] as List).take(3).toList();
        setState(() {
          _physios =
              data.map((e) => PhysiotherapistProfile.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Column(
      children: _physios
          .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PhysioCard(physio: p),
              ))
          .toList(),
    );
  }
}

class PhysioCard extends StatelessWidget {
  final PhysiotherapistProfile physio;
  const PhysioCard({super.key, required this.physio});

  @override
  Widget build(BuildContext context) {
    final user = physio.user;
    return AppCard(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.physiotherapistDetail,
        arguments: physio.id,
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(AppColors.border),
            backgroundImage: user?.profilePhoto != null
                ? CachedNetworkImageProvider(user!.profilePhoto!)
                : null,
            child: user?.profilePhoto == null
                ? const Icon(Icons.person, size: 32, color: Color(AppColors.textSecondary))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Fisioterapis',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
                if (physio.spesialisasi != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    physio.spesialisasi!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(AppColors.primary),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: physio.ratingAvg,
                      itemCount: 5,
                      itemSize: 14,
                      itemBuilder: (_, __) =>
                          const Icon(Icons.star, color: Colors.amber),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${physio.ratingAvg.toStringAsFixed(1)} (${physio.totalReviews})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 12,
                      color: Color(AppColors.textSecondary),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${physio.pengalamanTahun} thn pengalaman',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppHelpers.formatCurrency(physio.tarifDefault),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: physio.isAvailable
                      ? const Color(AppColors.success).withOpacity(0.15)
                      : const Color(AppColors.error).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  physio.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                  style: TextStyle(
                    fontSize: 11,
                    color: physio.isAvailable
                        ? const Color(AppColors.success)
                        : const Color(AppColors.error),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(AppColors.primary)
              : const Color(AppColors.background),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(AppColors.primary)
                : const Color(AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
