import 'package:flutter/material.dart';
import '../widgets/top_banner.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/top_bar.dart';
import '../widgets/section_header.dart';

class BlueprintIsciScreen extends StatelessWidget {
  const BlueprintIsciScreen({super.key});

  // Data statis blueprint ISCI
  static const List<Map<String, dynamic>> _blueprintData = [
    {
      'title': 'Master Plan Kampus ISCI',
      'image':
          'https://via.placeholder.com/400x300/FF5722/white?text=Master+Plan',
      'description':
          'Rencana induk pembangunan kampus ISCI dengan fasilitas lengkap.',
    },
    {
      'title': 'Gedung Rektorat ISCI',
      'image': 'https://via.placeholder.com/400x300/4CAF50/white?text=Rektorat',
      'description': 'Desain gedung rektorat dengan arsitektur modern Islami.',
    },
    {
      'title': 'Masjid Kampus ISCI',
      'image': 'https://via.placeholder.com/400x300/2196F3/white?text=Masjid',
      'description': 'Masjid kampus dengan kapasitas 3000 jamaah.',
    },
    {
      'title': 'Perpustakaan Pusat',
      'image':
          'https://via.placeholder.com/400x300/FF9800/white?text=Perpustakaan',
      'description': 'Perpustakaan modern dengan teknologi digital terkini.',
    },
    {
      'title': 'Gedung Fakultas',
      'image': 'https://via.placeholder.com/400x300/9C27B0/white?text=Fakultas',
      'description':
          'Kompleks gedung fakultas dengan ruang kuliah dan laboratorium.',
    },
    {
      'title': 'Asrama Mahasiswa',
      'image': 'https://via.placeholder.com/400x300/607D8B/white?text=Asrama',
      'description':
          'Asrama mahasiswa putra dan putri dengan fasilitas lengkap.',
    },
    {
      'title': 'Gedung Olahraga',
      'image': 'https://via.placeholder.com/400x300/795548/white?text=GOR',
      'description': 'Gedung olahraga multifungsi untuk berbagai kegiatan.',
    },
    {
      'title': 'Taman Kampus',
      'image': 'https://via.placeholder.com/400x300/8BC34A/white?text=Taman',
      'description': 'Taman kampus dengan konsep eco-friendly dan sustainable.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(title: 'BluePrint ISCI'),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SectionHeader(
                      title:
                          'Rencana Pembangunan Institut Studi Cendekia Islam (ISCI)',
                      fontSize: 16,
                      height: 32,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _blueprintData.length,
                      itemBuilder: (context, index) {
                        final blueprint = _blueprintData[index];
                        return _BlueprintCard(
                          title: blueprint['title'] as String,
                          image: blueprint['image'] as String,
                          description: blueprint['description'] as String,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
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

class _BlueprintCard extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const _BlueprintCard({
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar blueprint
          Expanded(
            flex: 3,
            child: Image.network(
              image,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.architecture,
                        size: 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Blueprint',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Info text
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
