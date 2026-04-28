import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/therapist_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/models/app_models.dart';
import 'therapist_profile_screen.dart';

class TherapistDashboardScreen extends StatelessWidget {
  const TherapistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TherapistController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: controller.navIndex.value,
        children: const [
          _DashboardTab(),
          _PatientsTab(),
          _ScheduleTab(),
          TherapistProfileScreen(),
        ],
      ),
      bottomNavigationBar: TherapistBottomNavBar(
        currentIndex: controller.navIndex.value,
        onTap: controller.changeNav,
      ),
    ));
  }
}

// ── Dashboard Tab ─────────────────────────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TherapistController>();
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: ctrl.loadActiveBookings,
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 130,
              pinned: true,
              backgroundColor: AppColors.primary,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                  child: Row(children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.health_and_safety, color: AppColors.primary, size: 24)))),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('FisioCare', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      Obx(() => Text('Halo, ${ctrl.name.value.isNotEmpty ? ctrl.name.value.split(' ').first : "Fisioterapis"}!',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.mint))),
                    ])),
                    // Status badge
                    Obx(() => GestureDetector(
                      onTap: ctrl.toggleAvailability,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: ctrl.isAvailable.value ? Colors.white.withOpacity(0.2) : Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: Row(children: [
                          Icon(Icons.circle, size: 8, color: ctrl.isAvailable.value ? const Color(0xFF22C55E) : Colors.red),
                          const SizedBox(width: 5),
                          Text(ctrl.isAvailable.value ? 'Aktif' : 'Nonaktif',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    )),
                  ]),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // ── Stats ───────────────────────────────────────────
                  Obx(() => Row(children: [
                    _QuickStat(
                      label: 'Booking Aktif',
                      value: '${ctrl.activeBookings.length}',
                      icon: Icons.calendar_today,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _QuickStat(
                      label: 'Selesai',
                      value: '${ctrl.historyBookings.where((b) => b.statusBooking == 'completed').length}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _QuickStat(
                      label: 'Rating',
                      value: ctrl.ratingAvg.value.toStringAsFixed(1),
                      icon: Icons.star_outline,
                      color: const Color(0xFFEAB308),
                    ),
                  ])),
                  const SizedBox(height: 20),

                  // ── Aksi Cepat ─────────────────────────────────────
                  const Text('Aksi Cepat', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontLG, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _ActionCard(icon: Icons.refresh, label: 'Refresh', color: AppColors.primary,
                        onTap: ctrl.loadActiveBookings)),
                    const SizedBox(width: 10),
                    Expanded(child: _ActionCard(icon: Icons.toggle_on, label: ctrl.isAvailable.value ? 'Nonaktifkan' : 'Aktifkan',
                        color: ctrl.isAvailable.value ? AppColors.error : AppColors.success,
                        onTap: ctrl.toggleAvailability)),
                  ]),
                  const SizedBox(height: 20),

                  // ── Booking Aktif ───────────────────────────────────
                  const Text('Booking Masuk', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontLG, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (ctrl.isLoadingBookings.value) {
                      return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary)));
                    }
                    if (ctrl.activeBookings.isEmpty) {
                      return _EmptyBooking();
                    }
                    return Column(
                      children: ctrl.activeBookings.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _TherapistBookingCard(booking: b, ctrl: ctrl),
                      )).toList(),
                    );
                  }),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _QuickStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusMD), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontLG, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _EmptyBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG), border: Border.all(color: AppColors.border)),
    child: Column(children: [
      Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
      const SizedBox(height: 12),
      const Text('Belum ada booking masuk', style: TextStyle(color: AppColors.textMuted, fontFamily: 'Inter', fontSize: AppSizes.fontSM)),
    ]),
  );
}

class _TherapistBookingCard extends StatelessWidget {
  final BookingModel booking;
  final TherapistController ctrl;
  const _TherapistBookingCard({required this.booking, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final statusColor = ctrl.getStatusColor(booking.statusBooking);
    final statusLabel = ctrl.getStatusLabel(booking.statusBooking);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.person_outline, color: AppColors.primary, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Booking #${booking.bookingCode}',
                style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('${booking.bookingDate} • ${booking.startTime}',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ]),
        if (booking.keluhanAwal != null && booking.keluhanAwal!.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.notes, size: 13, color: AppColors.textMuted),
            const SizedBox(width: 5),
            Expanded(child: Text(booking.keluhanAwal!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis)),
          ]),
        ],
        // Action buttons for pending bookings
        if (booking.statusBooking == 'pending') ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => ctrl.updateBookingStatus(booking.id, 'cancelled'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Tolak', style: TextStyle(fontSize: 12)),
            )),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(
              onPressed: () => ctrl.updateBookingStatus(booking.id, 'confirmed'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              child: const Text('Terima', style: TextStyle(fontSize: 12)),
            )),
          ]),
        ],
        if (booking.statusBooking == 'confirmed' || booking.statusBooking == 'paid') ...[
          const SizedBox(height: 10),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ctrl.updateBookingStatus(booking.id, 'on_process'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              child: const Text('Mulai Sesi', style: TextStyle(fontSize: 12)),
            )),
        ],
        if (booking.statusBooking == 'on_process') ...[
          const SizedBox(height: 10),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ctrl.updateBookingStatus(booking.id, 'completed'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              child: const Text('Selesaikan Sesi', style: TextStyle(fontSize: 12)),
            )),
        ],
      ]),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 10),
        Flexible(child: Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
      ]),
    ),
  );
}

// ── Patients Tab ──────────────────────────────────────────────────────────────
class _PatientsTab extends StatelessWidget {
  const _PatientsTab();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TherapistController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: const Text('Riwayat Pasien', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: Obx(() {
        if (ctrl.isLoadingBookings.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final completed = ctrl.historyBookings.where((b) => b.statusBooking == 'completed').toList();
        if (completed.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 12),
            const Text('Belum ada riwayat pasien', style: TextStyle(color: AppColors.textMuted, fontFamily: 'Inter')),
          ]));
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: ctrl.loadActiveBookings,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: completed.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final b = completed[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusLG), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  Container(width: 46, height: 46,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: AppColors.primary, size: 26)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Booking #${b.bookingCode}', style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(b.bookingDate, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    if (b.keluhanAwal != null) Text(b.keluhanAwal!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Selesai', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success))),
                ]),
              );
            },
          ),
        );
      }),
    );
  }
}

// ── Schedule Tab ──────────────────────────────────────────────────────────────
class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TherapistController>();
    final days = ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu', 'minggu'];
    final dayLabels = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: const Text('Jadwal Praktik', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: ctrl.loadSchedules)],
      ),
      body: Obx(() {
        if (ctrl.isLoadingSchedules.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (ctrl.mySchedules.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.calendar_month_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 12),
            const Text('Belum ada jadwal praktik', style: TextStyle(color: AppColors.textMuted, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            const Text('Jadwal dikelola oleh admin', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ]));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: days.asMap().entries.map((e) {
            final daySchedules = ctrl.mySchedules.where((s) => s['hari'] == e.value).toList();
            if (daySchedules.isEmpty) return const SizedBox();
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(dayLabels[e.key], style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              ...daySchedules.map((s) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusMD), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Text('${s['jam_mulai']} - ${s['jam_selesai']}',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const Spacer(),
                  Text('Kuota: ${s['kuota']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(width: 10),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: s['status'] == 'available' ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                    child: Text(s['status'] == 'available' ? 'Tersedia' : 'Tidak',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                            color: s['status'] == 'available' ? AppColors.success : AppColors.error))),
                ]),
              )),
            ]);
          }).toList(),
        );
      }),
    );
  }
}
