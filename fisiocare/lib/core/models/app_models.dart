class UserModel {
  final int id;
  final int roleId;
  final String name;
  final String username;
  final String? email;
  final String? phone;
  final String? profilePhoto;
  final String statusAkun;

  UserModel({
    required this.id,
    required this.roleId,
    required this.name,
    required this.username,
    this.email,
    this.phone,
    this.profilePhoto,
    required this.statusAkun,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] ?? 0,
        roleId: map['role_id'] ?? 0,
        name: map['name'] ?? '',
        username: map['username'] ?? '',
        email: map['email'],
        phone: map['phone'],
        profilePhoto: map['profile_photo'],
        statusAkun: map['status_akun'] ?? '',
      );

  bool get isPatient => roleId == 2;
  bool get isTherapist => roleId == 3;
  bool get isAdmin => roleId == 1;
}

class PatientProfileModel {
  final int id;
  final int userId;
  final String noRm;
  final String? nik;
  final String jenisKelamin;
  final String? tanggalLahir;
  final String? tempatLahir;
  final String? golDarah;
  final String? alergi;
  final String? riwayatPenyakit;
  final String? kontakDaruratNama;
  final String? kontakDaruratPhone;
  final String? alamat; // ✅ FIX TAMBAHAN

  PatientProfileModel({
    required this.id,
    required this.userId,
    required this.noRm,
    this.nik,
    required this.jenisKelamin,
    this.tanggalLahir,
    this.tempatLahir,
    this.golDarah,
    this.alergi,
    this.riwayatPenyakit,
    this.kontakDaruratNama,
    this.kontakDaruratPhone,
    this.alamat, // ✅ FIX
  });

  factory PatientProfileModel.fromMap(Map<String, dynamic> map) =>
      PatientProfileModel(
        id: map['id'] ?? 0,
        userId: map['user_id'] ?? 0,
        noRm: map['no_rm'] ?? '',
        nik: map['nik'],
        jenisKelamin: map['jenis_kelamin'] ?? '',
        tanggalLahir: map['tanggal_lahir'],
        tempatLahir: map['tempat_lahir'],
        golDarah: map['gol_darah'],
        alergi: map['alergi'],
        riwayatPenyakit: map['riwayat_penyakit'],
        kontakDaruratNama: map['kontak_darurat_nama'],
        kontakDaruratPhone: map['kontak_darurat_phone'],
        alamat: map['alamat'], // ✅ FIX
      );
}

class TherapistProfileModel {
  final int id;
  final int userId;
  final String? noStr;
  final String? spesialisasi;
  final int pengalamanTahun;
  final double tarifDefault;
  final String? bio;
  final bool isAvailable;
  final double ratingAvg;
  final int totalReviews;

  TherapistProfileModel({
    required this.id,
    required this.userId,
    this.noStr,
    this.spesialisasi,
    required this.pengalamanTahun,
    required this.tarifDefault,
    this.bio,
    required this.isAvailable,
    required this.ratingAvg,
    required this.totalReviews,
  });

  factory TherapistProfileModel.fromMap(Map<String, dynamic> map) =>
      TherapistProfileModel(
        id: map['id'] ?? 0,
        userId: map['user_id'] ?? 0,
        noStr: map['no_str'],
        spesialisasi: map['spesialisasi'],
        pengalamanTahun: map['pengalaman_tahun'] ?? 0,
        tarifDefault:
            double.tryParse(map['tarif_default'].toString()) ?? 0,
        bio: map['bio'],
        isAvailable: map['is_available'] ?? true,
        ratingAvg:
            double.tryParse(map['rating_avg'].toString()) ?? 0,
        totalReviews: map['total_reviews'] ?? 0,
      );
}

class BookingModel {
  final int id;
  final String bookingCode;
  final int patientId;
  final int? physiotherapistId;
  final int serviceId;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String? keluhanAwal;
  final String statusBooking;
  final String statusPembayaran;

  BookingModel({
    required this.id,
    required this.bookingCode,
    required this.patientId,
    this.physiotherapistId,
    required this.serviceId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    this.keluhanAwal,
    required this.statusBooking,
    required this.statusPembayaran,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) =>
      BookingModel(
        id: map['id'] ?? 0,
        bookingCode: map['booking_code'] ?? '',
        patientId: map['patient_id'] ?? 0,
        physiotherapistId: map['physiotherapist_id'],
        serviceId: map['service_id'] ?? 0,
        bookingDate: map['booking_date'] ?? '',
        startTime: map['start_time'] ?? '',
        endTime: map['end_time'] ?? '',
        keluhanAwal: map['keluhan_awal'],
        statusBooking: map['status_booking'] ?? '',
        statusPembayaran: map['status_pembayaran'] ?? '',
      );
}