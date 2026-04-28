class JadwalModel {
  final String id;
  final String title;
  final String therapistName;
  final String therapistSpecialty;
  final DateTime datetime;
  final int durationMinutes;
  final String location;
  final String status; // confirmed, pending, completed, cancelled
  final String? therapistImage;

  JadwalModel({
    required this.id,
    required this.title,
    required this.therapistName,
    required this.therapistSpecialty,
    required this.datetime,
    required this.durationMinutes,
    required this.location,
    required this.status,
    this.therapistImage,
  });

  // Sample data
  static List<JadwalModel> sampleJadwal = [
    JadwalModel(
      id: '1',
      title: 'Sesi Fisioterapi Lumbal',
      therapistName: 'Ftr. Siti Nurhaliza S.Tr.Kes',
      therapistSpecialty: 'Spesialis Fisioterapi Tulang Belakang',
      datetime: DateTime(2026, 3, 25, 10, 0),
      durationMinutes: 60,
      location: 'Home Visit',
      status: 'confirmed',
      therapistImage: 'assets/therapist1.png',
    ),
    JadwalModel(
      id: '2',
      title: 'Terapi Bahu Kanan',
      therapistName: 'Dr. Rizky Ahmad',
      therapistSpecialty: 'Spesialis Terapi Bahu',
      datetime: DateTime(2026, 3, 28, 14, 0),
      durationMinutes: 45,
      location: 'Klinik FisioCare',
      status: 'pending',
    ),
  ];
}
