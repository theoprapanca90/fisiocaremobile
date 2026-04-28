import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _notifEnabled = true;
  bool _darkMode = false;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildStatsRow()),
          SliverToBoxAdapter(child: _buildDataDiri()),
          SliverToBoxAdapter(child: _buildDataMedis()),
          SliverToBoxAdapter(child: _buildPengaturan()),
          SliverToBoxAdapter(child: _buildLogout(context)),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.5, -1.0),
          end: Alignment(0.5, 1.0),
          colors: [Color(0xFF00BBA7), Color(0xFF009689)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(right: -50, top: -70,
              child: Container(width: 200, height: 200,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), shape: BoxShape.circle))),
            Positioned(left: -20, bottom: 0,
              child: Container(width: 110, height: 110,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  // Top bar: back + title + edit
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      ),
                      const Spacer(),
                      Text('Profil Saya', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit_outlined, color: Colors.white, size: 12),
                            const SizedBox(width: 5),
                            Text('Edit', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Avatar + info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 76, height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.22),
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                            ),
                            child: const Center(child: Text('🧑‍💼', style: TextStyle(fontSize: 38))),
                          ),
                          Positioned(
                            right: -4, bottom: -4,
                            child: Container(
                              width: 22, height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD166),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Center(child: Text('📷', style: TextStyle(fontSize: 11))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Budi Santoso',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.22)),
                            ),
                            child: Text('🆔 FSC-2024-0047  ·  Pasien Aktif',
                                style: GoogleFonts.inter(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 16, 17, 0),
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: const Color(0xFF009B89).withOpacity(0.16), blurRadius: 28, offset: const Offset(0, 8))],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _statItem('24', 'Total Sesi', const Color(0xFF0F2B28)),
            _divider(),
            _statItem('8', 'Bulan Aktif', const Color(0xFF0F2B28)),
            _divider(),
            _statItem('4.9', 'Rating Rata²', const Color(0xFF0F2B28)),
            _divider(),
            _statItem('2', 'Terapis Favorit', const Color(0xFF00BBA7)),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, Color valueColor) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: GoogleFonts.inter(color: valueColor, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: const Color(0xFF6EA8A2), fontSize: 9.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: const Color(0xFFC8ECEA));

  Widget _buildDataDiri() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Data Diri', style: GoogleFonts.inter(color: const Color(0xFF0F2B28), fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 8),
          _buildCard(
            emoji: '👤', title: 'Informasi Pribadi',
            rows: [
              _row('Nama Lengkap', 'Budi Santoso', true),
              _row('Tanggal Lahir', '14 Agustus 1985', true),
              _row('Jenis Kelamin', 'Laki-laki', true),
              _row('Nomor HP', '+62 812-3456-7890', true),
              _row('Email', 'budi.santoso@email.com', true),
              _row('Alamat', 'Jl. Merdeka No. 12, Tasikmalaya', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataMedis() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: _buildCard(
        emoji: '🏥', title: 'Data Medis',
        rows: [
          _row('Berat Badan', '72 kg', true),
          _row('Tinggi Badan', '170 cm', true),
          _row('Golongan Darah', 'O+', true),
          _row('Alergi', 'Tidak ada', true),
        ],
        extra: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 100,
                child: Text('Kondisi Aktif', style: GoogleFonts.inter(color: const Color(0xFF6EA8A2), fontSize: 10.5, fontWeight: FontWeight.w600))),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 6, runSpacing: 6,
                  children: [
                    _tag('🦴 Nyeri Lumbal', true),
                    _tag('💪 Cedera Bahu', true),
                    _tag('🧘 Postur', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String emoji, required String title, required List<Widget> rows, Widget? extra}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFF009B89).withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)]),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 7),
                Text(title, style: GoogleFonts.inter(color: const Color(0xFF0F2B28), fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          ...rows,
          if (extra != null) extra,
        ],
      ),
    );
  }

  Widget _row(String label, String value, bool border) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 9),
      decoration: BoxDecoration(
        border: border ? const Border(bottom: BorderSide(color: Color(0xFFC8ECEA))) : null,
      ),
      child: Row(
        children: [
          SizedBox(width: 100,
            child: Text(label, style: GoogleFonts.inter(color: const Color(0xFF6EA8A2), fontSize: 10.5, fontWeight: FontWeight.w600))),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: GoogleFonts.inter(color: const Color(0xFF0F2B28), fontSize: 12, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Widget _tag(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: active ? const LinearGradient(colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)]) : null,
        color: active ? null : const Color(0xFFF2FAF9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF00BBA7)),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              color: active ? const Color(0xFF009689) : const Color(0xFF2D5550),
              fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildPengaturan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          _settingsGroup('AKUN & KEAMANAN', [
            _tile('🔒', 'Ubah Password', 'Terakhir diubah 3 bulan lalu', _chevron(), false),
            _tile('📱', 'Verifikasi 2 Langkah', 'Aktifkan untuk keamanan lebih',
                _toggle(_twoFactor, (v) => setState(() => _twoFactor = v), false), false),
            _tile('💳', 'Metode Pembayaran', 'GoPay · BCA Virtual Account', _chevron(), true),
          ]),
          const SizedBox(height: 8),
          _settingsGroup('NOTIFIKASI & PREFERENSI', [
            _tile('🔔', 'Notifikasi Pengingat', 'Sesi & latihan harian',
                _toggle(_notifEnabled, (v) => setState(() => _notifEnabled = v), true), false),
            _tile('🌙', 'Mode Gelap', 'Tampilan lebih nyaman malam hari',
                _toggle(_darkMode, (v) => setState(() => _darkMode = v), false), false),
            _tile('🌐', 'Bahasa', 'Bahasa Indonesia', _chevron(), true),
          ]),
          const SizedBox(height: 8),
          _settingsGroup('TENTANG & DUKUNGAN', [
            _tile('💬', 'Hubungi Kami', 'Chat / WhatsApp / Telepon',
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFF5A5A), borderRadius: BorderRadius.circular(6)),
                    child: Text('Baru', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800))),
                  const SizedBox(width: 6),
                  _chevron(),
                ]), false),
            _tile('❓', 'Pusat Bantuan', 'FAQ & panduan pengguna', _chevron(), false),
            _tile('ℹ️', 'Tentang FisioCare', 'Versi 2.4.1 · Kebijakan Privasi', _chevron(), true),
          ]),
        ],
      ),
    );
  }

  Widget _settingsGroup(String label, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(label, style: GoogleFonts.inter(color: const Color(0xFF6EA8A2), fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.7)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: const Color(0xFF009B89).withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 2))],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _tile(String emoji, String title, String subtitle, Widget trailing, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        border: !isLast ? const Border(bottom: BorderSide(color: Color(0xFFC8ECEA))) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [Color(0xFFDDD6FE), Color(0xFFB2EDE7)]),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(color: const Color(0xFF0F2B28), fontSize: 12.5, fontWeight: FontWeight.w700)),
                Text(subtitle, style: GoogleFonts.inter(color: const Color(0xFF6EA8A2), fontSize: 10, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _toggle(bool value, ValueChanged<bool> onChanged, bool activeGradient) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36, height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: value && activeGradient
              ? const LinearGradient(colors: [Color(0xFF00BBA7), Color(0xFF009689)])
              : null,
          color: value && !activeGradient ? const Color(0xFF00BBA7) : (!value ? const Color(0xFFC8ECEA) : null),
        ),
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chevron() => Text('›', style: GoogleFonts.inter(color: const Color(0xFFC8ECEA), fontSize: 16, fontWeight: FontWeight.w700, height: 1));

  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text('Keluar', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  content: Text('Apakah Anda yakin ingin keluar dari akun?', style: GoogleFonts.inter()),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A5A)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
                      },
                      child: const Text('Keluar', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDE9FE)),
                boxShadow: [BoxShadow(color: const Color(0xFF009B89).withOpacity(0.1), blurRadius: 12)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: Color(0xFFFF5A5A), size: 16),
                  const SizedBox(width: 8),
                  Text('Keluar dari Akun', style: GoogleFonts.inter(color: const Color(0xFFFF5A5A), fontSize: 13, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('FisioCare v2.4.1 · © 2026 FisioCare Indonesia',
              style: GoogleFonts.inter(color: const Color(0xFF6EA8A2), fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
