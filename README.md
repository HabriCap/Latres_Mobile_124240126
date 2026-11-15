# GasNonton! — TV Show Explorer

Aplikasi Flutter untuk menjelajahi serial dan show TV dari TVMaze.

## Fitur

- Login dengan NIM `126` dan password `123`; sesi disimpan dengan SharedPreferences.
- Daftar show dari `https://api.tvmaze.com/shows`, lengkap dengan poster dan rating.
- Halaman detail memuat data dari `https://api.tvmaze.com/shows/{id}`.
- Favorit dapat ditambah atau dihapus dan disimpan secara lokal dengan Hive.
- Profil menampilkan username, kesan-pesan, dan tombol logout.
- GetX digunakan untuk state controller, dependency injection, dan routing.

## Menjalankan aplikasi

```shell
flutter pub get
flutter run
```

Jalankan pengujian dengan `flutter test` dan pemeriksaan statis dengan
`flutter analyze`.

Pengambilan dan parsing data API dipisahkan ke `lib/services/api_service.dart`.
