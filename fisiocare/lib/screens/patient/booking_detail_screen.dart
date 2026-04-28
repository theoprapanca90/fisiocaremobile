import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/booking_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  int? _bookingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bookingId = ModalRoute.of(context)?.settings.arguments as int?;
    if (_bookingId != null) {
      context.read<BookingProvider>().loadBookingDetail(_bookingId!);
    }
  }

  Future<void> _cancelBooking() async {
    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Apakah Anda yakin ingin membatalkan booking ini?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(
                labelText: 'Alasan pembatalan',
                hintText: 'Masukkan alasan...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Tidak')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppColors.error)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context
          .read<BookingProvider>()
          .cancelBooking(_bookingId!, reasonCtrl.text);
      if (mounted) {
        AppHelpers.showSnackBar(
          context,
          success ? 'Booking berhasil dibatalkan' : 'Gagal membatalkan booking',
          isError: !success,
        );
        if (success) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Booking')),
      body: Consumer<BookingProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Memuat detail...');
          }
          if (provider.error != null) {
            return ErrorStateWidget(
              message: provider.error!,
              onRetry: () => provider.loadBookingDetail(_bookingId!),
            );
          }
          final booking = provider.selectedBooking;
          if (booking == null) return const SizedBox();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                AppCard(
                  color: AppHelpers.getStatusBookingColor(booking.statusBooking)
                      .withOpacity(0.08),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Status Booking',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(AppColors.textSecondary))),
                            const SizedBox(height: 4),
                            BookingStatusBadge(status: booking.statusBooking),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Kode',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(AppColors.textSecondary))),
                          const SizedBox(height: 4),
                          Text(
                            booking.bookingCode,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Layanan
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Informasi Layanan'),
                      const SizedBox(height: 12),
                      InfoRow(
                        label: 'Layanan',
                        value: booking.service?.namaLayanan ?? '-',
                      ),
                      InfoRow(
                        label: 'Mode',
                        value: AppHelpers.getServiceModeLabel(
                            booking.service?.serviceMode ?? '-'),
                      ),
                      InfoRow(
                        label: 'Durasi',
                        value: '${booking.service?.durasiMenit ?? 0} menit',
                      ),
                      InfoRow(
                        label: 'Tanggal',
                        value: AppHelpers.formatDate(booking.bookingDate),
                      ),
                      InfoRow(
                        label: 'Waktu',
                        value:
                            '${AppHelpers.formatTime(booking.startTime)} - ${AppHelpers.formatTime(booking.endTime)}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fisioterapis
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Fisioterapis'),
                      const SizedBox(height: 12),
                      InfoRow(
                        label: 'Nama',
                        value: booking.physiotherapist?.user?.name ??
                            'Belum ditugaskan',
                      ),
                      InfoRow(
                        label: 'Spesialisasi',
                        value: booking.physiotherapist?.spesialisasi ?? '-',
                      ),
                      InfoRow(
                        label: 'No. STR',
                        value: booking.physiotherapist?.noStr ?? '-',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Alamat (jika home visit)
                if (booking.address != null) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Alamat'),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: 'Label',
                          value: booking.address?.labelAlamat ?? '-',
                        ),
                        InfoRow(
                          label: 'Penerima',
                          value: booking.address?.penerima ?? '-',
                        ),
                        InfoRow(
                          label: 'Alamat',
                          value: booking.address?.alamatLengkap ?? '-',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Keluhan
                if (booking.keluhanAwal != null) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Keluhan Awal'),
                        const SizedBox(height: 8),
                        Text(
                          booking.keluhanAwal!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Pembayaran
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Pembayaran'),
                      const SizedBox(height: 12),
                      InfoRow(
                        label: 'Status',
                        trailing: PaymentStatusBadge(
                            status: booking.statusPembayaran),
                        value: '',
                      ),
                      InfoRow(
                        label: 'Invoice',
                        value: booking.payment?.invoiceNumber ?? '-',
                      ),
                      InfoRow(
                        label: 'Metode',
                        value: booking.payment?.metodePembayaran ?? '-',
                      ),
                      InfoRow(
                        label: 'Total',
                        value: AppHelpers.formatCurrency(
                            booking.payment?.amount ?? 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                if (booking.isPending || booking.isConfirmed) ...[
                  if (booking.statusPembayaran == 'unpaid')
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.patientBooking,
                        arguments: booking.payment?.id,
                      ),
                      icon: const Icon(Icons.payment),
                      label: const Text('Bayar Sekarang'),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(AppColors.error),
                      side: const BorderSide(color: Color(AppColors.error)),
                    ),
                    onPressed: _cancelBooking,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Batalkan Booking'),
                  ),
                ],

                if (booking.isCompleted &&
                    booking.statusPembayaran == 'paid') ...[
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.patientReview,
                      arguments: booking.id,
                    ),
                    icon: const Icon(Icons.star_outline),
                    label: const Text('Beri Ulasan'),
                  ),
                ],

                // Chat button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(AppColors.secondary),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.patientChat,
                    arguments: booking.id,
                  ),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Chat Fisioterapis'),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
