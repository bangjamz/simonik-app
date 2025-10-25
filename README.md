# SIMONIK Mahardika

**Sistem Informasi Monitoring dan Evaluasi Indikator Kinerja**  
Institut Teknologi dan Kesehatan Mahardika

## 📱 Tentang Aplikasi

SIMONIK adalah sistem informasi berbasis Flutter untuk monitoring dan evaluasi indikator kinerja di Institut Teknologi dan Kesehatan Mahardika Cirebon. Aplikasi ini dirancang untuk memudahkan proses monitoring kinerja institusi dengan fitur-fitur lengkap dan user-friendly.

## ✨ Fitur Utama

### 1. **Sistem Autentikasi & RBAC**
- Login dengan Email/Password
- Login dengan Google
- Role-Based Access Control (RBAC)
- 11 Role Predefined: Admin, Ketua LPM, LPM, Rektor, Rektorat, Dekan, Kaprodi, Biro, LPPM, Auditor, Auditee
- Custom Role dengan Permission yang dapat dikonfigurasi
- Dual Role Support (Rektor, Rektorat, Dekan, Kaprodi dapat menjadi Auditor dan Auditee)

### 2. **Manajemen User**
- Tambah, Edit, Hapus User
- Assign Role dan Permission
- Custom Role Creation
- User Status Management

### 3. **Indikator Kinerja**
- **IKU (Indikator Kinerja Utama)**: Indikator kinerja utama institusi
- **IKT (Indikator Kinerja Tambahan)**: Indikator kinerja tambahan
- Kategori dan Sub-Kategori yang dapat di-rename
- CRUD Indikator lengkap

### 4. **Monitoring & Evaluasi (Monev)**
- Buat sesi Monev dengan jadwal dan unit kerja
- Generate kode unik untuk melanjutkan sesi
- Form penilaian dengan dropdown IKU/IKT
- 4 Level Pencapaian:
  - **Melampaui (4 poin)**
  - **Tercapai (3 poin)**
  - **Belum Tercapai (2 poin)**
  - **Tidak Dilakukan (1 poin)**
- Otomasi perhitungan skor
- Link bukti Google Drive
- Simpan Sementara & Simpan Permanen

### 5. **Laporan & Visualisasi**
- Dashboard statistik
- Grafik Ketercapaian (Bar Chart)
- Grafik Radar per Kategori
- Tabel Detail Penilaian
- Export PDF dengan Kop Surat
- Share Laporan

### 6. **Pengaturan Aplikasi**
- Upload Logo Institusi
- Upload Kop Surat
- Kustomisasi Font (Roboto, Arial, Times New Roman)
- Ukuran Font (10-20pt)
- Tema Warna
- Informasi Institusi
- Backup Data

### 7. **Admin Dashboard**
- Panel administrasi lengkap
- Manajemen User
- Role & Permission Management
- Kategori Indikator
- Unit Kerja
- Laporan Sistem
- Backup & Restore

## 🎨 Desain UI/UX

- **Mobile-First Design**: Responsif terhadap berbagai ukuran layar
- **Material Design 3**: Menggunakan design system terbaru dari Google
- **Intuitive Navigation**: Bottom navigation dengan 4 tab utama
- **Color Scheme**: Biru & Oranye (customizable)
- **Dark/Light Mode**: (Future enhancement)

## 🚀 Teknologi

### Frontend
- **Flutter 3.35.4**: Framework cross-platform
- **Dart 3.9.2**: Programming language
- **Material Design 3**: UI design system

### Backend (Optional - Firebase)
- **Firebase Auth**: Authentication
- **Cloud Firestore**: NoSQL database
- **Firebase Storage**: File storage

### State Management
- **Provider**: Lightweight state management

### Visualization
- **FL Chart**: Charts dan graphs

### PDF Generation
- **PDF Package**: Generate PDF reports
- **Printing Package**: Print & export functionality

## 📦 Dependencies

```yaml
dependencies:
  # Firebase Core (LOCKED versions)
  firebase_core: 3.6.0
  cloud_firestore: 5.4.3
  firebase_auth: 5.3.1
  firebase_storage: 12.3.2
  google_sign_in: 6.2.2
  
  # State Management
  provider: 6.1.5+1
  
  # Local Storage
  shared_preferences: 2.5.3
  hive: 2.2.3
  hive_flutter: 1.1.0
  
  # Visualization
  fl_chart: 0.70.1
  
  # PDF & Printing
  pdf: 3.11.1
  printing: 5.13.4
  
  # Utilities
  image_picker: 1.1.2
  url_launcher: 6.3.1
  uuid: 4.5.1
  intl: 0.19.0
  path_provider: 2.1.5
```

## 📂 Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Data models
│   ├── user_model.dart
│   ├── indicator_model.dart
│   ├── monev_model.dart
│   └── settings_model.dart
├── screens/                  # UI Screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── admin/               # Admin screens
│   │   ├── admin_dashboard_screen.dart
│   │   └── user_management_screen.dart
│   ├── monev/               # Monev screens
│   │   ├── monev_list_screen.dart
│   │   ├── create_monev_screen.dart
│   │   └── monev_detail_screen.dart
│   ├── indicators/          # Indicator screens
│   │   └── indicator_list_screen.dart
│   ├── settings/            # Settings screens
│   │   └── settings_screen.dart
│   └── reports/             # Report screens
│       └── monev_report_screen.dart
├── services/                # Business logic
│   ├── auth_service.dart
│   └── firestore_service.dart
├── utils/                   # Utilities
│   ├── code_generator.dart
│   └── date_formatter.dart
└── widgets/                 # Reusable widgets
```

## 🛠️ Instalasi & Setup

### Prerequisites
- Flutter SDK 3.35.4
- Dart SDK 3.9.2
- Android Studio / VS Code
- Firebase Account (optional)

### Setup Steps

1. **Clone Repository**
```bash
git clone <repository-url>
cd flutter_app
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Firebase Configuration (Optional)**
   - Buat project di Firebase Console
   - Download `google-services.json` (Android)
   - Letakkan di `android/app/`
   - Konfigurasi Firebase di `lib/main.dart`

4. **Run Application**

**Web Preview:**
```bash
flutter run -d chrome
```

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🌐 Demo Web

Aplikasi dapat diakses di:
**https://5060-icki9acaef5kgbwa50sb6-2e1b9533.sandbox.novita.ai**

## 📱 Cara Menggunakan

### 1. Login
- Gunakan email dan password atau Google Sign-In
- Default role untuk new user: Auditee

### 2. Dashboard
- Lihat statistik total user, indikator, dan monev
- Quick actions untuk akses cepat

### 3. Membuat Monev
- Pilih "Monev Baru" dari dashboard
- Isi informasi: Judul, Unit Kerja, Tanggal, Auditor, Auditee
- Sistem akan generate kode unik
- Mulai proses evaluasi

### 4. Melakukan Evaluasi
- Pilih indikator dari dropdown
- Pilih tingkat pencapaian (Melampaui/Tercapai/Belum Tercapai/Tidak Dilakukan)
- Masukkan link bukti Google Drive
- Simpan sementara atau simpan permanen

### 5. Melihat Laporan
- Lihat skor total dan rata-rata
- Grafik ketercapaian dan radar
- Export ke PDF
- Share laporan

### 6. Admin
- Kelola user dan role
- Tambah/edit indikator
- Konfigurasi kategori
- Backup data

## 🔐 Role & Permission

### Admin & Ketua LPM
- Full access ke semua menu
- Manajemen user
- Manajemen indikator
- Manajemen monev
- View all reports
- Manage settings

### LPM
- Manajemen indikator
- Manajemen monev
- View all reports
- Conduct monev
- Export PDF

### Auditor
- Conduct monev
- View own reports
- Export PDF

### Auditee
- View own reports

### Dual Role (Rektor, Rektorat, Dekan, Kaprodi)
- Dapat berperan sebagai Auditor dan Auditee
- Conduct monev
- View own reports
- Export PDF

## 🎯 Roadmap

### v1.0 (Current)
- ✅ Authentication system
- ✅ RBAC implementation
- ✅ Indikator management
- ✅ Monev system
- ✅ Report generation
- ✅ Settings management

### v1.1 (Planned)
- [ ] Firebase integration fully implemented
- [ ] Real-time notifications
- [ ] Advanced analytics
- [ ] Dark mode
- [ ] Multi-language support

### v1.2 (Future)
- [ ] Mobile app optimization
- [ ] Offline mode
- [ ] Advanced PDF customization
- [ ] Email notifications
- [ ] API integration

## 🤝 Kontribusi

Untuk berkontribusi pada project ini:
1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📄 Lisensi

Copyright © 2024 Institut Teknologi dan Kesehatan Mahardika

## 📞 Kontak

**Institut Teknologi dan Kesehatan Mahardika**  
Cirebon, Jawa Barat  
Website: [mahardika.ac.id](https://mahardika.ac.id)

---

**Dikembangkan dengan ❤️ menggunakan Flutter**
