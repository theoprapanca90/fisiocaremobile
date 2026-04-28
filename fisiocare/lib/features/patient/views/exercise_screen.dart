import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _filterIndex = 0;
  final List<String> _filters = ['Semua', 'Aktif', 'Selesai', 'Baru'];

  final List<Map<String, dynamic>> _programs = [
    {
      'title': 'Program Stroke Recovery',
      'exercises': 10,
      'completed': 7,
      'duration': '30 menit',
      'level': 'Menengah',
      'color': Color(0xFF009689),
      'icon': Icons.self_improvement,
      'status': 'active',
      'badge': 'Aktif',
    },
    {
      'title': 'Terapi Cedera Lutut',
      'exercises': 8,
      'completed': 8,
      'duration': '25 menit',
      'level': 'Ringan',
      'color': Color(0xFF22C55E),
      'icon': Icons.accessibility_new,
      'status': 'done',
      'badge': 'Selesai',
    },
    {
      'title': 'Core Strengthening',
      'exercises': 12,
      'completed': 0,
      'duration': '40 menit',
      'level': 'Menengah',
      'color': Color(0xFF6366F1),
      'icon': Icons.fitness_center,
      'status': 'new',
      'badge': 'Baru',
    },
    {
      'title': 'Balance & Fall Prevention',
      'exercises': 6,
      'completed': 3,
      'duration': '20 menit',
      'level': 'Ringan',
      'color': Color(0xFFF59E0B),
      'icon': Icons.sports_gymnastics,
      'status': 'active',
      'badge': 'Aktif',
    },
    {
      'title': 'Mobilisasi Sendi',
      'exercises': 9,
      'completed': 0,
      'duration': '35 menit',
      'level': 'Lanjutan',
      'color': Color(0xFFEF4444),
      'icon': Icons.airline_seat_recline_extra,
      'status': 'new',
      'badge': 'Baru',
    },
    {
      'title': 'Home Exercise Program',
      'exercises': 5,
      'completed': 5,
      'duration': '15 menit',
      'level': 'Ringan',
      'color': Color(0xFF3B82F6),
      'icon': Icons.home,
      'status': 'done',
      'badge': 'Selesai',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filterIndex == 0) return _programs;
    final map = ['Semua', 'active', 'done', 'new'];
    return _programs.where((e) => e['status'] == map[_filterIndex]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            title: const Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'Program Latihan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: [
                      _StatChip(label: 'Total Program', value: '${_programs.length}', icon: Icons.list_alt, color: AppColors.primary),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Sedang Aktif', value: '${_programs.where((e) => e['status'] == 'active').length}', icon: Icons.play_circle, color: const Color(0xFF6366F1)),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Selesai', value: '${_programs.where((e) => e['status'] == 'done').length}', icon: Icons.check_circle, color: const Color(0xFF22C55E)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Booking Banner
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.white, size: 28),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Buat Jadwal Terapi',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: AppSizes.fontSM,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Konsultasikan program latihan dengan terapis Anda',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: AppColors.mint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filter Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (i) {
                        final sel = i == _filterIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _filterIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            child: Text(
                              _filters[i],
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: AppSizes.fontSM,
                                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                                color: sel ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Program List
                  ..._filtered.map((prog) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ProgramCard(program: prog),
                  )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Map<String, dynamic> program;
  const _ProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    final total = program['exercises'] as int;
    final done = program['completed'] as int;
    final progress = total > 0 ? done / total : 0.0;
    final color = program['color'] as Color;
    final status = program['status'] as String;
    final badgeColors = {
      'active': const Color(0xFF009689),
      'done': const Color(0xFF22C55E),
      'new': const Color(0xFF6366F1),
    };

    return GestureDetector(
      onTap: () {},
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
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(program['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program['title'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: AppSizes.fontSM,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 11, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Text(program['duration'], style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                          Text(program['level'], style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badgeColors[status] ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    program['badge'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: badgeColors[status] ?? AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            if (status != 'new') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$done/$total latihan', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.inputBg,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Detail', style: TextStyle(fontSize: AppSizes.fontSM)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      status == 'done' ? 'Ulang' : 'Mulai',
                      style: const TextStyle(fontSize: AppSizes.fontSM),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
