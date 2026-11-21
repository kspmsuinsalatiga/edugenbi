# GENBI MISSION

Website pembelajaran interaktif **GENBI MISSION: Kenal BI, Main, dan Buktikan!**

## Halaman dan aktivitas
- **Beranda:** rute empat pos, identitas tim, ringkasan progres, dan leaderboard.
- **Pos 1 — ARIS:** QRIS Lab, merchant latihan, wallet simulasi Rp50.000, konfirmasi transaksi, serta Cross Border Trip.
- **Pos 2 — PEKA:** tiga percakapan simulasi, pemeriksaan identitas pengirim, lencana dan tautan, investigasi kejanggalan, dan pemilihan kanal resmi.
- **Pos 3 — Ekonomi Cerdas:** permainan lempar target fisik; fasilitator mencatat validasi tembakan.
- **Pos 4 — Ke-bank sentralan:** empat studi kasus BI dan BI Control Room.
- **Final Challenge:** 15 soal.
- **Leaderboard:** skor seluruh kelompok yang tersimpan di Supabase.

## Teknologi
- HTML, CSS, dan JavaScript dalam satu file statis.
- Supabase Auth (anonymous sessions), PostgreSQL, Row Level Security, dan Realtime.
- GitHub Pages untuk hosting.
- Supabase JS v2.119.2 melalui CDN.

## Supabase
Project ref: `gavsepqkjudrtjftuafa`

Schema sudah dibuat dan migration tercatat sebagai `genbi_mission_initial_schema`. Tabel:
`teams`, `team_members`, `mission_progress`, `mission_events`, `leaderboard_public`.
Kode undangan disimpan sebagai hash di schema `private`; jangan masukkan kode mentah ke repository publik.

### Langkah admin yang masih perlu dilakukan
1. Buka Supabase → **Authentication → Sign In / Providers**, aktifkan **Anonymous Sign-Ins**.
2. Buka Project Settings → **Data API**, pastikan schema `public` diekspos.
3. Aktifkan RLS tambahan untuk tabel privat undangan dengan SQL berikut (Security Advisor menandai RLS belum aktif pada tabel ini; tabel berada pada schema non-exposed dan tidak diberi grant kepada client):
   ```sql
   ALTER TABLE private.team_invites ENABLE ROW LEVEL SECURITY;
   ```
   Tidak perlu menambahkan policy peserta ke tabel undangan; peserta hanya boleh memanggil fungsi `join_team`.
4. Berikan kode undangan kepada fasilitator per kelompok melalui kanal terpisah dan aman.

**Jangan pernah menaruh service-role/secret key di HTML atau repository publik.** Frontend hanya memakai publishable key.

### Model akses dan batasan
- Peserta menggunakan sesi Auth anonim lalu bergabung dengan kode kelompok.
- RLS membatasi peserta melihat dan memperbarui progres kelompoknya sendiri.
- Leaderboard dapat dibaca peserta yang sudah terautentikasi.
- Skor tetap dikirim oleh aplikasi klien; untuk acara berisiko tinggi terhadap kecurangan, penilaian akhir sebaiknya diverifikasi fasilitator atau dipindahkan ke Edge Function.
- QR, transaksi, saldo, dan halaman phishing PEKA merupakan simulasi edukasi; bukan transaksi uang sungguhan atau situs phishing eksternal.
- Kurs Cross Border adalah angka ilustrasi.

## Jalankan lokal
Buka melalui server lokal atau hosting HTTPS. Kamera QR membutuhkan izin browser dan secure context; mode demo scan tetap tersedia.

## Deploy GitHub Pages
Workflow `.github/workflows/deploy-pages.yml` akan mengemas `index.html` dan deploy saat ada push ke branch `main`.

Pada GitHub, buka **Settings → Pages → Build and deployment → Source**, pilih **GitHub Actions**. Setelah workflow sukses, alamat publiknya:

https://kspmsuinsalatiga.github.io/edugenbi/
