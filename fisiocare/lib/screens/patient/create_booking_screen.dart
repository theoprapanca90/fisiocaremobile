import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/app_config.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final PhysiotherapistService _physioService = PhysiotherapistService();
  final _formKey = GlobalKey<FormState>();
  final _keluhanCtrl = TextEditingController();

  PhysiotherapistProfile? _physio;
  Service? _selectedService;
  Schedule? _selectedSchedule;
  Address? _selectedAddress;
  DateTime _selectedDay = DateTime.now();
  bool _isLoading = false;
  List<Service> _services = [];
  List<Schedule> _schedules = [];
  List<Address> _addresses = [];
  int _step = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['physioId'] != null) {
      _loadPhysio(args['physioId']);
    }
  }

  Future<void> _loadPhysio(int id) async {
    setState(() => _isLoading = true);
    try {
      final r = await _physioService.getPhysiotherapistDetail(id);
      if (r['success'] == true) {
        setState(() => _physio = PhysiotherapistProfile.fromJson(r['data']));
      }
      final sr = await _physioService.getSchedules(id);
      if (sr['success'] == true) {
        final data = sr['data'] as List;
        setState(
            () => _schedules = data.map((e) => Schedule.fromJson(e)).toList());
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'physiotherapist_id': _physio?.id,
      'service_id': _selectedService?.id,
      'address_id': _selectedAddress?.id,
      'booking_date':
          '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}',
      'start_time': _selectedSchedule?.jamMulai,
      'end_time': _selectedSchedule?.jamSelesai,
      'keluhan_awal': _keluhanCtrl.text,
    };

    final success = await context.read<BookingProvider>().createBooking(data);
    if (!mounted) return;
    if (success) {
      AppHelpers.showSnackBar(context, 'Booking berhasil dibuat!');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.patientHome,
        (r) => false,
      );
    } else {
      AppHelpers.showSnackBar(
        context,
        context.read<BookingProvider>().error ?? 'Gagal membuat booking',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Booking')),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat data...')
          : Form(
              key: _formKey,
              child: Stepper(
                currentStep: _step,
                onStepContinue: () {
                  if (_step < 3) {
                    setState(() => _step++);
                  } else {
                    _submit();
                  }
                },
                onStepCancel: () {
                  if (_step > 0) setState(() => _step--);
                },
                controlsBuilder: (ctx, details) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(_step < 3 ? 'Lanjut' : 'Buat Booking'),
                      ),
                      if (_step > 0) ...[
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Kembali'),
                        ),
                      ],
                    ],
                  ),
                ),
                steps: [
                  // Step 1: Layanan
                  Step(
                    title: const Text('Pilih Layanan'),
                    isActive: _step >= 0,
                    content: Column(
                      children: [
                        if (_physio != null) ...[
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(_physio!.user?.name ?? '-'),
                            subtitle: Text(_physio!.spesialisasi ?? ''),
                            trailing: Text(
                              AppHelpers.formatCurrency(_physio!.tarifDefault),
                              style: const TextStyle(
                                color: Color(AppColors.primary),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                        const Text(
                          'Pilih Jenis Layanan',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        ...['home_visit', 'telekonsul'].map((mode) => RadioListTile<String>(
                              title: Text(AppHelpers.getServiceModeLabel(mode)),
                              subtitle: Text(
                                mode == 'home_visit'
                                    ? 'Fisioterapis datang ke rumah Anda'
                                    : 'Konsultasi online via video call',
                              ),
                              value: mode,
                              groupValue: _selectedService?.serviceMode,
                              onChanged: (v) {
                                setState(() {
                                  _selectedService = Service(
                                    id: 0,
                                    kodeLayanan: '',
                                    namaLayanan: AppHelpers.getServiceModeLabel(v!),
                                    serviceMode: v,
                                    durasiMenit: 60,
                                    harga: _physio?.tarifDefault ?? 0,
                                  );
                                });
                              },
                            )),
                      ],
                    ),
                  ),

                  // Step 2: Jadwal
                  Step(
                    title: const Text('Pilih Jadwal'),
                    isActive: _step >= 1,
                    content: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay:
                              DateTime.now().add(const Duration(days: 60)),
                          focusedDay: _selectedDay,
                          selectedDayPredicate: (d) =>
                              isSameDay(d, _selectedDay),
                          onDaySelected: (selected, focused) {
                            setState(() => _selectedDay = selected);
                          },
                          calendarStyle: const CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: Color(AppColors.primary),
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Color(AppColors.primaryLight),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Pilih Jam',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        if (_schedules.isEmpty)
                          const Text('Tidak ada jadwal tersedia',
                              style: TextStyle(
                                  color: Color(AppColors.textSecondary))),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _schedules
                              .where((s) => s.isAvailable)
                              .map((s) => ChoiceChip(
                                    label: Text(
                                        '${AppHelpers.formatTime(s.jamMulai)} - ${AppHelpers.formatTime(s.jamSelesai)}'),
                                    selected: _selectedSchedule?.id == s.id,
                                    onSelected: (_) =>
                                        setState(() => _selectedSchedule = s),
                                    selectedColor:
                                        const Color(AppColors.primary),
                                    labelStyle: TextStyle(
                                      color: _selectedSchedule?.id == s.id
                                          ? Colors.white
                                          : null,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // Step 3: Alamat (jika home visit)
                  Step(
                    title: const Text('Alamat'),
                    isActive: _step >= 2,
                    content: _selectedService?.serviceMode == 'home_visit'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pilih alamat tujuan'),
                              const SizedBox(height: 8),
                              if (_addresses.isEmpty)
                                OutlinedButton.icon(
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.patientAddress),
                                  icon: const Icon(Icons.add_location_outlined),
                                  label:
                                      const Text('Tambah Alamat'),
                                )
                              else
                                ..._addresses.map((a) => RadioListTile<Address>(
                                      title: Text(a.labelAlamat ?? 'Alamat'),
                                      subtitle:
                                          Text(a.alamatLengkap),
                                      value: a,
                                      groupValue: _selectedAddress,
                                      onChanged: (v) => setState(
                                          () => _selectedAddress = v),
                                    )),
                            ],
                          )
                        : const Text(
                            'Sesi telekonsultasi akan dilakukan secara online.',
                            style: TextStyle(
                                color: Color(AppColors.textSecondary)),
                          ),
                  ),

                  // Step 4: Konfirmasi
                  Step(
                    title: const Text('Konfirmasi'),
                    isActive: _step >= 3,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
                          label: 'Fisioterapis',
                          value: _physio?.user?.name ?? '-',
                        ),
                        InfoRow(
                          label: 'Layanan',
                          value: _selectedService?.namaLayanan ?? '-',
                        ),
                        InfoRow(
                          label: 'Tanggal',
                          value: AppHelpers.formatDate(
                              _selectedDay.toIso8601String()),
                        ),
                        InfoRow(
                          label: 'Jam',
                          value: _selectedSchedule != null
                              ? '${AppHelpers.formatTime(_selectedSchedule!.jamMulai)} - ${AppHelpers.formatTime(_selectedSchedule!.jamSelesai)}'
                              : '-',
                        ),
                        if (_selectedAddress != null)
                          InfoRow(
                            label: 'Alamat',
                            value: _selectedAddress!.alamatLengkap,
                          ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Keluhan / Deskripsi',
                          controller: _keluhanCtrl,
                          maxLines: 4,
                          hint: 'Ceritakan keluhan atau kondisi Anda...',
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(AppColors.primary)
                                .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Biaya',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                AppHelpers.formatCurrency(
                                    _selectedService?.harga ?? 0),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
