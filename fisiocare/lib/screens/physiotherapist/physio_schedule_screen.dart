import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class PhysioScheduleScreen extends StatefulWidget {
  const PhysioScheduleScreen({super.key});

  @override
  State<PhysioScheduleScreen> createState() => _PhysioScheduleScreenState();
}

class _PhysioScheduleScreenState extends State<PhysioScheduleScreen> {
  final PhysiotherapistService _service = PhysiotherapistService();
  List<Schedule> _schedules = [];
  bool _isLoading = true;
  String? _error;

  final List<String> _hariOptions = [
    'senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu', 'minggu'
  ];

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
      // Assume physio ID from provider in real implementation
      final r = await _service.getSchedules(0);
      if (r['success'] == true) {
        final data = r['data'] as List;
        setState(() {
          _schedules = data.map((e) => Schedule.fromJson(e)).toList();
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

  void _showAddSchedule() {
    String _selectedHari = 'senin';
    TimeOfDay _jamMulai = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay _jamSelesai = const TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const Text(
                'Tambah Jadwal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedHari,
                decoration: const InputDecoration(labelText: 'Hari'),
                items: _hariOptions
                    .map((h) => DropdownMenuItem(
                          value: h,
                          child: Text(AppHelpers.getHariLabel(h)),
                        ))
                    .toList(),
                onChanged: (v) => setModalState(() => _selectedHari = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                          'Mulai: ${_jamMulai.format(ctx)}'),
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: _jamMulai,
                        );
                        if (t != null) {
                          setModalState(() => _jamMulai = t);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                          'Selesai: ${_jamSelesai.format(ctx)}'),
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: _jamSelesai,
                        );
                        if (t != null) {
                          setModalState(() => _jamSelesai = t);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _service.updateSchedule({
                      'hari': _selectedHari,
                      'jam_mulai':
                          '${_jamMulai.hour.toString().padLeft(2, '0')}:${_jamMulai.minute.toString().padLeft(2, '0')}:00',
                      'jam_selesai':
                          '${_jamSelesai.hour.toString().padLeft(2, '0')}:${_jamSelesai.minute.toString().padLeft(2, '0')}:00',
                      'kuota': 1,
                      'status': 'available',
                    });
                    Navigator.pop(ctx);
                    _load();
                    AppHelpers.showSnackBar(context, 'Jadwal berhasil ditambahkan');
                  } catch (e) {
                    AppHelpers.showSnackBar(context, 'Gagal menambahkan jadwal',
                        isError: true);
                  }
                },
                child: const Text('Simpan Jadwal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group schedules by day
    final Map<String, List<Schedule>> grouped = {};
    for (final s in _schedules) {
      grouped[s.hari] = [...(grouped[s.hari] ?? []), s];
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Saya')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSchedule,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Jadwal'),
        backgroundColor: const Color(AppColors.primary),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat jadwal...')
          : _error != null
              ? ErrorStateWidget(message: _error!, onRetry: _load)
              : _schedules.isEmpty
                  ? EmptyStateWidget(
                      title: 'Belum ada jadwal',
                      subtitle: 'Tambahkan jadwal praktik Anda',
                      icon: Icons.schedule,
                      action: ElevatedButton.icon(
                        onPressed: _showAddSchedule,
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Jadwal'),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: _hariOptions.length,
                        itemBuilder: (_, i) {
                          final hari = _hariOptions[i];
                          final schedules = grouped[hari] ?? [];
                          if (schedules.isEmpty) return const SizedBox();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  AppHelpers.getHariLabel(hari),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(AppColors.primary),
                                  ),
                                ),
                              ),
                              ...schedules.map((s) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: s.isAvailable
                                              ? const Color(AppColors.success)
                                                  .withOpacity(0.1)
                                              : const Color(AppColors.error)
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.access_time,
                                          color: s.isAvailable
                                              ? const Color(AppColors.success)
                                              : const Color(AppColors.error),
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        '${AppHelpers.formatTime(s.jamMulai)} - ${AppHelpers.formatTime(s.jamSelesai)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Kuota: ${s.kuota} | ${s.isAvailable ? 'Tersedia' : 'Tidak Tersedia'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Color(AppColors.error)),
                                        onPressed: () async {
                                          final ok = await AppHelpers
                                              .showConfirmDialog(
                                            context,
                                            title: 'Hapus Jadwal',
                                            message:
                                                'Yakin hapus jadwal ini?',
                                            isDanger: true,
                                          );
                                          if (ok) {
                                            await _service
                                                .deleteSchedule(s.id);
                                            _load();
                                          }
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        },
                      ),
                    ),
    );
  }
}
