# Monetra: Aplikasi Keuangan Indonesia 🇮🇩

Selamat! Aplikasi Monetra (Aplikasi Manajemen Keuangan & UMKM) Anda telah siap digunakan dengan fitur production-ready.

## 🚀 Cara Menjalankan Aplikasi

### 1. Jalankan Backend (Laravel)
Pastikan PHP & SQLite sudah siap.
```powershell
cd e:\monetra\backend
php artisan serve
```
*Backend akan berjalan di: http://127.0.0.1:8000*

### 2. Jalankan Frontend (Flutter Web)
Gunakan script batch untuk kemudahan (ini adalah cara paling stabil):
1. Buka folder `e:\monetra`
2. Klik kanan dan jalankan `run_web.bat`
3. Aplikasi akan terbuka di browser Chrome.

---

## 🔑 Data Login (Demo)
* **Email**: `demo@example.com`
* **Password**: `password`
* **PIN**: `123456`

---

## ✨ Fitur Utama (Konteks Indonesia)

### 📊 Beranda (Dashboard Premium)
* **Total Saldo (IDR)**: Tampilan saldo real-time dengan format Rupiah (Rp).
* **Menu Utama**: Akses cepat ke Dompet, Transaksi, UMKM, dan Tagihan.
* **Sinkronisasi**: Tombol sinkronisasi manual ke cloud server.

### 💼 Mode UMKM
* **Penjualan**: Catat penjualan harian UMKM Anda.
* **Hutang Piutang**: Lacak siapa yang berhutang dan kapan harus menagih (Hutang ke supplier atau Piutang pelanggan).

### 🔔 Pengingat Tagihan (Bill Reminder)
* **PLN, PDAM, Internet**: Catat semua tagihan rutin bulanan.
* **Peringatan**: Tagihan yang jatuh tempo dalam < 3 hari akan berwarna merah.

### 👛 Multi Dompet
* Mendukung kategori **Tunai**, **Bank (BCA/Mandiri/dll)**, dan **E-Wallet (GoPay/OVO/DANA)**.

---

## �️ Arsitektur & Teknologi
* **Flutter v3.27.1**: Frontend cross-platform dengan performa tinggi.
* **Riverpod State Management**: Manajemen status aplikasi yang modern dan testable.
* **SQLite (Offline-First)**: Data tetap tersimpan walaupun tidak ada internet.
* **Laravel 11 API (Sanctum Auth)**: Backend aman dengan otentikasi token.
* **Cloud Sync Engine**: Menjamin data Anda aman dan terikat dengan akun cloud.

---

## ⚡ Troubleshooting
* **Error 500 saat Login**: Berhasil diperbaiki dengan migrasi tabel token.
* **Flutter Not Found**: Pastikan PATH `E:\flutter\bin` sudah benar (sudah dihandle dalam script `.bat`).
* **Koneksi Backend**: Aplikasi otomatis mendeteksi alamat IP backend (localhost untuk Web/Windows, 10.0.2.2 untuk Android).

---
*Dikembangkan oleh Antigravity AI - Solusi Fintech Indonesia untuk Anda.*
