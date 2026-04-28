# FisioCare - Aplikasi Fisioterapi Flutter

Aplikasi fisioterapi mobile berbasis Flutter dengan fitur lengkap untuk pasien, fisioterapis, dan admin.

---

## 🗂️ Struktur Project

```
fisiocare/
├── lib/
│   ├── config/
│   │   └── app_config.dart          # Konfigurasi URL API, warna, routes
│   ├── models/
│   │   ├── user_model.dart          # User, PatientProfile, PhysiotherapistProfile, AdminProfile
│   │   └── booking_model.dart       # Booking, Service, Payment, ChatMessage, dll
│   ├── services/
│   │   ├── api_service.dart         # HTTP Client (GET, POST, PUT, DELETE, Upload)
│   │   ├── auth_service.dart        # Login, Register, Logout, Profile
│   │   └── booking_service.dart     # BookingService, PaymentService, ChatService, dll
│   ├── providers/
│   │   ├── auth_provider.dart       # State management autentikasi
│   │   └── booking_provider.dart    # State management booking
│   ├── screens/
│   │   ├── shared/
│   │   │   └── splash_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── patient/
│   │   │   ├── patient_home_screen.dart
│   │   │   ├── booking_list_screen.dart
│   │   │   ├── booking_detail_screen.dart
│   │   │   ├── create_booking_screen.dart
│   │   │   ├── physiotherapist_list_screen.dart
│   │   │   ├── physiotherapist_detail_screen.dart
│   │   │   ├── medical_record_screen.dart
│   │   │   ├── notification_screen.dart
│   │   │   ├── chat_screen.dart
│   │   │   ├── review_screen.dart
│   │   │   ├── address_screen.dart
│   │   │   └── patient_profile_screen.dart
│   │   ├── physiotherapist/
│   │   │   ├── physio_home_screen.dart
│   │   │   └── physio_schedule_screen.dart
│   │   └── admin/
│   │       └── admin_home_screen.dart
│   ├── widgets/
│   │   └── common_widgets.dart      # Widget reusable (Card, Badge, TextField, dll)
│   ├── utils/
│   │   ├── app_theme.dart           # Tema global Material 3
│   │   └── helpers.dart             # Format tanggal, currency, snackbar, dll
│   └── main.dart                    # Entry point + routing
├── pubspec.yaml
└── android/app/src/main/AndroidManifest.xml
```

---

## 🚀 Cara Menjalankan

### 1. Setup Dependencies
```bash
flutter pub get
```

### 2. Konfigurasi API
Edit file `lib/config/app_config.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api'; // Ganti dengan URL API backend Anda
```

### 3. Jalankan Aplikasi
```bash
flutter run
```

---

## 🔑 Fitur per Role

### 👤 Pasien
- Registrasi & Login
- Lihat & cari daftar fisioterapis
- Booking layanan (Home Visit / Telekonsultasi)
- Lihat & kelola booking
- Upload bukti pembayaran
- Chat dengan fisioterapis
- Lihat rekam medis
- Beri ulasan & rating
- Kelola alamat

### 🩺 Fisioterapis
- Dashboard ringkasan
- Toggle ketersediaan
- Kelola jadwal praktik
- Lihat & proses booking pasien
- Input rekam medis
- Chat dengan pasien

### 🛠️ Admin
- Dashboard statistik
- Manajemen pengguna (aktifkan/suspend akun)
- Monitor semua booking
- Verifikasi pembayaran
- Kelola layanan
- Moderasi ulasan
- Laporan

---

## 🔌 API Endpoints yang Dibutuhkan

### Auth
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| POST | /api/v1/auth/login | Login |
| POST | /api/v1/auth/register | Registrasi |
| POST | /api/v1/auth/logout | Logout |
| GET | /api/v1/auth/profile | Profil user |
| PUT | /api/v1/auth/profile | Update profil |
| POST | /api/v1/auth/change-password | Ganti password |

### Booking
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/v1/bookings | Daftar booking pasien |
| POST | /api/v1/bookings | Buat booking |
| GET | /api/v1/bookings/{id} | Detail booking |
| POST | /api/v1/bookings/{id}/cancel | Batalkan booking |
| GET | /api/v1/physio/bookings | Daftar booking fisioterapis |

### Pembayaran
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/v1/payments | Daftar pembayaran |
| POST | /api/v1/payments | Buat pembayaran |
| POST | /api/v1/payments/{id}/proof | Upload bukti |
| POST | /api/v1/payments/{id}/verify | Verifikasi (admin) |

### Fisioterapis
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/v1/physiotherapists | Daftar fisioterapis |
| GET | /api/v1/physiotherapists/{id} | Detail fisioterapis |
| GET | /api/v1/physiotherapists/{id}/schedules | Jadwal |
| GET | /api/v1/physiotherapists/{id}/reviews | Ulasan |
| PATCH | /api/v1/physio/availability | Update ketersediaan |
| POST | /api/v1/physio/schedules | Tambah jadwal |

### Notifikasi & Chat
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/v1/notifications | Daftar notifikasi |
| POST | /api/v1/notifications/{id}/read | Tandai dibaca |
| GET | /api/v1/chats/{bookingId}/messages | Pesan chat |
| POST | /api/v1/chats/{bookingId}/messages | Kirim pesan |

### Rekam Medis
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/v1/medical-records | Rekam medis |
| POST | /api/v1/medical-records | Buat rekam medis |
| GET | /api/v1/medical-records/{id} | Detail |

### Admin
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/v1/admin/dashboard | Statistik |
| GET | /api/v1/admin/users | Semua pengguna |
| GET | /api/v1/admin/bookings | Semua booking |
| GET | /api/v1/admin/payments | Semua pembayaran |

---

## ⚙️ Format Response API

Semua endpoint harus mengembalikan format:
```json
{
  "success": true,
  "message": "Berhasil",
  "data": { ... }
}
```

Untuk list dengan paginasi:
```json
{
  "success": true,
  "data": {
    "data": [ ... ],
    "current_page": 1,
    "last_page": 5,
    "per_page": 10,
    "total": 50
  }
}
```

---

## 📦 Dependencies Utama

| Package | Versi | Fungsi |
|---------|-------|--------|
| provider | ^6.1.2 | State management |
| http | ^1.2.1 | HTTP requests |
| shared_preferences | ^2.2.3 | Penyimpanan lokal (token) |
| intl | ^0.19.0 | Format tanggal & angka |
| cached_network_image | ^3.3.1 | Gambar dari URL |
| flutter_rating_bar | ^4.0.1 | Rating bintang |
| table_calendar | ^3.1.2 | Kalender pemilihan tanggal |
| image_picker | ^1.1.2 | Pilih foto |
| shimmer | ^3.0.0 | Loading placeholder |

---

## 🗒️ Catatan

1. **Google Maps**: Ganti `YOUR_GOOGLE_MAPS_API_KEY` di `AndroidManifest.xml` dengan API key Google Maps Anda.
2. **Backend**: Pastikan backend Laravel/Express sudah berjalan dan bisa diakses dari device/emulator.
3. **Font Poppins**: Tambahkan file font Poppins ke `assets/fonts/` setelah download dari Google Fonts.
4. **Assets**: Buat folder `assets/images/`, `assets/icons/`, `assets/lottie/` meskipun kosong.

---

## 🏗️ Teknologi

- **Flutter** 3.x (Dart 3.x)
- **State Management**: Provider
- **HTTP**: http package
- **Storage**: SharedPreferences
- **UI**: Material Design 3
