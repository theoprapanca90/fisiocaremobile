// ===== ROLE MODEL =====
class Role {
  final int id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// ===== USER MODEL =====
class User {
  final int id;
  final int roleId;
  final String name;
  final String username;
  final String? email;
  final String? phone;
  final String? profilePhoto;
  final String statusAkun;
  final String? emailVerifiedAt;
  final String? lastLoginAt;
  final Role? role;
  final PatientProfile? patientProfile;
  final PhysiotherapistProfile? physiotherapistProfile;
  final AdminProfile? adminProfile;

  User({
    required this.id,
    required this.roleId,
    required this.name,
    required this.username,
    this.email,
    this.phone,
    this.profilePhoto,
    required this.statusAkun,
    this.emailVerifiedAt,
    this.lastLoginAt,
    this.role,
    this.patientProfile,
    this.physiotherapistProfile,
    this.adminProfile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        roleId: json['role_id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        profilePhoto: json['profile_photo'],
        statusAkun: json['status_akun'] ?? 'pending',
        emailVerifiedAt: json['email_verified_at'],
        lastLoginAt: json['last_login_at'],
        role: json['role'] != null ? Role.fromJson(json['role']) : null,
        patientProfile: json['patient_profile'] != null
            ? PatientProfile.fromJson(json['patient_profile'])
            : null,
        physiotherapistProfile: json['physiotherapist_profile'] != null
            ? PhysiotherapistProfile.fromJson(json['physiotherapist_profile'])
            : null,
        adminProfile: json['admin_profile'] != null
            ? AdminProfile.fromJson(json['admin_profile'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role_id': roleId,
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'profile_photo': profilePhoto,
        'status_akun': statusAkun,
      };

  bool get isPatient => role?.name == 'pasien';
  bool get isPhysiotherapist => role?.name == 'fisioterapis';
  bool get isAdmin => role?.name == 'admin';
}

// ===== PATIENT PROFILE MODEL =====
class PatientProfile {
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

  PatientProfile({
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
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) => PatientProfile(
        id: json['id'],
        userId: json['user_id'],
        noRm: json['no_rm'],
        nik: json['nik'],
        jenisKelamin: json['jenis_kelamin'],
        tanggalLahir: json['tanggal_lahir'],
        tempatLahir: json['tempat_lahir'],
        golDarah: json['gol_darah'],
        alergi: json['alergi'],
        riwayatPenyakit: json['riwayat_penyakit'],
        kontakDaruratNama: json['kontak_darurat_nama'],
        kontakDaruratPhone: json['kontak_darurat_phone'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'no_rm': noRm,
        'nik': nik,
        'jenis_kelamin': jenisKelamin,
        'tanggal_lahir': tanggalLahir,
        'tempat_lahir': tempatLahir,
        'gol_darah': golDarah,
        'alergi': alergi,
        'riwayat_penyakit': riwayatPenyakit,
        'kontak_darurat_nama': kontakDaruratNama,
        'kontak_darurat_phone': kontakDaruratPhone,
      };
}

// ===== PHYSIOTHERAPIST PROFILE MODEL =====
class PhysiotherapistProfile {
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
  final User? user;

  PhysiotherapistProfile({
    required this.id,
    required this.userId,
    this.noStr,
    this.spesialisasi,
    this.pengalamanTahun = 0,
    this.tarifDefault = 0,
    this.bio,
    this.isAvailable = true,
    this.ratingAvg = 0,
    this.totalReviews = 0,
    this.user,
  });

  factory PhysiotherapistProfile.fromJson(Map<String, dynamic> json) =>
      PhysiotherapistProfile(
        id: json['id'],
        userId: json['user_id'],
        noStr: json['no_str'],
        spesialisasi: json['spesialisasi'],
        pengalamanTahun: json['pengalaman_tahun'] ?? 0,
        tarifDefault: double.tryParse(json['tarif_default'].toString()) ?? 0,
        bio: json['bio'],
        isAvailable: (json['is_available'] ?? 1) == 1,
        ratingAvg: double.tryParse(json['rating_avg'].toString()) ?? 0,
        totalReviews: json['total_reviews'] ?? 0,
        user: json['user'] != null ? User.fromJson(json['user']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'no_str': noStr,
        'spesialisasi': spesialisasi,
        'pengalaman_tahun': pengalamanTahun,
        'tarif_default': tarifDefault,
        'bio': bio,
        'is_available': isAvailable ? 1 : 0,
        'rating_avg': ratingAvg,
        'total_reviews': totalReviews,
      };
}

// ===== ADMIN PROFILE MODEL =====
class AdminProfile {
  final int id;
  final int userId;
  final String? jabatan;

  AdminProfile({required this.id, required this.userId, this.jabatan});

  factory AdminProfile.fromJson(Map<String, dynamic> json) => AdminProfile(
        id: json['id'],
        userId: json['user_id'],
        jabatan: json['jabatan'],
      );
}
