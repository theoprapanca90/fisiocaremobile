import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _bookings = [];
  Booking? _selectedBooking;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadBookings({String? status, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _bookings = [];
      _hasMore = true;
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _bookingService.getBookings(
        status: status,
        page: _currentPage,
      );

      if (response['success'] == true) {
        final data = response['data'];
        final newBookings = (data['data'] as List)
            .map((e) => Booking.fromJson(e))
            .toList();

        _bookings.addAll(newBookings);
        _currentPage++;
        _hasMore = data['current_page'] < data['last_page'];
      } else {
        _error = response['message'];
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> loadBookingDetail(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _bookingService.getBookingDetail(id);
      if (response['success'] == true) {
        _selectedBooking = Booking.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'];
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> createBooking(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _bookingService.createBooking(data);
      if (response['success'] == true) {
        _selectedBooking = Booking.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'];
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> cancelBooking(int id, String reason) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _bookingService.cancelBooking(id, reason);
      if (response['success'] == true) {
        final idx = _bookings.indexWhere((b) => b.id == id);
        if (idx != -1) {
          final b = _bookings[idx];
          _bookings[idx] = Booking.fromJson({
            ...b.toJson(),
            'status_booking': 'cancelled',
          });
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'];
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
