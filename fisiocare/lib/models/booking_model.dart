import 'user_model.dart';

// ===== SERVICE MODEL =====
class Service {
  final int id;
  final String kodeLayanan;
  final String namaLayanan;
  final String serviceMode;
  final String? deskripsi;
  final int durasiMenit;
  final double harga;
  final bool isActive;

  Service({
    required this.id,
    required this.kodeLayanan,
    required this.namaLayanan,
    required this.serviceMode,
    this.deskripsi,
    required this.durasiMenit,
    required this.harga,
    this.isActive = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        kodeLayanan: json['kode_layanan'],
        namaLayanan: json['nama_layanan'],
        serviceMode: json['service_mode'],
        deskripsi: json['deskripsi'],
        durasiMenit: json['durasi_menit'],
        harga: double.tryParse(json['harga'].toString()) ?? 0,
        isActive: (json['is_active'] ?? 1) == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode_layanan': kodeLayanan,
        'nama_layanan': namaLayanan,
        'service_mode': serviceMode,
        'deskripsi': deskripsi,
        'durasi_menit': durasiMenit,
        'harga': harga,
        'is_active': isActive ? 1 : 0,
      };

  bool get isHomeVisit => serviceMode == 'home_visit';
  bool get isTelekonsul => serviceMode == 'telekonsul';
}

// ===== SCHEDULE MODEL =====
class Schedule {
  final int id;
  final int physiotherapistId;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final int kuota;
  final String status;

  Schedule({
    required this.id,
    required this.physiotherapistId,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kuota,
    required this.status,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json['id'],
        physiotherapistId: json['physiotherapist_id'],
        hari: json['hari'],
        jamMulai: json['jam_mulai'],
        jamSelesai: json['jam_selesai'],
        kuota: json['kuota'],
        status: json['status'],
      );

  bool get isAvailable => status == 'available';
}

// ===== ADDRESS MODEL =====
class Address {
  final int id;
  final int patientId;
  final String? labelAlamat;
  final String? penerima;
  final String? phone;
  final String alamatLengkap;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  Address({
    required this.id,
    required this.patientId,
    this.labelAlamat,
    this.penerima,
    this.phone,
    required this.alamatLengkap,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'],
        patientId: json['patient_id'],
        labelAlamat: json['label_alamat'],
        penerima: json['penerima'],
        phone: json['phone'],
        alamatLengkap: json['alamat_lengkap'],
        latitude: json['latitude'] != null
            ? double.tryParse(json['latitude'].toString())
            : null,
        longitude: json['longitude'] != null
            ? double.tryParse(json['longitude'].toString())
            : null,
        isDefault: (json['is_default'] ?? 0) == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'label_alamat': labelAlamat,
        'penerima': penerima,
        'phone': phone,
        'alamat_lengkap': alamatLengkap,
        'latitude': latitude,
        'longitude': longitude,
        'is_default': isDefault ? 1 : 0,
      };
}

// ===== BOOKING MODEL =====
class Booking {
  final int id;
  final String bookingCode;
  final int patientId;
  final int? physiotherapistId;
  final int serviceId;
  final int? addressId;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String? keluhanAwal;
  final String? notes;
  final String statusBooking;
  final String statusPembayaran;
  final PatientProfile? patient;
  final PhysiotherapistProfile? physiotherapist;
  final Service? service;
  final Address? address;
  final Payment? payment;

  Booking({
    required this.id,
    required this.bookingCode,
    required this.patientId,
    this.physiotherapistId,
    required this.serviceId,
    this.addressId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    this.keluhanAwal,
    this.notes,
    required this.statusBooking,
    required this.statusPembayaran,
    this.patient,
    this.physiotherapist,
    this.service,
    this.address,
    this.payment,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        bookingCode: json['booking_code'],
        patientId: json['patient_id'],
        physiotherapistId: json['physiotherapist_id'],
        serviceId: json['service_id'],
        addressId: json['address_id'],
        bookingDate: json['booking_date'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        keluhanAwal: json['keluhan_awal'],
        notes: json['notes'],
        statusBooking: json['status_booking'],
        statusPembayaran: json['status_pembayaran'],
        patient: json['patient'] != null
            ? PatientProfile.fromJson(json['patient'])
            : null,
        physiotherapist: json['physiotherapist'] != null
            ? PhysiotherapistProfile.fromJson(json['physiotherapist'])
            : null,
        service:
            json['service'] != null ? Service.fromJson(json['service']) : null,
        address: json['address'] != null
            ? Address.fromJson(json['address'])
            : null,
        payment: json['payment'] != null
            ? Payment.fromJson(json['payment'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_code': bookingCode,
        'patient_id': patientId,
        'physiotherapist_id': physiotherapistId,
        'service_id': serviceId,
        'address_id': addressId,
        'booking_date': bookingDate,
        'start_time': startTime,
        'end_time': endTime,
        'keluhan_awal': keluhanAwal,
        'notes': notes,
        'status_booking': statusBooking,
        'status_pembayaran': statusPembayaran,
      };

  bool get isPending => statusBooking == 'pending';
  bool get isConfirmed => statusBooking == 'confirmed';
  bool get isPaid => statusBooking == 'paid';
  bool get isOnProcess => statusBooking == 'on_process';
  bool get isCompleted => statusBooking == 'completed';
  bool get isCancelled => statusBooking == 'cancelled';
}

// ===== PAYMENT MODEL =====
class Payment {
  final int id;
  final int bookingId;
  final String invoiceNumber;
  final String metodePembayaran;
  final double amount;
  final String? transactionRef;
  final String? paymentProof;
  final String status;
  final String? paidAt;
  final String? verifiedAt;

  Payment({
    required this.id,
    required this.bookingId,
    required this.invoiceNumber,
    required this.metodePembayaran,
    required this.amount,
    this.transactionRef,
    this.paymentProof,
    required this.status,
    this.paidAt,
    this.verifiedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        bookingId: json['booking_id'],
        invoiceNumber: json['invoice_number'],
        metodePembayaran: json['metode_pembayaran'],
        amount: double.tryParse(json['amount'].toString()) ?? 0,
        transactionRef: json['transaction_ref'],
        paymentProof: json['payment_proof'],
        status: json['status'],
        paidAt: json['paid_at'],
        verifiedAt: json['verified_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_id': bookingId,
        'invoice_number': invoiceNumber,
        'metode_pembayaran': metodePembayaran,
        'amount': amount,
        'status': status,
      };
}

// ===== NOTIFICATION MODEL =====
class AppNotification {
  final int id;
  final int userId;
  final int? bookingId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? sentAt;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    this.bookingId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.sentAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        userId: json['user_id'],
        bookingId: json['booking_id'],
        title: json['title'],
        message: json['message'],
        type: json['type'],
        isRead: (json['is_read'] ?? 0) == 1,
        sentAt: json['sent_at'],
        createdAt: json['created_at'],
      );
}

// ===== CHAT MESSAGE MODEL =====
class ChatMessage {
  final int id;
  final int bookingId;
  final int senderId;
  final String message;
  final String? fileAttachment;
  final String? readAt;
  final String createdAt;
  final User? sender;

  ChatMessage({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.message,
    this.fileAttachment,
    this.readAt,
    required this.createdAt,
    this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        bookingId: json['booking_id'],
        senderId: json['sender_id'],
        message: json['message'],
        fileAttachment: json['file_attachment'],
        readAt: json['read_at'],
        createdAt: json['created_at'],
        sender: json['sender'] != null ? User.fromJson(json['sender']) : null,
      );
}

// ===== THERAPY SESSION MODEL =====
class TherapySession {
  final int id;
  final int bookingId;
  final int sessionNumber;
  final String sessionDate;
  final String? startTime;
  final String? endTime;
  final String status;
  final String? patientCondition;
  final String? physiotherapistNotes;
  final bool needFollowUp;

  TherapySession({
    required this.id,
    required this.bookingId,
    required this.sessionNumber,
    required this.sessionDate,
    this.startTime,
    this.endTime,
    required this.status,
    this.patientCondition,
    this.physiotherapistNotes,
    this.needFollowUp = false,
  });

  factory TherapySession.fromJson(Map<String, dynamic> json) => TherapySession(
        id: json['id'],
        bookingId: json['booking_id'],
        sessionNumber: json['session_number'],
        sessionDate: json['session_date'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        status: json['status'],
        patientCondition: json['patient_condition'],
        physiotherapistNotes: json['physiotherapist_notes'],
        needFollowUp: (json['need_follow_up'] ?? 0) == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_id': bookingId,
        'session_number': sessionNumber,
        'session_date': sessionDate,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'patient_condition': patientCondition,
        'physiotherapist_notes': physiotherapistNotes,
        'need_follow_up': needFollowUp ? 1 : 0,
      };
}

// ===== MEDICAL RECORD MODEL =====
class MedicalRecord {
  final int id;
  final int patientId;
  final int bookingId;
  final int sessionId;
  final int physiotherapistId;
  final String? anamnesis;
  final String? pemeriksaanFisik;
  final String? diagnosisFisioterapi;
  final String? tujuanTerapi;
  final String? tindakan;
  final String? edukasi;
  final String? rekomendasi;
  final String? rencanaLanjut;
  final String createdAt;
  final PatientProfile? patient;
  final PhysiotherapistProfile? physiotherapist;
  final TherapySession? session;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.bookingId,
    required this.sessionId,
    required this.physiotherapistId,
    this.anamnesis,
    this.pemeriksaanFisik,
    this.diagnosisFisioterapi,
    this.tujuanTerapi,
    this.tindakan,
    this.edukasi,
    this.rekomendasi,
    this.rencanaLanjut,
    required this.createdAt,
    this.patient,
    this.physiotherapist,
    this.session,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        id: json['id'],
        patientId: json['patient_id'],
        bookingId: json['booking_id'],
        sessionId: json['session_id'],
        physiotherapistId: json['physiotherapist_id'],
        anamnesis: json['anamnesis'],
        pemeriksaanFisik: json['pemeriksaan_fisik'],
        diagnosisFisioterapi: json['diagnosis_fisioterapi'],
        tujuanTerapi: json['tujuan_terapi'],
        tindakan: json['tindakan'],
        edukasi: json['edukasi'],
        rekomendasi: json['rekomendasi'],
        rencanaLanjut: json['rencana_lanjut'],
        createdAt: json['created_at'],
        patient: json['patient'] != null
            ? PatientProfile.fromJson(json['patient'])
            : null,
        physiotherapist: json['physiotherapist'] != null
            ? PhysiotherapistProfile.fromJson(json['physiotherapist'])
            : null,
        session: json['session'] != null
            ? TherapySession.fromJson(json['session'])
            : null,
      );
}

// ===== REVIEW MODEL =====
class Review {
  final int id;
  final int bookingId;
  final int patientId;
  final int physiotherapistId;
  final int rating;
  final String? review;
  final String moderationStatus;
  final String createdAt;
  final User? patient;

  Review({
    required this.id,
    required this.bookingId,
    required this.patientId,
    required this.physiotherapistId,
    required this.rating,
    this.review,
    required this.moderationStatus,
    required this.createdAt,
    this.patient,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        bookingId: json['booking_id'],
        patientId: json['patient_id'],
        physiotherapistId: json['physiotherapist_id'],
        rating: json['rating'],
        review: json['review'],
        moderationStatus: json['moderation_status'],
        createdAt: json['created_at'],
        patient: json['patient'] != null ? User.fromJson(json['patient']) : null,
      );
}

// ===== API RESPONSE MODEL =====
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
      errors: json['errors'],
    );
  }
}
