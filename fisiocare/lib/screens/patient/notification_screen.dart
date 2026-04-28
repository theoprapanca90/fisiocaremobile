import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _service = NotificationService();
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final r = await _service.getNotifications();
      if (r['success'] == true) {
        final data = r['data']['data'] as List;
        setState(() {
          _notifications =
              data.map((e) => AppNotification.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = r['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    try {
      await _service.markAllAsRead();
      setState(() {
        _notifications = _notifications
            .map((n) => AppNotification(
                  id: n.id,
                  userId: n.userId,
                  bookingId: n.bookingId,
                  title: n.title,
                  message: n.message,
                  type: n.type,
                  isRead: true,
                  sentAt: n.sentAt,
                  createdAt: n.createdAt,
                ))
            .toList();
      });
    } catch (_) {}
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_month;
      case 'payment':
        return Icons.payment;
      case 'session':
        return Icons.medical_services;
      case 'reminder':
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'booking':
        return const Color(AppColors.primary);
      case 'payment':
        return const Color(AppColors.success);
      case 'session':
        return const Color(AppColors.accent);
      case 'reminder':
        return const Color(AppColors.warning);
      default:
        return const Color(AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text(
              'Tandai Semua Dibaca',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat notifikasi...')
          : _error != null
              ? ErrorStateWidget(message: _error!, onRetry: _load)
              : _notifications.isEmpty
                  ? const EmptyStateWidget(
                      title: 'Belum ada notifikasi',
                      subtitle: 'Notifikasi Anda akan muncul di sini',
                      icon: Icons.notifications_none,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        itemCount: _notifications.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final n = _notifications[i];
                          return ListTile(
                            tileColor: n.isRead
                                ? null
                                : const Color(AppColors.primary)
                                    .withOpacity(0.04),
                            leading: CircleAvatar(
                              backgroundColor:
                                  _getTypeColor(n.type).withOpacity(0.15),
                              child: Icon(
                                _getTypeIcon(n.type),
                                color: _getTypeColor(n.type),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              n.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: n.isRead
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: const Color(AppColors.textPrimary),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  n.message,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(AppColors.textSecondary),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppHelpers.formatDateTime(n.createdAt),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                            trailing: !n.isRead
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(AppColors.primary),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                            onTap: () async {
                              await _service.markAsRead(n.id);
                              if (n.bookingId != null) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.patientBookingDetail,
                                  arguments: n.bookingId,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
