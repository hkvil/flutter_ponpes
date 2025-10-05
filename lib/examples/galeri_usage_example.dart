// CONTOH PENGGUNAAN GALERI_SCREEN.DART
//
// File ini menunjukkan bagaimana menggunakan GaleriScreen dengan opsi 1 atau 2 kolom
// Anda bisa menyesuaikan crossAxisCount sesuai kebutuhan:
// - crossAxisCount: 1 = 1 kolom (gambar lebih besar)
// - crossAxisCount: 2 = 2 kolom (default, lebih banyak gambar per layar)

import 'package:flutter/material.dart';
import '../screens/galeri_screen.dart';
import '../models/lembaga_model.dart';

class GaleriExampleUsage {
  // Contoh 1: Galeri dengan 2 kolom (default)
  static Widget galeri2Kolom(BuildContext context) {
    return GaleriScreen(
      title: 'Galeri 2 Kolom',
      lembaga: _createSampleData(),
      crossAxisCount: 2, // 2 kolom
    );
  }

  // Contoh 2: Galeri dengan 1 kolom (gambar lebih besar)
  static Widget galeri1Kolom(BuildContext context) {
    return GaleriScreen(
      title: 'Galeri 1 Kolom',
      lembaga: _createSampleData(),
      crossAxisCount: 1, // 1 kolom
    );
  }

  // Sample data untuk demo
  static Lembaga _createSampleData() {
    return Lembaga(
      id: 999,
      documentId: 'sample',
      nama: 'Sample Galeri',
      slug: 'sample',
      images: [
        ImageItem(
          id: 1,
          title: 'Contoh Foto 1',
          desc: 'Deskripsi foto pertama',
          url: 'https://via.placeholder.com/400x300/FF5722/white?text=Foto+1',
        ),
        ImageItem(
          id: 2,
          title: 'Contoh Foto 2',
          desc: 'Deskripsi foto kedua',
          url: 'https://via.placeholder.com/400x300/4CAF50/white?text=Foto+2',
        ),
        ImageItem(
          id: 3,
          title: 'Contoh Foto 3',
          desc: 'Deskripsi foto ketiga',
          url: 'https://via.placeholder.com/400x300/2196F3/white?text=Foto+3',
        ),
      ],
    );
  }
}

/*
CARA PENGGUNAAN:

1. UNTUK GALERI 2 KOLOM (DEFAULT):
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GaleriScreen(
      title: 'Judul Galeri',
      lembaga: dataLembaga,
      crossAxisCount: 2, // atau bisa dihilangkan karena default
    ),
  ),
);

2. UNTUK GALERI 1 KOLOM (GAMBAR LEBIH BESAR):
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GaleriScreen(
      title: 'Judul Galeri',
      lembaga: dataLembaga,
      crossAxisCount: 1, // 1 kolom
    ),
  ),
);

KEUNTUNGAN 2 KOLOM:
- Lebih banyak gambar terlihat dalam satu layar
- Cocok untuk overview/daftar foto
- Default behavior yang sudah familiar

KEUNTUNGAN 1 KOLOM:
- Gambar lebih besar dan detail
- Lebih fokus per foto
- Cocok untuk showcase/portfolio
- childAspectRatio otomatis menjadi 1.2 (lebih landscape)
*/
