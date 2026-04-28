import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class JadwalTerapiScreen extends StatefulWidget {
  const JadwalTerapiScreen({super.key});

  @override
  State<JadwalTerapiScreen> createState() => _JadwalTerapiScreenState();
}

class _JadwalTerapiScreenState extends State<JadwalTerapiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDayIndex = 1;

  final List<Map<String, String>> _days = [
    {'day': 'Min', 'date': '23'},
    {'day': 'Sen', 'date': '24'},
    {'day': 'Sel', 'date': '25'},
    {'day': 'Rab', 'date': '26'},
    {'day': 'Kam', 'date': '27'},
    {'day': 'Jum', 'date': '28'},
    {'day': 'Sab', 'date': '29'},
  ];

  final List<Map<String, dynamic>> _upcomingSessions = [
    {
      'title': 'Sesi Fisioterapi Lumbal',
      'therapist': 'Ftr. Siti Nurhaliza S.Tr.Kes',
      'specialty': 'Tulang Belakang',
      'time': '10:00–11:00',
      'date': 'Senin, 25 Mar 2026',
      'status': 'Terkonfirmasi',
      'statusColor': const Color(0xFFFFD166),
      'statusTextColor': const Color(0xFF6B4000),
      'type': 'Home Visit',
      'emoji': '👩‍⚕️',
      'gradient': true,
    },
    {
      'title': 'Terapi Bahu Kanan',
      'therapist': 'Ftr. Ahmad Rizky S.Fis',
      'specialty': 'Klinik FisioCare',
      'time': '14:00–15:00',
      'date': 'Jumat, 28 Mar 2026',
      'status': 'Menunggu',
      'statusColor': const Color(0xFFEFF6FF),
      'statusTextColor': const Color(0xFF3B82F6),
      'type': 'Klinik',
      'emoji': '👨‍⚕️',
      'gradient': false,
    },
    {
      'title': 'Fisioterapi Lutut',
      'therapist': 'Ftr. Dewi Santoso M.Fis',
      'specialty': 'Ortopedi',
      'time': '09:00–10:00',
      'date': 'Senin, 1 Apr 2026',
      'status': 'Terjadwal',
      'statusColor': const Color(0xFFD1FAE5),
      'statusTextColor': const Color(0xFF065F46),
      'type': 'Home Visit',
      'emoji': '👩‍⚕️',
      'gradient': false,
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
          _buildPageHeader(context),
          _buildCalendarStrip(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSessionList(),
                _buildSessionList(filter: 'Terkonfirmasi'),
                _buildSessionList(filter: 'Riwayat'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF00BBA7), Color(0xFF009689)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Jadwal Terapi',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Kelola jadwal sesi fisioterapi Anda',
                  style: GoogleFonts.inter(color: const Color(0xFFD9EFED), fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (i) {
          final isSelected = _selectedDayIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Text(_days[i]['day']!,
                      style: GoogleFonts.inter(fontSize: 11, color: isSelected ? Colors.white.withOpacity(0.85) : AppColors.lightText)),
                  const SizedBox(height: 4),
                  Text(_days[i]['date']!,
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : const Color(0xFF0F2B28))),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.lightText,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Mendatang'),
          Tab(text: 'Riwayat'),
        ],
      ),
    );
  }

  Widget _buildSessionList({String? filter}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Sesi Mendatang',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F2B28))),
        const SizedBox(height: 12),
        ..._upcomingSessions.map((s) => _buildSessionCard(s)),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final isGradient = session['gradient'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isGradient
            ? const LinearGradient(colors: [Color(0xFF00BBA7), Color(0xFF009689)], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        color: isGradient ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isGradient ? const Color(0xFF009B89).withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isGradient ? Colors.white.withOpacity(0.2) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(session['date'] as String,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isGradient ? Colors.white : AppColors.lightText)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: session['statusColor'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(session['status'] as String,
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: session['statusTextColor'] as Color)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: isGradient ? Colors.white.withOpacity(0.2) : const Color(0xFFB2EDE7),
                  borderRadius: BorderRadius.circular(12),
                  border: isGradient ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
                ),
                child: Center(child: Text(session['emoji'] as String, style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session['title'] as String,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: isGradient ? Colors.white : const Color(0xFF0F2B28))),
                    Text(session['therapist'] as String,
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w500, color: isGradient ? Colors.white.withOpacity(0.85) : AppColors.acapulco)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: isGradient ? Colors.white.withOpacity(0.2) : const Color(0xFFE2E8F0), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, size: 13, color: isGradient ? Colors.white : AppColors.lightText),
              const SizedBox(width: 4),
              Text(session['time'] as String,
                  style: GoogleFonts.inter(fontSize: 11, color: isGradient ? Colors.white : AppColors.lightText)),
              const SizedBox(width: 12),
              Icon(Icons.location_on_outlined, size: 13, color: isGradient ? Colors.white : AppColors.lightText),
              const SizedBox(width: 4),
              Text(session['type'] as String,
                  style: GoogleFonts.inter(fontSize: 11, color: isGradient ? Colors.white : AppColors.lightText)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isGradient ? Colors.white.withOpacity(0.5) : const Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text('Reschedule',
                      style: GoogleFonts.inter(fontSize: 12, color: isGradient ? Colors.white : AppColors.lightText)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGradient ? Colors.white : AppColors.primary,
                    foregroundColor: isGradient ? AppColors.primary : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                  ),
                  child: Text('Detail',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isGradient ? AppColors.primary : Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
