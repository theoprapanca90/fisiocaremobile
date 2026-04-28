import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/patient_controller.dart';
import '../../../core/models/app_models.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = DateTime.now().day;
  int _tabIndex = 0; // 0=Mendatang, 1=Riwayat, 2=Dibatalkan

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PatientController>();
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookingSheet(context, ctrl),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Buat Jadwal',
            style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            title: const Row(children: [
              Icon(Icons.calendar_month, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text('Jadwal Terapi',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            ]),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(children: [
                  _TabBtn(label: 'Mendatang', selected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
                  const SizedBox(width: 8),
                  _TabBtn(label: 'Riwayat', selected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
                  const SizedBox(width: 8),
                  _TabBtn(label: 'Dibatalkan', selected: _tabIndex == 2, onTap: () => setState(() => _tabIndex = 2)),
                ]),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Obx(() {
              // Filter bookings by tab
              List<BookingModel> filtered = ctrl.bookings.where((b) {
                if (_tabIndex == 0) return ['pending', 'confirmed', 'paid', 'on_process'].contains(b.statusBooking);
                if (_tabIndex == 1) return b.statusBooking == 'completed';
                return b.statusBooking == 'cancelled';
              }).toList();

              // Filter by selected day
              final dayFiltered = filtered.where((b) {
                try {
                  return DateTime.parse(b.bookingDate).day == _selectedDay;
                } catch (_) { return false; }
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar strip
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('${_monthName(now.month)} ${now.year}',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontLG, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 52,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: daysInMonth,
                          itemBuilder: (_, i) {
                            final day = i + 1;
                            final isSelected = day == _selectedDay;
                            final isToday = day == now.day;
                            final hasBkg = filtered.any((b) {
                              try { return DateTime.parse(b.bookingDate).day == day; } catch (_) { return false; }
                            });
                            return GestureDetector(
                              onTap: () => setState(() => _selectedDay = day),
                              child: Container(
                                width: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : (isToday ? AppColors.primary.withOpacity(0.1) : Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                  border: isToday && !isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text('$day',
                                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : AppColors.textPrimary)),
                                  if (hasBkg)
                                    Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(color: isSelected ? Colors.white : AppColors.primary, shape: BoxShape.circle)),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Sessions list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_tabIndex == 0 ? 'Jadwal Mendatang' : _tabIndex == 1 ? 'Riwayat Terapi' : 'Dibatalkan',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontLG, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      if (ctrl.isLoadingBookings.value)
                        const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary)))
                      else if (dayFiltered.isEmpty)
                        _EmptyState(tabIndex: _tabIndex)
                      else
                        ...dayFiltered.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _BookingCard(booking: b, ctrl: ctrl),
                        )),
                    ]),
                  ),
                  const SizedBox(height: 100),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const months = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[m];
  }

  void _showBookingSheet(BuildContext context, PatientController ctrl) {
    int? selectedServiceId;
    final keluhanCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    ctrl.loadServices();
    ctrl.loadTherapists();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (ctx, scrollCtrl) => StatefulBuilder(
          builder: (ctx, setS) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Buat Jadwal Baru',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(controller: scrollCtrl, children: [
                  // Pilih Layanan
                  const Text('Pilih Layanan *', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (ctrl.services.isEmpty) return const Text('Memuat layanan...', style: TextStyle(color: AppColors.textMuted));
                    return Column(
                      children: ctrl.services.map((s) {
                        final isSelected = selectedServiceId == s['id'];
                        return GestureDetector(
                          onTap: () => setS(() => selectedServiceId = s['id']),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
                            ),
                            child: Row(children: [
                              Icon(Icons.medical_services_outlined, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 20),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(s['nama_layanan'], style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600,
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                                Text('Rp ${_formatCurrency(s['harga'])} • ${s['durasi_menit']} menit',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ])),
                              if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                            ]),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Tanggal
                  const Text('Tanggal *', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                        builder: (ctx, child) => Theme(
                          data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setS(() => dateCtrl.text = '${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}');
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          hintText: 'Pilih tanggal',
                          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: AppSizes.fontSM),
                          prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                          filled: true, fillColor: AppColors.inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Jam
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Jam Mulai *', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                          if (t != null) setS(() => startCtrl.text = '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}');
                        },
                        child: AbsorbPointer(child: TextField(controller: startCtrl,
                          decoration: InputDecoration(hintText: '09:00', hintStyle: const TextStyle(color: AppColors.textHint, fontSize: AppSizes.fontSM),
                            prefixIcon: const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                            filled: true, fillColor: AppColors.inputBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
                      ),
                    ])),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Jam Selesai *', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
                          if (t != null) setS(() => endCtrl.text = '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}');
                        },
                        child: AbsorbPointer(child: TextField(controller: endCtrl,
                          decoration: InputDecoration(hintText: '10:00', hintStyle: const TextStyle(color: AppColors.textHint, fontSize: AppSizes.fontSM),
                            prefixIcon: const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                            filled: true, fillColor: AppColors.inputBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
                      ),
                    ])),
                  ]),
                  const SizedBox(height: 16),

                  // Keluhan
                  const Text('Keluhan Awal', style: TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: keluhanCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Deskripsikan keluhan Anda...',
                      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: AppSizes.fontSM),
                      filled: true, fillColor: AppColors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Submit
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ctrl.isLoadingBookings.value ? null : () async {
                        if (selectedServiceId == null) {
                          Get.snackbar('Perhatian', 'Pilih layanan terlebih dahulu',
                              backgroundColor: AppColors.warning, colorText: Colors.white);
                          return;
                        }
                        if (dateCtrl.text.isEmpty || startCtrl.text.isEmpty || endCtrl.text.isEmpty) {
                          Get.snackbar('Perhatian', 'Lengkapi tanggal dan jam',
                              backgroundColor: AppColors.warning, colorText: Colors.white);
                          return;
                        }
                        final ok = await ctrl.createBooking(
                          serviceId: selectedServiceId!,
                          therapistId: null,
                          bookingDate: dateCtrl.text,
                          startTime: '${startCtrl.text}:00',
                          endTime: '${endCtrl.text}:00',
                          keluhan: keluhanCtrl.text,
                        );
                        if (ok) {
                          Navigator.pop(context);
                          Get.snackbar('Berhasil', 'Jadwal berhasil dibuat',
                              backgroundColor: AppColors.primary, colorText: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: ctrl.isLoadingBookings.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Buat Jadwal', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  )),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(dynamic val) {
    final n = double.tryParse(val.toString()) ?? 0;
    return n.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final int tabIndex;
  const _EmptyState({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final messages = ['Tidak ada jadwal mendatang di hari ini', 'Belum ada riwayat terapi', 'Tidak ada jadwal dibatalkan'];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          Icon(Icons.calendar_today_outlined, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(messages[tabIndex], style: const TextStyle(color: AppColors.textMuted, fontSize: AppSizes.fontSM), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Booking Card ──────────────────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final PatientController ctrl;
  const _BookingCard({required this.booking, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final statusColor = ctrl.getStatusColor(booking.statusBooking);
    final statusLabel = ctrl.getStatusLabel(booking.statusBooking);
    final isCancellable = ['pending', 'confirmed'].contains(booking.statusBooking);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Booking #${booking.bookingCode}',
                style: const TextStyle(fontFamily: 'Inter', fontSize: AppSizes.fontSM, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(booking.bookingDate, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.access_time, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 5),
          Text('${booking.startTime} - ${booking.endTime}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ]),
        if (booking.keluhanAwal != null && booking.keluhanAwal!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.notes, size: 13, color: AppColors.textMuted),
            const SizedBox(width: 5),
            Expanded(child: Text(booking.keluhanAwal!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis)),
          ]),
        ],
        if (isCancellable) ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => _confirmCancel(context),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Batalkan', style: TextStyle(fontSize: 12)),
            )),
          ]),
        ],
      ]),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Batalkan Booking'),
        content: const Text('Yakin ingin membatalkan jadwal ini?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tidak')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              // Update status via supabase
              final db = Get.find<PatientController>();
              await db.createBooking(
                serviceId: booking.serviceId,
                therapistId: booking.physiotherapistId,
                bookingDate: booking.bookingDate,
                startTime: booking.startTime,
                endTime: booking.endTime,
                keluhan: booking.keluhanAwal ?? '',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Tab Button ────────────────────────────────────────────────────────────────
class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? AppColors.primary : Colors.white)),
    ),
  );
}
