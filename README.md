## Aplikasi Habit Tracker ini dirancang untuk pengguna dalam membangun dan memelihara kebiasaan positif melalui enam modul fungsional utama, mulai dari otentikasi hingga pelaporan statistik.

1. Awalnya, pengguna masuk ke Halaman Login, di mana mereka harus memasukkan username dan password. Validasi ketat diterapkan untuk memastikan kedua input tersebut tidak kosong sebelum tombol "Login" diaktifkan. Setelah berhasil masuk, status sesi akan disimpan secara lokal menggunakan SharedPreferences.

2. Inti dari aplikasi adalah Halaman Dashboard, yang memberikan ringkasan motivasi dan progres harian. Pengguna akan disambut dengan sapaan personal seperti "Halo, [username]!" dan tampilan tanggal hari ini. Dashboard ini menonjolkan Progress Bar yang menunjukkan persentase kebiasaan harian yang telah diselesaikan.
   
3. Bagian penting lainnya adalah Card Statistik yang menampilkan metrik tertinggi pengguna: Streak Terpanjang (total hari konsisten berturut-turut). Daftar kebiasaan yang wajib dilakukan hari ini juga tersedia di sini, lengkap dengan checkbox untuk menandai penyelesaian.

4. Untuk pengelolaan kebiasaan, terdapat Halaman Daftar Kebiasaan yang menampilkan semua kebiasaan yang pernah dibuat. Setiap entri mencakup nama kebiasaan, ikon visualnya, dan streak terkini. Penambahan dan pengeditan kebiasaan dilakukan pada Halaman Tambah/Edit Kebiasaan. Di sini, pengguna mengisi nama kebiasaan, memilih salah satu dari enam ikon yang tersedia (💧, 🏃, 📖, 🎵, 🧘, ☕), dan memilih salah satu dari empat warna (Biru, Hijau, Oranye, Ungu). Halaman ini juga dilengkapi fitur preview sebelum kebiasaan disimpan.

5. Untuk meninjau kinerja jangka panjang, Halaman Statistik menyediakan data komprehensif, mencakup total kebiasaan yang dibuat, kebiasaan dengan streak terpanjang saat ini, dan persentase penyelesaian kebiasaan secara mingguan, serta detail statistik per kebiasaan.
   
6. Terakhir, Halaman Profil berfungsi sebagai pusat informasi akun, menampilkan avatar pengguna, username, tanggal bergabung, dan total hari penggunaan aplikasi, serta tombol "Logout" untuk mengakhiri sesi dengan aman.

![Screenshot (Tampilan Login)](<Screenshot 2025-11-17 225646.png>)

![Screenshot (Tampilan Dashboard)](<Screenshot 2025-11-17 225759.png>)

![Screenshot (Tampilan Tambah Kebiasaan)](<Screenshot 2025-11-17 225902.png>)

