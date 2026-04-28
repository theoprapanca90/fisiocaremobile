import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressService _service = AddressService();
  List<Address> _addresses = [];
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
      final r = await _service.getAddresses();
      if (r['success'] == true) {
        final data = r['data'] as List;
        setState(() {
          _addresses = data.map((e) => Address.fromJson(e)).toList();
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

  void _showAddressForm({Address? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddressForm(
        address: address,
        onSaved: _load,
      ),
    );
  }

  Future<void> _delete(int id) async {
    final confirmed = await AppHelpers.showConfirmDialog(
      context,
      title: 'Hapus Alamat',
      message: 'Apakah Anda yakin ingin menghapus alamat ini?',
      isDanger: true,
    );
    if (confirmed) {
      try {
        await _service.deleteAddress(id);
        _load();
        AppHelpers.showSnackBar(context, 'Alamat berhasil dihapus');
      } catch (e) {
        AppHelpers.showSnackBar(context, 'Gagal menghapus alamat', isError: true);
      }
    }
  }

  Future<void> _setDefault(int id) async {
    try {
      await _service.setDefaultAddress(id);
      _load();
      AppHelpers.showSnackBar(context, 'Alamat utama berhasil diubah');
    } catch (e) {
      AppHelpers.showSnackBar(context, 'Gagal mengubah alamat utama', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alamat Saya')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressForm(),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Tambah Alamat'),
        backgroundColor: const Color(AppColors.primary),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat alamat...')
          : _error != null
              ? ErrorStateWidget(message: _error!, onRetry: _load)
              : _addresses.isEmpty
                  ? EmptyStateWidget(
                      title: 'Belum ada alamat',
                      subtitle: 'Tambahkan alamat untuk booking home visit',
                      icon: Icons.location_off_outlined,
                      action: ElevatedButton.icon(
                        onPressed: () => _showAddressForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Alamat'),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: _addresses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final a = _addresses[i];
                          return AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: a.isDefault
                                          ? const Color(AppColors.primary)
                                          : const Color(AppColors.textSecondary),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        a.labelAlamat ?? 'Alamat',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(AppColors.textPrimary),
                                        ),
                                      ),
                                    ),
                                    if (a.isDefault)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(AppColors.primary)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Utama',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(AppColors.primary),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (a.penerima != null) ...[
                                  Text(
                                    a.penerima!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                                Text(
                                  a.alamatLengkap,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(AppColors.textSecondary),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    if (!a.isDefault)
                                      TextButton(
                                        onPressed: () => _setDefault(a.id),
                                        child: const Text('Jadikan Utama'),
                                      ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 20),
                                      color: const Color(AppColors.primary),
                                      onPressed: () =>
                                          _showAddressForm(address: a),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 20),
                                      color: const Color(AppColors.error),
                                      onPressed: () => _delete(a.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _AddressForm extends StatefulWidget {
  final Address? address;
  final VoidCallback onSaved;
  const _AddressForm({this.address, required this.onSaved});

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final AddressService _service = AddressService();
  late TextEditingController _labelCtrl;
  late TextEditingController _penerimaCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _alamatCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.address?.labelAlamat ?? '');
    _penerimaCtrl = TextEditingController(text: widget.address?.penerima ?? '');
    _phoneCtrl = TextEditingController(text: widget.address?.phone ?? '');
    _alamatCtrl = TextEditingController(text: widget.address?.alamatLengkap ?? '');
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _penerimaCtrl.dispose();
    _phoneCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'label_alamat': _labelCtrl.text,
      'penerima': _penerimaCtrl.text,
      'phone': _phoneCtrl.text,
      'alamat_lengkap': _alamatCtrl.text,
    };

    try {
      if (widget.address != null) {
        await _service.updateAddress(widget.address!.id, data);
      } else {
        await _service.createAddress(data);
      }
      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        AppHelpers.showSnackBar(
          context,
          widget.address != null
              ? 'Alamat berhasil diperbarui'
              : 'Alamat berhasil ditambahkan',
        );
      }
    } catch (e) {
      if (mounted) {
        AppHelpers.showSnackBar(context, 'Gagal menyimpan alamat', isError: true);
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
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
            Text(
              widget.address != null ? 'Edit Alamat' : 'Tambah Alamat',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Label Alamat',
              controller: _labelCtrl,
              hint: 'Contoh: Rumah, Kantor',
              prefixIcon: const Icon(Icons.label_outline),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Label wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Nama Penerima',
              controller: _penerimaCtrl,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Nomor Telepon',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Alamat Lengkap',
              controller: _alamatCtrl,
              maxLines: 3,
              prefixIcon: const Icon(Icons.location_on_outlined),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Alamat wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Simpan Alamat'),
            ),
          ],
        ),
      ),
    );
  }
}
