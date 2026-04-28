import 'dart:io';
import 'api_service.dart';

class BookingService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getBookings({
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/bookings?page=$page';
    if (status != null) endpoint += '&status=$status';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> getBookingDetail(int id) async {
    return await _api.get('/bookings/$id');
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    return await _api.post('/bookings', data);
  }

  Future<Map<String, dynamic>> cancelBooking(int id, String reason) async {
    return await _api.post('/bookings/$id/cancel', {'alasan': reason});
  }

  Future<Map<String, dynamic>> confirmBooking(int id) async {
    return await _api.post('/bookings/$id/confirm', {});
  }

  Future<Map<String, dynamic>> getBookingsByPhysio({
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/physio/bookings?page=$page';
    if (status != null) endpoint += '&status=$status';
    return await _api.get(endpoint);
  }
}

class PaymentService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getPayments({int page = 1}) async {
    return await _api.get('/payments?page=$page');
  }

  Future<Map<String, dynamic>> getPaymentDetail(int id) async {
    return await _api.get('/payments/$id');
  }

  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> data) async {
    return await _api.post('/payments', data);
  }

  Future<Map<String, dynamic>> uploadPaymentProof(
    int paymentId,
    File proofFile,
  ) async {
    return await _api.uploadFile(
      '/payments/$paymentId/proof',
      proofFile,
      'payment_proof',
    );
  }

  Future<Map<String, dynamic>> verifyPayment(int paymentId) async {
    return await _api.post('/payments/$paymentId/verify', {});
  }

  Future<Map<String, dynamic>> rejectPayment(int paymentId, String reason) async {
    return await _api.post('/payments/$paymentId/reject', {'reason': reason});
  }
}

class NotificationService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getNotifications({int page = 1}) async {
    return await _api.get('/notifications?page=$page');
  }

  Future<Map<String, dynamic>> markAsRead(int id) async {
    return await _api.post('/notifications/$id/read', {});
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    return await _api.post('/notifications/read-all', {});
  }

  Future<Map<String, dynamic>> getUnreadCount() async {
    return await _api.get('/notifications/unread-count');
  }
}

class ChatService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getMessages(int bookingId, {int page = 1}) async {
    return await _api.get('/chats/$bookingId/messages?page=$page');
  }

  Future<Map<String, dynamic>> sendMessage(
    int bookingId,
    String message, {
    File? attachment,
  }) async {
    if (attachment != null) {
      return await _api.uploadFile(
        '/chats/$bookingId/messages',
        attachment,
        'file_attachment',
        additionalFields: {'message': message},
      );
    }
    return await _api.post('/chats/$bookingId/messages', {'message': message});
  }
}

class PhysiotherapistService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getPhysiotherapists({
    String? spesialisasi,
    String? serviceMode,
    int page = 1,
  }) async {
    String endpoint = '/physiotherapists?page=$page';
    if (spesialisasi != null) endpoint += '&spesialisasi=$spesialisasi';
    if (serviceMode != null) endpoint += '&service_mode=$serviceMode';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> getPhysiotherapistDetail(int id) async {
    return await _api.get('/physiotherapists/$id');
  }

  Future<Map<String, dynamic>> getSchedules(int physiotherapistId) async {
    return await _api.get('/physiotherapists/$physiotherapistId/schedules');
  }

  Future<Map<String, dynamic>> getReviews(int physiotherapistId, {int page = 1}) async {
    return await _api.get(
      '/physiotherapists/$physiotherapistId/reviews?page=$page',
    );
  }

  Future<Map<String, dynamic>> updateSchedule(Map<String, dynamic> data) async {
    return await _api.post('/physio/schedules', data);
  }

  Future<Map<String, dynamic>> deleteSchedule(int id) async {
    return await _api.delete('/physio/schedules/$id');
  }

  Future<Map<String, dynamic>> updateAvailability(bool isAvailable) async {
    return await _api.patch(
      '/physio/availability',
      {'is_available': isAvailable ? 1 : 0},
    );
  }
}

class MedicalRecordService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getMedicalRecords({int page = 1}) async {
    return await _api.get('/medical-records?page=$page');
  }

  Future<Map<String, dynamic>> getMedicalRecordDetail(int id) async {
    return await _api.get('/medical-records/$id');
  }

  Future<Map<String, dynamic>> createMedicalRecord(
    Map<String, dynamic> data,
  ) async {
    return await _api.post('/medical-records', data);
  }

  Future<Map<String, dynamic>> updateMedicalRecord(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _api.put('/medical-records/$id', data);
  }
}

class ReviewService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> createReview(Map<String, dynamic> data) async {
    return await _api.post('/reviews', data);
  }

  Future<Map<String, dynamic>> getReviews({
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/reviews?page=$page';
    if (status != null) endpoint += '&status=$status';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> moderateReview(
    int id,
    String status,
  ) async {
    return await _api.post('/reviews/$id/moderate', {'status': status});
  }
}

class AddressService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getAddresses() async {
    return await _api.get('/patient/addresses');
  }

  Future<Map<String, dynamic>> createAddress(Map<String, dynamic> data) async {
    return await _api.post('/patient/addresses', data);
  }

  Future<Map<String, dynamic>> updateAddress(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _api.put('/patient/addresses/$id', data);
  }

  Future<Map<String, dynamic>> deleteAddress(int id) async {
    return await _api.delete('/patient/addresses/$id');
  }

  Future<Map<String, dynamic>> setDefaultAddress(int id) async {
    return await _api.post('/patient/addresses/$id/default', {});
  }
}

class ServiceService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getServices({String? mode}) async {
    String endpoint = '/services';
    if (mode != null) endpoint += '?mode=$mode';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> createService(Map<String, dynamic> data) async {
    return await _api.post('/admin/services', data);
  }

  Future<Map<String, dynamic>> updateService(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _api.put('/admin/services/$id', data);
  }

  Future<Map<String, dynamic>> deleteService(int id) async {
    return await _api.delete('/admin/services/$id');
  }
}

class TherapySessionService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getSessions(int bookingId) async {
    return await _api.get('/bookings/$bookingId/sessions');
  }

  Future<Map<String, dynamic>> updateSessionStatus(
    int sessionId,
    String status,
  ) async {
    return await _api.patch('/sessions/$sessionId/status', {'status': status});
  }

  Future<Map<String, dynamic>> updateTracking(
    int sessionId,
    String trackingStatus, {
    double? latitude,
    double? longitude,
  }) async {
    return await _api.post('/sessions/$sessionId/tracking', {
      'tracking_status': trackingStatus,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }
}

class AdminService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getDashboard() async {
    return await _api.get('/admin/dashboard');
  }

  Future<Map<String, dynamic>> getUsers({
    String? role,
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/admin/users?page=$page';
    if (role != null) endpoint += '&role=$role';
    if (status != null) endpoint += '&status=$status';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> updateUserStatus(
    int userId,
    String status,
  ) async {
    return await _api.patch('/admin/users/$userId/status', {'status': status});
  }

  Future<Map<String, dynamic>> getAllBookings({
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/admin/bookings?page=$page';
    if (status != null) endpoint += '&status=$status';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> getAllPayments({
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/admin/payments?page=$page';
    if (status != null) endpoint += '&status=$status';
    return await _api.get(endpoint);
  }

  Future<Map<String, dynamic>> getReports({
    required String type,
    required String startDate,
    required String endDate,
  }) async {
    return await _api.get(
      '/admin/reports?type=$type&start=$startDate&end=$endDate',
    );
  }
}
