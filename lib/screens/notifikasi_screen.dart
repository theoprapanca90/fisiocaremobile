import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Booking Baru',
      'subtitle': 'Ahmad Rizki ingin melakukan booking sesi baru untuk Terapi Bahu',
      'time': '5 menit lalu',
      'icon': Icons.calendar_today,
      'color': Color(0xFFEFF6FF),
      'iconColor': AppColors.primary,
      'read': false,
      'type': 'booking',
      'actionable': true,
    },
    {
      'title': 'Review dari Pasien',
      'subtitle': 'Budi Santoso memberikan rating 5 bintang untuk sesi terapi Anda',
      'time': '1 jam lalu',
      'icon': Icons.star,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFF59E0B),
      'read': false,
      'type': 'review',
      'actionable': false,
    },
    {
      'title': 'Pembayaran Diterima',
      'subtitle': 'Pembayaran untuk sesi tanggal 25 Maret sebesar Rp 150.000 telah diterima',
      'time': '2 jam lalu',
      'icon': Icons.check_circle,
      'color': Color(0xFFD1FAE5),
      'iconColor': Color(0xFF10B981),
      'read': true,
      'type': 'payment',
      'actionable': false,
    },
    {
      'title': 'Pembatalan Sesi',
      'subtitle': 'Siti Nurhaliza membatalkan sesi pada 28 Maret pukul 14:00',
      'time': '3 jam lalu',
      'icon': Icons.cancel,
      'color': Color(0xFFFEE2E2),
      'iconColor': Color(0xFFEF4444),
      'read': true,
      'type': 'cancellation',
      'actionable': false,
    },
    {
      'title': 'Pengingat Sesi',
      'subtitle': 'Anda memiliki sesi fisioterapi dengan Budi Santoso dalam 2 jam',
      'time': '1 hari lalu',
      'icon': Icons.notifications_active,
      'color': Color(0xFFDDD6FE),
      'iconColor': AppColors.primary,
      'read': true,
      'type': 'reminder',
      'actionable': false,
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

  List<Map<String, dynamic>> get _unreadNotifications =>
      _notifications.where((n) => !n['read']).toList();

  List<Map<String, dynamic>> get _readNotifications =>
      _notifications.where((n) => n['read']).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Notifikasi', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.lightText,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(child: Text('Semua', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Belum dibaca', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      if (_unreadNotifications.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_unreadNotifications.length}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(child: Text('Sudah dibaca', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(_notifications),
          _buildNotificationList(_unreadNotifications),
          _buildNotificationList(_readNotifications),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: AppColors.lightText),
            const SizedBox(height: 16),
            Text(
              'Tidak ada notifikasi',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText),
            ),
            const SizedBox(height: 8),
            Text(
              'Notifikasi akan muncul di sini',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildNotificationCard(notif, context),
        );
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notif['read'] ? Colors.white : notif['color'],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notif['read'] ? AppColors.borderColor : notif['iconColor'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: notif['color'].withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(notif['icon'] as IconData, color: notif['iconColor'], size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notif['title'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        if (!notif['read'])
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['subtitle'],
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif['time'],
                      style: GoogleFonts.inter(fontSize: 9, color: AppColors.lightText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (notif['actionable'])
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ Booking diterima!',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        child: Text(
                          'Terima',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '❌ Booking ditolak',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: Text(
                          'Tolak',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
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
