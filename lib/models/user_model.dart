class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String userType; // 'pasien' or 'fisioterapis'
  final String status; // 'active', 'inactive'
  final DateTime registeredDate;
  final int sessionCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.userType,
    required this.status,
    required this.registeredDate,
    required this.sessionCount,
  });

  // Sample current user
  static UserModel currentUser = UserModel(
    id: '1',
    name: 'Budi Santoso',
    email: 'budi.santoso@email.com',
    phone: '+62812345678',
    photoUrl: null,
    userType: 'pasien',
    status: 'active',
    registeredDate: DateTime(2024, 1, 15),
    sessionCount: 24,
  );
}
