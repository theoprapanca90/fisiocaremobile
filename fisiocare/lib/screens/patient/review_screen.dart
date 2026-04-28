import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../config/app_config.dart';
import '../../services/booking_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/common_widgets.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewService _service = ReviewService();
  final _reviewCtrl = TextEditingController();
  double _rating = 5;
  bool _isLoading = false;
  int? _bookingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bookingId = ModalRoute.of(context)?.settings.arguments as int?;
  }

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_bookingId == null) return;
    setState(() => _isLoading = true);
    try {
      final r = await _service.createReview({
        'booking_id': _bookingId,
        'rating': _rating.toInt(),
        'review': _reviewCtrl.text,
      });
      if (mounted) {
        if (r['success'] == true) {
          AppHelpers.showSnackBar(context, 'Ulasan berhasil dikirim!');
          Navigator.pop(context);
        } else {
          AppHelpers.showSnackBar(context, r['message'] ?? 'Gagal', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        AppHelpers.showSnackBar(context, 'Gagal mengirim ulasan', isError: true);
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beri Ulasan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.star_rate,
              size: 60,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bagaimana pengalaman Anda?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(AppColors.textPrimary),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Berikan penilaian untuk sesi fisioterapi Anda',
              style: TextStyle(
                fontSize: 14,
                color: Color(AppColors.textSecondary),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 8),
              itemSize: 48,
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (r) => setState(() => _rating = r),
            ),
            const SizedBox(height: 8),
            Text(
              _getRatingLabel(_rating.toInt()),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getRatingColor(_rating.toInt()),
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: 'Ulasan (opsional)',
              controller: _reviewCtrl,
              maxLines: 5,
              hint: 'Ceritakan pengalaman Anda...',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Cukup';
      case 4:
        return 'Bagus';
      case 5:
        return 'Sangat Bagus!';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    if (rating <= 2) return const Color(AppColors.error);
    if (rating == 3) return const Color(AppColors.warning);
    return const Color(AppColors.success);
  }
}
