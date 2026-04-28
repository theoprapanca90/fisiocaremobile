import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String?> _statuses = [null, 'pending', 'confirmed', 'on_process', 'completed', 'cancelled'];
  final List<String> _labels = ['Semua', 'Menunggu', 'Konfirmasi', 'Proses', 'Selesai', 'Batal'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Saya'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _labels.map((l) => Tab(text: l)).toList(),
          onTap: (i) {
            context.read<BookingProvider>().loadBookings(
                  status: _statuses[i],
                  refresh: true,
                );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.physiotherapistList),
        icon: const Icon(Icons.add),
        label: const Text('Booking Baru'),
        backgroundColor: const Color(AppColors.primary),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statuses.map((s) => _BookingTab(status: s)).toList(),
      ),
    );
  }
}

class _BookingTab extends StatelessWidget {
  final String? status;
  const _BookingTab({this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading && provider.bookings.isEmpty) {
          return const LoadingWidget(message: 'Memuat booking...');
        }
        if (provider.error != null && provider.bookings.isEmpty) {
          return ErrorStateWidget(
            message: provider.error!,
            onRetry: () =>
                provider.loadBookings(status: status, refresh: true),
          );
        }
        if (provider.bookings.isEmpty) {
          return const EmptyStateWidget(
            title: 'Belum ada booking',
            subtitle: 'Buat booking fisioterapi pertama Anda',
            icon: Icons.calendar_today_outlined,
          );
        }
        return RefreshIndicator(
          onRefresh: () => provider.loadBookings(status: status, refresh: true),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.bookings.length + (provider.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              if (i == provider.bookings.length) {
                provider.loadBookings(status: status);
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return BookingCard(booking: provider.bookings[i]);
            },
          ),
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.patientBookingDetail,
        arguments: booking.id,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.bookingCode,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(AppColors.textSecondary),
                  fontWeight: FontWeight.w500,
                ),
              ),
              BookingStatusBadge(status: booking.statusBooking),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.medical_services_outlined,
                  size: 16, color: Color(AppColors.primary)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  booking.service?.namaLayanan ?? 'Layanan',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 14, color: Color(AppColors.textSecondary)),
              const SizedBox(width: 6),
              Text(
                booking.physiotherapist?.user?.name ?? 'Menunggu penugasan',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: Color(AppColors.textSecondary)),
              const SizedBox(width: 6),
              Text(
                '${AppHelpers.formatDate(booking.bookingDate)}, '
                '${AppHelpers.formatTime(booking.startTime)} - '
                '${AppHelpers.formatTime(booking.endTime)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PaymentStatusBadge(status: booking.statusPembayaran),
              Text(
                AppHelpers.formatCurrency(booking.payment?.amount ?? 0),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
