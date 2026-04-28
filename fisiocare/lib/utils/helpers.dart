import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';

class AppHelpers {
  // Format currency IDR
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(String? dateStr, {String format = 'dd MMM yyyy'}) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat(format, 'id_ID').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  // Format time
  static String formatTime(String? timeStr) {
    if (timeStr == null) return '-';
    try {
      final parts = timeStr.split(':');
      return '${parts[0]}:${parts[1]}';
    } catch (_) {
      return timeStr;
    }
  }

  // Format datetime
  static String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '-';
    try {
      final dt = DateTime.parse(dateTimeStr);
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (_) {
      return dateTimeStr;
    }
  }

  // Get status color
  static Color getStatusBookingColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(AppColors.warning);
      case 'confirmed':
        return const Color(AppColors.primary);
      case 'paid':
        return Colors.indigo;
      case 'on_process':
        return Colors.orange;
      case 'completed':
        return const Color(AppColors.success);
      case 'cancelled':
        return const Color(AppColors.error);
      default:
        return const Color(AppColors.textSecondary);
    }
  }

  static String getStatusBookingLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'paid':
        return 'Sudah Bayar';
      case 'on_process':
        return 'Sedang Proses';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  static Color getStatusPaymentColor(String status) {
    switch (status) {
      case 'unpaid':
        return const Color(AppColors.error);
      case 'waiting_verification':
        return const Color(AppColors.warning);
      case 'paid':
        return const Color(AppColors.success);
      case 'failed':
        return const Color(AppColors.error);
      case 'refunded':
        return Colors.purple;
      default:
        return const Color(AppColors.textSecondary);
    }
  }

  static String getStatusPaymentLabel(String status) {
    switch (status) {
      case 'unpaid':
        return 'Belum Bayar';
      case 'waiting_verification':
        return 'Menunggu Verifikasi';
      case 'paid':
        return 'Lunas';
      case 'failed':
        return 'Gagal';
      case 'refunded':
        return 'Dikembalikan';
      default:
        return status;
    }
  }

  static String getServiceModeLabel(String mode) {
    switch (mode) {
      case 'home_visit':
        return 'Kunjungan Rumah';
      case 'telekonsul':
        return 'Telekonsultasi';
      default:
        return mode;
    }
  }

  static String getHariLabel(String hari) {
    switch (hari) {
      case 'senin':
        return 'Senin';
      case 'selasa':
        return 'Selasa';
      case 'rabu':
        return 'Rabu';
      case 'kamis':
        return 'Kamis';
      case 'jumat':
        return 'Jumat';
      case 'sabtu':
        return 'Sabtu';
      case 'minggu':
        return 'Minggu';
      default:
        return hari;
    }
  }

  // Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: isError
            ? const Color(AppColors.error)
            : const Color(AppColors.success),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Show loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Show confirmation dialog
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger
                  ? const Color(AppColors.error)
                  : const Color(AppColors.primary),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
