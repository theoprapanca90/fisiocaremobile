import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Semua', 'Stroke', 'Cedera', 'Lansia', 'Lainnya'];

  final List<Map<String, dynamic>> _articles = [
    {
      'title': 'Panduan Lengkap Terapi Pasca Operasi',
      'category': 'Pasca Operasi',
      'duration': '8 menit baca',
      'tag': 'Populer',
      'tagColor': Color(0xFF6366F1),
      'icon': Icons.healing_outlined,
      'color': Color(0xFF6366F1),
    },
    {
      'title': '5 Latihan Efektif untuk Pemulihan Stroke',
      'category': 'Stroke',
      'duration': '5 menit baca',
      'tag': null,
      'icon': Icons.self_improvement,
      'color': Color(0xFF009689),
    },
    {
      'title': 'Mengatasi Nyeri Punggung dengan Fisioterapi',
      'category': 'Nyeri',
      'duration': '6 menit baca',
      'tag': 'Baru',
      'tagColor': Color(0xFF22C55E),
      'icon': Icons.accessibility_new,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'Olahraga Aman untuk Lansia',
      'category': 'Lansia',
      'duration': '4 menit baca',
      'tag': null,
      'icon': Icons.elderly,
      'color': Color(0xFFEF4444),
    },
    {
      'title': 'Pencegahan Cedera Olahraga',
      'category': 'Cedera',
      'duration': '7 menit baca',
      'tag': null,
      'icon': Icons.sports,
      'color': Color(0xFF3B82F6),
    },
    {
      'title': 'Fisioterapi untuk Skoliosis',
      'category': 'Lainnya',
      'duration': '5 menit baca',
      'tag': null,
      'icon': Icons.airline_seat_flat,
      'color': Color(0xFF8B5CF6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            title: const Row(
              children: [
                Icon(Icons.menu_book, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'Edukasi Kesehatan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: AppColors.primary,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _tabs.length,
                  itemBuilder: (_, i) {
                    final selected = i == _selectedTab;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _tabs[i],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected ? AppColors.primary : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
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
                  // Search Bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari artikel...',
                        hintStyle: TextStyle(color: AppColors.textHint, fontSize: AppSizes.fontSM),
                        prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Featured Article
                  const Text(
                    'Artikel Unggulan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontLG,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FeaturedArticleCard(article: _articles[0]),
                  const SizedBox(height: 20),

                  // Article List
                  const Text(
                    'Semua Artikel',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontLG,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    _articles.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ArticleListCard(article: _articles[i]),
                    ),
                  ),
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

class _FeaturedArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  const _FeaturedArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [(article['color'] as Color).withOpacity(0.9), (article['color'] as Color)],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    article['category'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (article['tag'] != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article['tag'],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: article['tagColor'] ?? AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              article['title'],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 13, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  article['duration'],
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Baca',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: article['color'] as Color,
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

class _ArticleListCard extends StatelessWidget {
  final Map<String, dynamic> article;
  const _ArticleListCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
                color: (article['color'] as Color).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(article['icon'] as IconData, color: article['color'] as Color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article['tag'] != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (article['tagColor'] as Color? ?? AppColors.primary).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        article['tag'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: article['tagColor'] as Color? ?? AppColors.primary,
                        ),
                      ),
                    ),
                  Text(
                    article['title'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSizes.fontSM,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        article['category'],
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                      const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                      const Icon(Icons.access_time, size: 11, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Text(
                        article['duration'],
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
