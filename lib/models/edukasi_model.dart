class EdukasiModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String content;
  final String author;
  final DateTime publishDate;
  final int viewCount;

  EdukasiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.content,
    required this.author,
    required this.publishDate,
    required this.viewCount,
  });

  // Sample data
  static List<EdukasiModel> sampleEdukasi = [
    EdukasiModel(
      id: '1',
      title: 'Pencegahan Cedera Punggung',
      description: 'Pelajari cara mencegah cedera punggung dengan teknik duduk dan berdiri yang benar',
      category: 'Pencegahan',
      imageUrl: 'assets/edukasi1.png',
      content: 'Cedera punggung adalah salah satu masalah kesehatan yang paling umum...',
      author: 'Dr. Siti Nurhaliza',
      publishDate: DateTime(2026, 3, 20),
      viewCount: 245,
    ),
    EdukasiModel(
      id: '2',
      title: 'Latihan Terapi Bahu',
      description: 'Serangkaian latihan yang aman dan efektif untuk memperkuat otot bahu',
      category: 'Latihan',
      imageUrl: 'assets/edukasi2.png',
      content: 'Masalah bahu sering dialami oleh banyak orang terutama yang bekerja...',
      author: 'Dr. Rizky Ahmad',
      publishDate: DateTime(2026, 3, 18),
      viewCount: 189,
    ),
    EdukasiModel(
      id: '3',
      title: 'Pemulihan Pasca Operasi',
      description: 'Panduan lengkap pemulihan dan rehabilitasi setelah operasi',
      category: 'Pemulihan',
      imageUrl: 'assets/edukasi3.png',
      content: 'Pemulihan pasca operasi memerlukan perhatian khusus dan latihan yang terstruktur...',
      author: 'Dr. Budi Santoso',
      publishDate: DateTime(2026, 3, 15),
      viewCount: 312,
    ),
  ];
}
