import 'package:flutter/material.dart';
import '../widgets/top_banner.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/top_bar.dart';

class BeritaAlIttifaqiahScreen extends StatelessWidget {
  const BeritaAlIttifaqiahScreen({super.key});

  // Data statis berita
  static const List<Map<String, dynamic>> _beritaData = [
    {
      'title':
          'Yayasan Ponpes Al-Islam Kemuja Bangka Jalin Silaturahmi dan Kerja Sama dengan Al-Ittifaqiah Indralaya',
      'thumbnail':
          'https://via.placeholder.com/300x200/4CAF50/white?text=Berita+1',
      'date': '14 Agu 2025',
    },
    {
      'title':
          'Ketua KPU Tinjau Pembangunan Dapur Makan Bergizi Gratis di Ponpes Al-Ittifaqiah Indralaya',
      'thumbnail':
          'https://via.placeholder.com/300x200/2196F3/white?text=Berita+2',
      'date': '12 Agu 2025',
    },
    {
      'title':
          'IAIQI Indralaya Luncurkan Perpustakaan Al-Quran Digital, Hadirkan 7.400 Koleksi',
      'thumbnail':
          'https://via.placeholder.com/300x200/FF9800/white?text=Berita+3',
      'date': '10 Agu 2025',
    },
    {
      'title': 'Wisuda Tahfidz Al-Quran Santri Al-Ittifaqiah Indralaya',
      'thumbnail':
          'https://via.placeholder.com/300x200/9C27B0/white?text=Berita+4',
      'date': '8 Agu 2025',
    },
    {
      'title': 'Pelantikan Pengurus OSIS Periode 2025-2026',
      'thumbnail':
          'https://via.placeholder.com/300x200/F44336/white?text=Berita+5',
      'date': '5 Agu 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(title: 'Berita Al-Ittifaqiah'),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _beritaData.length,
                itemBuilder: (context, index) {
                  final berita = _beritaData[index];
                  return _BeritaCard(
                    title: berita['title'] as String,
                    thumbnail: berita['thumbnail'] as String,
                    date: berita['date'] as String,
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}

class _BeritaCard extends StatelessWidget {
  final String title;
  final String thumbnail;
  final String date;

  const _BeritaCard({
    required this.title,
    required this.thumbnail,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail di atas
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              thumbnail,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          // Judul dan tanggal di bawah
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
