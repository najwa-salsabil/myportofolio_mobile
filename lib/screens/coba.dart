import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ResponsiveHeyoFlutter()));
}

class ResponsiveHeyoFlutter extends StatelessWidget {
  const ResponsiveHeyoFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Responsive')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // LayoutBuilder mengecek lebar ruang yang tersedia (constraints.maxWidth)
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 1. Jika lebar layar >= 600 (Tablet / Desktop) -> Pakai ROW (Kiri - Kanan)
            if (constraints.maxWidth >= 600) {
              return Row(
                children: [
                  Expanded(child: _buildKotak('Heyo', Colors.amber)),
                  const SizedBox(width: 16), // Jarak horizontal
                  Expanded(child: _buildKotak('Flutter', Colors.blue)),
                ],
              );
            }
            // 2. Jika lebar layar < 600 (HP Portrait) -> Pakai COLUMN (Atas - Bawah)
            else {
              return Column(
                children: [
                  Expanded(child: _buildKotak('Heyo', Colors.amber)),
                  const SizedBox(height: 16), // Jarak vertikal
                  Expanded(child: _buildKotak('Flutter', Colors.blue)),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Helper widget berupa Container supaya lebih rapi dan tidak ditulis berulang
  Widget _buildKotak(String teks, Color warna) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: warna,
      alignment: Alignment.center,
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
