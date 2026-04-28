import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _records = [
    {
      'title': 'Sesi Fisioterapi Lumbal',
      'therapist': 'Ftr. Siti Nurhaliza S.Tr.Kes',
      'date': '25 Mar 2026',
      'status': 'Selesai',
      'statusColor': const Color(0xFFD1FAE5),
      'statusTextColor': const Color(0xFF065F46),
      'diagnosis': 'Nyeri Lumbal Kronik',
      'notes': 'Pasien menunjukkan perkembangan yang baik. Latihan peregangan dilanjutkan.',
      'emoji': '👩‍⚕️',
      'rating': 5,
    },
    {
      'title': 'Terapi Bahu Kanan',
      'therapist': 'Ftr. Ahmad Rizky S.Fis',
      'date': '15 Mar 2026',
      'status': 'Selesai',
      'statusColor': const Color(0xFFD1FAE5),
      'statusTextColor': const Color(0xFF065F46),
      'diagnosis': 'Rotator Cuff Syndrome',
      'notes': 'Program latihan rumah diberikan. Kontrol 2 minggu lagi.',
      'emoji': '👨‍⚕️',
      'rating': 4,
    },
    {
      'title': 'Fisioterapi Lutut',
      'therapist': 'Ftr. Dewi Santoso M.Fis',
      'date': '5 Mar 2026',
      'status': 'Selesai',
      'statusColor': const Color(0xFFD1FAE5),
      'statusTextColor': const Color(0xFF065F46),
      'diagnosis': 'Osteoarthritis Grade II',
      'notes': 'Penambahan sesi hidroterapi disarankan.',
      'emoji': '👩‍⚕️',
      'rating': 5,
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
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF00BBA7), Color(0xFF009689)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Laporan', style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.download_outlined, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                    Text('Riwayat & rekam medis Anda', style: GoogleFonts.inter(color: const Color(0xFFD9EFED), fontSize: 13)),
                    const SizedBox(height: 12),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                      tabs: const [Tab(text: 'Rekam Medis'), Tab(text: 'Rating & Review')],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMedicalRecords(),
                _buildRatings(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRecords() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats row
        Row(
          children: [
            _buildStatCard('24', 'Total Sesi', Icons.calendar_today_outlined, const Color(0xFFDDD6FE)),
            const SizedBox(width: 10),
            _buildStatCard('6', 'Bulan Aktif', Icons.access_time_outlined, const Color(0xFFB2EDE7)),
            const SizedBox(width: 10),
            _buildStatCard('4.9', 'Avg Rating', Icons.star_outline, const Color(0xFFFFE4B5)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Riwayat Sesi', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172B))),
        const SizedBox(height: 12),
        ..._records.map((r) => _buildRecordCard(r)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172B))),
            Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.lightText), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)]),
                  ),
                  child: Center(child: Text(r['emoji'] as String, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['title'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172B))),
                      Text(r['therapist'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.acapulco)),
                      Text(r['date'] as String, style: GoogleFonts.inter(fontSize: 11, color: AppColors.lightText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: r['statusColor'] as Color, borderRadius: BorderRadius.circular(8)),
                  child: Text(r['status'] as String,
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: r['statusTextColor'] as Color)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Diagnosis: ', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightText)),
                    Text(r['diagnosis'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(r['notes'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ...List.generate(5, (i) => Icon(
                      i < (r['rating'] as int) ? Icons.star : Icons.star_border,
                      size: 16, color: const Color(0xFFFFD166),
                    )),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF00BBA7), Color(0xFF009689)]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Lihat Detail', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            children: [
              Text('4.9', style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w800, color: const Color(0xFF0F172B))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => const Icon(Icons.star, size: 22, color: Color(0xFFFFD166))),
              ),
              const SizedBox(height: 4),
              Text('Berdasarkan 24 sesi', style: GoogleFonts.inter(fontSize: 13, color: AppColors.lightText)),
              const SizedBox(height: 16),
              ..._buildRatingBars(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRatingBars() {
    final data = [
      {'star': 5, 'count': 18},
      {'star': 4, 'count': 4},
      {'star': 3, 'count': 1},
      {'star': 2, 'count': 0},
      {'star': 1, 'count': 1},
    ];
    return data.map((d) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text('${d['star']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
          const Icon(Icons.star, size: 13, color: Color(0xFFFFD166)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: (d['count'] as int) / 24.0,
              backgroundColor: const Color(0xFFF3F3F5),
              color: const Color(0xFFFFD166),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text('${d['count']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.lightText)),
        ],
      ),
    )).toList();
  }
}
