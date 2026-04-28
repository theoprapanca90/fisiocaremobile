import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _appointments = [
    {
      'title': 'Sesi Fisioterapi Lumbal',
      'therapist': 'Ftr. Siti Nurhaliza S.Tr.Kes',
      'specialty': 'Spesialis Tulang Belakang',
      'date': 'Senin, 25 Mar 2026',
      'time': '10:00–11:00 WIB',
      'status': 'Terkonfirmasi',
      'statusColor': Color(0xFFFFD166),
      'statusTextColor': Color(0xFF6B4000),
      'type': 'Home Visit',
      'price': 'Rp 150.000',
      'emoji': '👩‍⚕️',
      'tab': 'upcoming',
    },
    {
      'title': 'Terapi Bahu Kanan',
      'therapist': 'Ftr. Ahmad Rizky S.Fis',
      'specialty': 'Fisioterapi Olahraga',
      'date': 'Jumat, 28 Mar 2026',
      'time': '14:00–15:00 WIB',
      'status': 'Menunggu',
      'statusColor': Color(0xFFEFF6FF),
      'statusTextColor': Color(0xFF3B82F6),
      'type': 'Klinik',
      'price': 'Rp 130.000',
      'emoji': '👨‍⚕️',
      'tab': 'upcoming',
    },
    {
      'title': 'Fisioterapi Lutut',
      'therapist': 'Ftr. Dewi Santoso M.Fis',
      'specialty': 'Fisioterapi Ortopedi',
      'date': 'Senin, 1 Apr 2026',
      'time': '09:00–10:00 WIB',
      'status': 'Terjadwal',
      'statusColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'type': 'Home Visit',
      'price': 'Rp 160.000',
      'emoji': '👩‍⚕️',
      'tab': 'upcoming',
    },
    {
      'title': 'Sesi Terapi Punggung',
      'therapist': 'Ftr. Siti Nurhaliza S.Tr.Kes',
      'specialty': 'Spesialis Tulang Belakang',
      'date': 'Jumat, 14 Mar 2026',
      'time': '10:00–11:00 WIB',
      'status': 'Selesai',
      'statusColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'type': 'Home Visit',
      'price': 'Rp 150.000',
      'emoji': '👩‍⚕️',
      'tab': 'history',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_appointments),
                _buildList(_appointments.where((a) => a['tab'] == 'upcoming').toList()),
                _buildList(_appointments.where((a) => a['tab'] == 'history').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                  Text('Janji Temu', style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.filter_list, color: Colors.white, size: 18),
                  ),
                ],
              ),
              Text('Semua janji temu Anda', style: GoogleFonts.inter(color: const Color(0xFFD9EFED), fontSize: 13)),
              const SizedBox(height: 12),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: const [Tab(text: 'Semua'), Tab(text: 'Mendatang'), Tab(text: 'Riwayat')],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📅', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Tidak ada janji temu', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lightText)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _buildCard(items[i]),
    );
  }

  Widget _buildCard(Map<String, dynamic> apt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)]),
                      ),
                      child: Center(child: Text(apt['emoji'], style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(apt['title'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F2B28))),
                          Text(apt['therapist'], style: GoogleFonts.inter(fontSize: 12, color: AppColors.acapulco)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: apt['statusColor'] as Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(apt['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: apt['statusTextColor'] as Color)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade100, height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.acapulco),
                    const SizedBox(width: 5),
                    Text(apt['date'], style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 13, color: AppColors.acapulco),
                    const SizedBox(width: 5),
                    Text(apt['time'], style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: AppColors.acapulco),
                    const SizedBox(width: 5),
                    Text(apt['type'], style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText)),
                    const Spacer(),
                    Text(apt['price'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          if (apt['tab'] == 'upcoming')
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text('Batalkan', style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 0,
                      ),
                      child: Text('Detail', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
