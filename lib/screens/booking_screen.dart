import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {'icon': '🦴', 'name': 'Cedera', 'color': const Color(0xFFDDD6FE)},
    {'icon': '🧠', 'name': 'Stroke', 'color': const Color(0xFFB2EDE7)},
    {'icon': '👴', 'name': 'Lansia', 'color': const Color(0xFFFFE4B5)},
    {'icon': '🩹', 'name': 'Pasca Op.', 'color': const Color(0xFFFFCCCC)},
    {'icon': '👶', 'name': 'Pediatri', 'color': const Color(0xFFCCE8FF)},
    {'icon': '🏃', 'name': 'Olahraga', 'color': const Color(0xFFD1FAE5)},
  ];

  final List<Map<String, dynamic>> _therapists = [
    {
      'name': 'Ftr. Siti Nurhaliza S.Tr.Kes',
      'specialty': 'Spesialis Fisioterapi Tulang Belakang',
      'rating': 4.9,
      'sessions': 120,
      'price': 'Rp 150.000',
      'emoji': '👩‍⚕️',
    },
    {
      'name': 'Ftr. Ahmad Rizky S.Fis',
      'specialty': 'Fisioterapi Olahraga & Cedera',
      'rating': 4.8,
      'sessions': 98,
      'price': 'Rp 130.000',
      'emoji': '👨‍⚕️',
    },
    {
      'name': 'Ftr. Dewi Santoso M.Fis',
      'specialty': 'Fisioterapi Pediatri & Lansia',
      'rating': 4.9,
      'sessions': 145,
      'price': 'Rp 160.000',
      'emoji': '👩‍⚕️',
    },
    {
      'name': 'Ftr. Budi Pratama S.Tr.Kes',
      'specialty': 'Stroke Rehabilitation',
      'rating': 4.7,
      'sessions': 87,
      'price': 'Rp 140.000',
      'emoji': '👨‍⚕️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00BBA7), Color(0xFF009689)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pemesanan', style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    Text('Pilih fisioterapis untuk Anda', style: GoogleFonts.inter(color: const Color(0xFFD9EFED), fontSize: 13)),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'Fisioterapis'), Tab(text: 'Layanan')],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 220,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTherapistList(),
                  _buildServiceList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTherapistList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search bar
        Container(
          height: 44,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari fisioterapis...',
              hintStyle: GoogleFonts.inter(color: AppColors.hintText, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: AppColors.hintText, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              fillColor: Colors.transparent,
              filled: false,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Categories
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (ctx, i) {
              final selected = _selectedCategory == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_categories[i]['icon'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(
                        _categories[i]['name'],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: selected ? Colors.white : const Color(0xFF0F172B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ..._therapists.map((t) => _buildTherapistCard(t)),
      ],
    );
  }

  Widget _buildTherapistCard(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)]),
            ),
            child: Center(child: Text(t['emoji'], style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['name'], style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0F2B28))),
                Text(t['specialty'], style: GoogleFonts.inter(fontSize: 11, color: AppColors.acapulco)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 13, color: Color(0xFFFFD166)),
                    const SizedBox(width: 3),
                    Text('${t['rating']}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text('${t['sessions']} sesi', style: GoogleFonts.inter(fontSize: 11, color: AppColors.lightText)),
                    const Spacer(),
                    Text(t['price'], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    final services = [
      {'emoji': '🦴', 'name': 'Cedera Olahraga', 'desc': 'Pemulihan cedera akibat aktivitas olahraga', 'color': const Color(0xFFDDD6FE)},
      {'emoji': '🧠', 'name': 'Terapi Stroke', 'desc': 'Rehabilitasi pasca stroke', 'color': const Color(0xFFB2EDE7)},
      {'emoji': '🦵', 'name': 'Nyeri Sendi', 'desc': 'Penanganan nyeri sendi kronis', 'color': const Color(0xFFFFE4B5)},
      {'emoji': '🩹', 'name': 'Pasca Operasi', 'desc': 'Pemulihan setelah tindakan bedah', 'color': const Color(0xFFFFCCCC)},
      {'emoji': '👴', 'name': 'Fisioterapi Lansia', 'desc': 'Layanan khusus untuk lansia', 'color': const Color(0xFFD1FAE5)},
      {'emoji': '👶', 'name': 'Fisioterapi Pediatri', 'desc': 'Layanan fisioterapi untuk anak-anak', 'color': const Color(0xFFCCE8FF)},
      {'emoji': '🦷', 'name': 'Skoliosis', 'desc': 'Penanganan kelainan tulang belakang', 'color': const Color(0xFFFEE2E2)},
      {'emoji': '🏃', 'name': 'Fraktur', 'desc': 'Rehabilitasi patah tulang', 'color': const Color(0xFFE0E7FF)},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (ctx, i) {
        final s = services[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: s['color'] as Color, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(s['emoji'] as String, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['name'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(s['desc'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.lightText),
            ],
          ),
        );
      },
    );
  }
}
