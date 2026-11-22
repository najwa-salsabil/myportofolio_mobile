# MyPortfolio Mobile

Aplikasi mobile portofolio pribadi yang dibangun dengan **Flutter** untuk mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fasilkom UI, Semester Gasal 2026/2027. Aplikasi ini adalah versi mobile dari website portofolio Django yang sudah dikembangkan pada paruh pertama semester, dan nantinya akan dihubungkan dengan REST API dari backend tersebut.

**Nama:** Najwa Salsabil
**NPM:** 2506588701

## Fitur Saat Ini

- Halaman utama dengan tiga kartu identitas (NPM, Name, Class)
- Tiga tombol aksi (Lihat Proyek, Tambah Proyek, Logout) dengan warna latar yang berbeda
- SnackBar yang muncul setiap kali tombol ditekan

## Cara Menjalankan

Pastikan Flutter SDK sudah terpasang (cek dengan `flutter doctor`).

```
git clone https://github.com/<username>/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
```

Untuk menjalankan di emulator atau perangkat Android, gunakan `flutter run` tanpa opsi `-d chrome`.

## Struktur Kode

- `lib/main.dart`: titik masuk aplikasi, berisi `MyApp` dan konfigurasi tema
- `lib/menu.dart`: halaman utama (`MyHomePage`), model `ItemHomepage`, serta widget `InfoCard` dan `ItemCard`

## Jawaban Pertanyaan Reflektif

### Tugas 7

1. **Widget tree** adalah struktur hierarki berbentuk pohon yang menggambarkan susunan seluruh widget dalam aplikasi Flutter. Setiap elemen yang tampil di layar adalah widget, dan setiap widget berada di dalam widget lain sampai ke widget paling atas (root). Hubungan **parent-child** bekerja lewat properti `child` (untuk satu anak) atau `children` (untuk banyak anak). Parent menentukan batasan ukuran dan posisi anaknya, sedangkan child menentukan ukurannya sendiri di dalam batasan itu. Pada proyek ini misalnya, `Scaffold` menjadi parent dari `AppBar` dan `Padding`, lalu `Padding` membungkus `Column`, dan `Column` menampung `Row` berisi tiga `InfoCard`. Data seperti tema juga mengalir dari atas ke bawah, sehingga widget di bawah bisa mengaksesnya lewat `Theme.of(context)`.

2. Widget yang digunakan dalam proyek ini:
   - `MaterialApp`: widget root yang menyediakan tema, judul, dan halaman awal aplikasi.
   - `Scaffold`: kerangka dasar halaman yang menyediakan slot untuk AppBar dan body.
   - `AppBar`: bar di bagian atas halaman yang menampilkan judul aplikasi.
   - `Text`: menampilkan teks.
   - `Padding`: memberi jarak di sekeliling widget anaknya.
   - `Column`: menyusun widget anak secara vertikal.
   - `Row`: menyusun widget anak secara horizontal, dipakai untuk menjajarkan tiga `InfoCard`.
   - `SizedBox`: memberi jarak kosong dengan ukuran tertentu antar-widget.
   - `Center`: menempatkan widget anak di tengah.
   - `GridView.count`: menampilkan widget anak dalam bentuk kisi dengan jumlah kolom tetap, dipakai untuk tombol menu.
   - `Card`: kartu bergaya Material dengan sudut membulat dan bayangan.
   - `Container`: kotak pembungkus yang bisa diatur lebar dan padding-nya.
   - `Material`: memberi warna latar dan bentuk pada kartu tombol, sekaligus menjadi permukaan untuk efek ripple.
   - `InkWell`: membuat area yang bisa ditekan dan menampilkan efek ripple.
   - `Icon`: menampilkan ikon dari kumpulan ikon Material.
   - `SnackBar`: pesan singkat yang muncul di bagian bawah layar, ditampilkan melalui `ScaffoldMessenger`.
   - `MyApp`, `MyHomePage`, `InfoCard`, `ItemCard`: widget buatan sendiri. `MyApp` adalah root aplikasi, `MyHomePage` adalah halaman utama, `InfoCard` menampilkan satu data identitas, dan `ItemCard` menampilkan satu tombol aksi.

3. `MaterialApp` berfungsi sebagai pembungkus utama yang menyiapkan semua kebutuhan dasar aplikasi bergaya Material Design. Widget ini mengatur tema (`ThemeData`), judul aplikasi, halaman awal lewat properti `home`, sistem navigasi antarhalaman (`Navigator`), dan dukungan lokalisasi. `MaterialApp` umumnya dijadikan **root widget** karena banyak widget Material di bawahnya bergantung pada hal yang ia sediakan. Contohnya, `Theme.of(context)` dan `ScaffoldMessenger.of(context)` yang dipakai di proyek ini hanya bisa menemukan datanya kalau ada `MaterialApp` di atasnya dalam widget tree. Dengan menaruhnya di paling atas, seluruh halaman otomatis memakai tema dan navigasi yang sama.

4. `StatelessWidget` adalah widget yang tampilannya tidak berubah setelah dibuat. Semua datanya bersifat `final` dan tampilannya hanya bergantung pada konfigurasi yang diterima dari parent. `StatefulWidget` adalah widget yang memiliki objek `State` terpisah untuk menyimpan data yang bisa berubah selama aplikasi berjalan. Ketika data itu diubah melalui `setState()`, Flutter menjalankan ulang method `build` sehingga tampilan ikut diperbarui. **`StatelessWidget`** sebaiknya dipilih untuk tampilan statis seperti teks, ikon, atau halaman menu pada proyek ini yang isinya tetap. **`StatefulWidget`** dipakai ketika tampilan harus merespons perubahan, misalnya counter, isian form, checkbox, animasi, atau data yang dimuat dari internet.

5. `BuildContext` adalah objek yang merepresentasikan **posisi sebuah widget di dalam widget tree**. Objek ini penting karena menjadi cara widget untuk mencari informasi dari widget di atasnya (ancestor), seperti tema, ukuran layar, dan navigator. Di dalam method `build`, `BuildContext` diterima sebagai parameter dan dipakai untuk memanggil method berpola `.of(context)`. Pada proyek ini penggunaannya antara lain `Theme.of(context).colorScheme.primary` untuk mengambil warna tema, `MediaQuery.of(context).size.width` untuk mengambil lebar layar, dan `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar`.

6. **Hot reload** menyuntikkan kode yang baru diubah ke aplikasi yang sedang berjalan lalu membangun ulang widget tree **tanpa menghapus state**. Hasil perubahan langsung terlihat dalam waktu sangat singkat dan posisi aplikasi (misalnya nilai counter atau halaman yang sedang dibuka) tetap bertahan. **Hot restart** memuat ulang seluruh kode dan menjalankan aplikasi dari awal, sehingga **state kembali ke kondisi semula**, tetapi tetap lebih cepat daripada menghentikan lalu menjalankan ulang aplikasi. Hot reload tidak cukup ketika perubahan menyangkut kode yang hanya dijalankan sekali di awal, seperti isi fungsi `main()`, method `initState()`, serta nilai awal variabel global dan static. Pada kasus itu perlu hot restart. **Full restart** (menghentikan aplikasi lalu `flutter run` lagi) diperlukan ketika perubahan ada di luar kode Dart, misalnya menambah dependensi di `pubspec.yaml`, menambah aset, atau mengubah kode native di folder `android/` dan `ios/`.

AI Disclosure: Tidak Menggunakan AI.

### Tugas 8

1. **`Navigator.push()`** menambahkan route baru di atas stack, sehingga halaman sebelumnya tetap tersimpan di bawahnya dan pengguna bisa kembali dengan tombol Back. **`Navigator.pushReplacement()`** mengganti route paling atas dengan route baru, sehingga halaman lama dihapus dari stack dan tidak bisa dikembalikan lewat tombol Back. **`Navigator.pop()`** menghapus route paling atas dari stack lalu menampilkan route di bawahnya, misalnya saat menutup dialog ringkasan dengan tombol Tutup. Untuk membuka formulir dari kartu aksi, saya menggunakan `Navigator.push()` agar pengguna tetap bisa kembali ke halaman utama dengan tombol Back bawaan perangkat atau browser. Opsi **Home** di drawer menggunakan `Navigator.pushReplacement()` untuk mengganti halaman formulir yang sedang dibuka dengan `MyHomePage`. Dengan cara ini, stack tidak terus bertambah setiap kali pengguna berpindah halaman lewat drawer.

2. **`Scaffold`** menyediakan kerangka halaman yang sama di setiap layar, yaitu slot untuk `appBar`, `drawer`, dan `body`. **`AppBar`** menampilkan judul halaman di posisi dan gaya yang konsisten, sedangkan **`Drawer`** yang sama (`LeftDrawer`) dipasang di halaman utama, formulir proyek, dan formulir edukasi, sehingga menu navigasi selalu bisa diakses dari mana pun dengan tampilan yang identik. Karena drawer ditulis sekali di `lib/widgets/left_drawer.dart`, perubahan pada menu cukup dilakukan di satu tempat. Contoh penggunaan warna tema di lebih dari satu halaman adalah `Theme.of(context).colorScheme.primary`, yang saya pakai sebagai warna latar `AppBar` di halaman utama, formulir proyek, dan formulir edukasi, serta sebagai warna tombol Simpan. Warna ini berasal dari `ColorScheme.fromSeed(seedColor: Colors.indigo)` di `main.dart`, jadi jika warna dasar diganti, seluruh halaman ikut berubah.

3. Formulir disusun dalam satu **`Column`** vertikal karena pengguna biasanya mengisi formulir dari atas ke bawah, dan susunan ini paling mudah dibaca di layar ponsel yang sempit. Field tanggal mulai dan tanggal selesai diletakkan berdampingan dalam **`Row`** dengan **`Expanded`** karena keduanya saling berkaitan sebagai satu periode, dan `Expanded` membagi lebar layar secara rata agar keduanya tidak melebihi layar. **Widget pengatur jarak** seperti `Padding` memberi ruang di sekitar setiap field agar tidak saling menempel dan area sentuhnya tetap nyaman. **Widget penggulir** `SingleChildScrollView` membuat seluruh isi formulir bisa digulir ketika tingginya melebihi layar, misalnya di layar sempit atau saat papan ketik muncul dan menutupi setengah layar. Tanpa widget ini, field di bagian bawah dan tombol Simpan bisa tidak terjangkau dan Flutter akan menampilkan error overflow.

4. **`GlobalKey<FormState>`** adalah kunci yang terhubung ke widget `Form`, sehingga kode di luar field bisa mengakses state formulir melalui `_formKey.currentState`. **`validator`** adalah fungsi pada setiap field yang memeriksa nilai input dan mengembalikan pesan error jika tidak valid, atau `null` jika valid. Saat tombol Simpan ditekan, **`validate()`** menjalankan seluruh `validator` di dalam form sekaligus, menampilkan pesan error di bawah field yang bermasalah, lalu mengembalikan `true` hanya jika semua field lolos. Dialog ringkasan baru ditampilkan setelah `validate()` bernilai `true`. Contoh nilai yang ditolak adalah IPK `5`. Field IPK sudah memakai papan ketik angka (`TextInputType.numberWithOptions`), tetapi papan ketik hanya membatasi tombol yang ditampilkan dan tidak memeriksa makna nilainya. Pengguna tetap bisa mengetik `5` yang berada di luar rentang 0.00 sampai 4.00, dan di Chrome papan ketik fisik bahkan tetap bisa mengetik huruf. Begitu juga isian berupa spasi saja tetap lolos dari jenis input apa pun, sehingga validasi tambahan seperti pengecekan rentang angka dan `value.trim().isEmpty` tetap diperlukan.

AI Disclosure: Tidak Menggunakan AI.