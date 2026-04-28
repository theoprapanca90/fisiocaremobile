class PromoModel {
  final String id;
  final String title;
  final String description;
  final String discountPercentage;
  final String code;
  final String validUntil;
  final String imageUrl;

  PromoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.code,
    required this.validUntil,
    required this.imageUrl,
  });

  // Sample data
  static List<PromoModel> samplePromos = [
    PromoModel(
      id: '1',
      title: 'Diskon Sesi Pertama',
      description: 'Dapatkan diskon hingga 20% untuk sesi fisioterapi pertama Anda',
      discountPercentage: '20%',
      code: 'FISIO2026',
      validUntil: '31 Mar 2026',
      imageUrl: 'assets/promo1.png',
    ),
    PromoModel(
      id: '2',
      title: 'Paket Hemat 5 Sesi',
      description: 'Hemat lebih banyak dengan paket 5 sesi berturut-turut',
      discountPercentage: '15%',
      code: 'HEMAT5',
      validUntil: '30 Apr 2026',
      imageUrl: 'assets/promo2.png',
    ),
  ];
}
