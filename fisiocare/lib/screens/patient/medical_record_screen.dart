import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  final MedicalRecordService _service = MedicalRecordService();
  List<MedicalRecord> _records = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final r = await _service.getMedicalRecords();
      if (r['success'] == true) {
        final data = r['data']['data'] as List;
        setState(() {
          _records = data.map((e) => MedicalRecord.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = r['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekam Medis')),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat rekam medis...')
          : _error != null
              ? ErrorStateWidget(message: _error!, onRetry: _load)
              : _records.isEmpty
                  ? const EmptyStateWidget(
                      title: 'Belum ada rekam medis',
                      subtitle: 'Rekam medis Anda akan muncul setelah sesi terapi',
                      icon: Icons.medical_information_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _MedicalRecordCard(record: _records[i]),
                      ),
                    ),
    );
  }
}

class _MedicalRecordCard extends StatelessWidget {
  final MedicalRecord record;
  const _MedicalRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _MedicalRecordDetail(record: record),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppHelpers.formatDate(record.createdAt),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(AppColors.textSecondary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Rekam Medis',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(AppColors.primary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: Color(AppColors.primary)),
              const SizedBox(width: 6),
              Text(
                'Fisioterapis: ${record.physiotherapist?.user?.name ?? '-'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.textPrimary),
                ),
              ),
            ],
          ),
          if (record.diagnosisFisioterapi != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.medical_services_outlined,
                    size: 14, color: Color(AppColors.textSecondary)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Diagnosis: ${record.diagnosisFisioterapi}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(AppColors.textSecondary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          const Text(
            'Tap untuk lihat detail',
            style: TextStyle(
              fontSize: 11,
              color: Color(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalRecordDetail extends StatelessWidget {
  final MedicalRecord record;
  const _MedicalRecordDetail({required this.record});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(AppColors.border),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rekam Medis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
                Text(
                  AppHelpers.formatDate(record.createdAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (record.anamnesis != null)
              _RecordSection(title: 'Anamnesis', content: record.anamnesis!),
            if (record.pemeriksaanFisik != null)
              _RecordSection(
                  title: 'Pemeriksaan Fisik', content: record.pemeriksaanFisik!),
            if (record.diagnosisFisioterapi != null)
              _RecordSection(
                  title: 'Diagnosis Fisioterapi',
                  content: record.diagnosisFisioterapi!),
            if (record.tujuanTerapi != null)
              _RecordSection(
                  title: 'Tujuan Terapi', content: record.tujuanTerapi!),
            if (record.tindakan != null)
              _RecordSection(title: 'Tindakan', content: record.tindakan!),
            if (record.edukasi != null)
              _RecordSection(title: 'Edukasi', content: record.edukasi!),
            if (record.rekomendasi != null)
              _RecordSection(
                  title: 'Rekomendasi', content: record.rekomendasi!),
            if (record.rencanaLanjut != null)
              _RecordSection(
                  title: 'Rencana Lanjut', content: record.rencanaLanjut!),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RecordSection extends StatelessWidget {
  final String title;
  final String content;
  const _RecordSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(AppColors.primary),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(AppColors.textPrimary),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}
