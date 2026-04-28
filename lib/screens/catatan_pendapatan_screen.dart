import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class CatatanPendapatanScreen extends StatefulWidget {
  const CatatanPendapatanScreen({super.key});

  @override
  State<CatatanPendapatanScreen> createState() => _CatatanPendapatanScreenState();
}

class _CatatanPendapatanScreenState extends State<CatatanPendapatanScreen> {
  String _selectedPeriod = 'bulan_ini';

  final List<Map<String, dynamic>> _pendapatanDetails = [
    {
      'pasien': 'Budi Santoso',
      'jenis': 'Fisioterapi Lumbal - 60 menit',
      'tanggal': '25 Mar 2026',
      'waktu': '10:00 - 11:00',
      'nominal': 'Rp 150.000',
      'status': 'Dibayar',
      'statusColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'metode': 'Transfer Bank',
      'invoice': '#INV-2026-001',
      'notes': 'Sesi berjalan dengan baik, pasien menunjukkan perkembangan',
    },
    {
      'pasien': 'Ahmad Rizki',
      'jenis': 'Terapi Bahu - 45 menit',
      'tanggal': '24 Mar 2026',
      'waktu': '14:00 - 14:45',
      'nominal': 'Rp 130.000',
      'status': 'Pending',
      'statusColor': Color(0xFFFEF3C7),
      'statusTextColor': Color(0xFF92400E),
      'metode': 'Menunggu konfirmasi',
      'invoice': '#INV-2026-002',
      'notes': 'Pembayaran menunggu konfirmasi dari pasien',
    },
    {
      'pasien': 'Siti Nurhaliza',
      'jenis': 'Fisioterapi Lutut - 60 menit',
      'tanggal': '23 Mar 2026',
      'waktu': '09:00 - 10:00',
      'nominal': 'Rp 160.000',
      'status': 'Dibayar',
      'statusColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'metode': 'E-Wallet (GCash)',
      'invoice': '#INV-2026-003',
      'notes': 'Pembayaran tiba tepat waktu',
    },
    {
      'pasien': 'Dewi Santoso',
      'jenis': 'Terapi Fisik Umum - 30 menit',
      'tanggal': '22 Mar 2026',
      'waktu': '15:30 - 16:00',
      'nominal': 'Rp 80.000',
      'status': 'Dibayar',
      'statusColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'metode': 'Transfer Bank',
      'invoice': '#INV-2026-004',
      'notes': 'Klien membayar tunai di tempat',
    },
    {
      'pasien': 'Rizki Ahmad',
      'jenis': 'Konsultasi Fisioterapi - 30 menit',
      'tanggal': '21 Mar 2026',
      'waktu': '13:00 - 13:30',
      'nominal': 'Rp 60.000',
      'status': 'Pending',
      'statusColor': Color(0xFFFEF3C7),
      'statusTextColor': Color(0xFF92400E),
      'metode': 'Menunggu konfirmasi',
      'invoice': '#INV-2026-005',
      'notes': 'Pembayaran sedang diproses',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Catatan Pendapatan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Summary Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Total Pendapatan
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00BBA7), Color(0xFF009689)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF009B89).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pendapatan Bulan Ini',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp 3.450.000',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sesi Selesai',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  '12',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rata-rata Rating',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '4.9',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.star, color: Color(0xFFFFD166), size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Status Summary
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          label: 'Dibayar',
                          value: 'Rp 2.890.000',
                          icon: Icons.check_circle,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusCard(
                          label: 'Pending',
                          value: 'Rp 560.000',
                          icon: Icons.hourglass_empty,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Period Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Periode',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightText),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPeriodButton('Bulan Ini', 'bulan_ini'),
                      const SizedBox(width: 8),
                      _buildPeriodButton('3 Bulan', '3bulan'),
                      const SizedBox(width: 8),
                      _buildPeriodButton('1 Tahun', '1tahun'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Transaction List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Transaksi',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._pendapatanDetails.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTransactionCard(item, context),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.lightText),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderColor,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _buildTransactionDetail(item),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(child: Icon(Icons.person, color: AppColors.primary, size: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['pasien'],
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['jenis'],
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['tanggal'],
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.lightText),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['nominal'],
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryText),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item['statusColor'],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['status'],
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: item['statusTextColor'],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetail(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail Transaksi',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryText),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Invoice', item['invoice']),
            _buildDetailRow('Pasien', item['pasien']),
            _buildDetailRow('Layanan', item['jenis']),
            _buildDetailRow('Tanggal', item['tanggal']),
            _buildDetailRow('Waktu', item['waktu']),
            _buildDetailRow('Nominal', item['nominal']),
            _buildDetailRow('Metode Pembayaran', item['metode']),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.borderColor),
            ),
            _buildDetailRow('Status', item['status'],
                statusColor: item['statusColor'], statusTextColor: item['statusTextColor']),
            const SizedBox(height: 16),
            Text(
              'Catatan',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightText),
            ),
            const SizedBox(height: 8),
            Text(
              item['notes'],
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.secondaryText, height: 1.5),
            ),
            const SizedBox(height: 20),
            if (item['status'] == 'Pending')
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Pengingat pembayaran terkirim', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  child: Text('Kirim Pengingat Pembayaran', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? statusColor,
    Color? statusTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightText),
          ),
          if (statusColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(6)),
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: statusTextColor,
                ),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryText),
            ),
        ],
      ),
    );
  }
}
