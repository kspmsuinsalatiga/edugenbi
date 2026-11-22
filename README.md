# GENBI MISSION — Kenal BI, Main, dan Buktikan!

GENBI MISSION adalah web companion pembelajaran untuk 100 siswa SMA (10 kelompok), dengan empat pos utama dan Final Challenge.

## Jalur akses
- **Menu peran:** https://kspmsuinsalatiga.github.io/edugenbi/
- **Peserta:** https://kspmsuinsalatiga.github.io/edugenbi/participant.html
- **Fasilitator:** https://kspmsuinsalatiga.github.io/edugenbi/facilitator.html

## Alur akses
- Hanya ada **satu akun fasilitator tetap**, yaitu `genbiedu@gmail.com`. Tidak tersedia pendaftaran fasilitator.
- Peserta tidak perlu membuat email/password. Halaman peserta membuat sesi anonim, lalu meminta nama lengkap, sekolah, dan kelompok yang dituju.
- Status awal pendaftaran adalah **menunggu persetujuan**. Peserta baru dapat membuka misi setelah fasilitator menyetujui.
- Fasilitator dapat memindahkan peserta ke kelompok yang tersedia; kapasitas maksimal 10 peserta per kelompok. Pendaftaran juga dapat ditolak dan diperbaiki.
- Petunjuk membuat satu akun Auth fasilitator: [supabase/README.md](supabase/README.md) dan [SQL verifikasi akun](supabase/facilitator-setup.sql).

## Empat pos
1. **ARIS:** QRIS, MPM statis/dinamis, CPM dan konektivitas QR Antarnegara.
2. **PEKA:** investigasi tiga chat WhatsApp simulasi dan keamanan konsumen.
3. **EKONOMI CERDAS:** permainan target lempar bola fisik, 3 kesempatan, kategori isu ekonomi.
4. **KE-BANK SENTRALAN:** BI Control Room dengan kasus inflasi/stabilitas harga, sistem pembayaran, Rupiah, dan makroprudensial.
5. **Final Challenge:** 15 pertanyaan bergaya Kahoot.

## QR latihan
Gambar QRIS Indonesia, PromptPay Thailand, dan DuitNow QR Malaysia dipakai sebagai kartu visual. QR ini dapat merupakan contoh aktif di lingkungan aslinya. Jangan pindai memakai aplikasi bank/e-wallet atau membayar. Website mengabaikan isi QR yang terdeteksi, tidak membuka tautan, tidak meneruskan payload, dan tidak mengirim data QR ke Supabase. Saldo merchant hanya virtual dan tidak ada payment gateway.

## Deploy
GitHub Actions workflow `.github/workflows/deploy-pages.yml` mem-publish tiga halaman dan folder aset. Di GitHub buka **Settings → Pages → Build and deployment** lalu pilih **GitHub Actions** sebagai Source.
