import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import 'package:pesantren_app/widgets/top_bar.dart';
import 'package:pesantren_app/widgets/reusable_list_tile.dart';

import 'berita_al_ittifaqiah_screen.dart';
import 'statistics_screen.dart';
import 'galeri_screen.dart';
import 'blueprint_isci_screen.dart';
import '../models/lembaga_model.dart';

class InformasiIttifaqiahScreen extends StatelessWidget {
  const InformasiIttifaqiahScreen({super.key});

  // Static data untuk Galeri Luar Negeri
  static Lembaga _createGaleriLuarNegeriData() {
    return Lembaga(
      id: 1,
      documentId: 'galeri-luar-negeri',
      nama: 'Galeri Luar Negeri Al-Ittifaqiah',
      slug: 'galeri-luar-negeri',
      images: [
        ImageItem(
          id: 1,
          title: 'Kunjungan ke Universitas Al-Azhar, Mesir',
          desc:
              'Delegasi santri berkunjung ke Universitas Al-Azhar untuk studi banding pendidikan Islam.',
          url: 'https://via.placeholder.com/400x300/FF5722/white?text=Al-Azhar',
        ),
        ImageItem(
          id: 2,
          title: 'Program Pertukaran Pelajar Malaysia',
          desc:
              'Santri mengikuti program pertukaran pelajar di Malaysia selama 6 bulan.',
          url: 'https://via.placeholder.com/400x300/4CAF50/white?text=Malaysia',
        ),
        ImageItem(
          id: 3,
          title: 'Konferensi Pendidikan Islam Asia Tenggara',
          desc:
              'Perwakilan Al-Ittifaqiah menghadiri konferensi pendidikan Islam di Thailand.',
          url:
              'https://via.placeholder.com/400x300/2196F3/white?text=Konferensi',
        ),
        ImageItem(
          id: 4,
          title: 'Kunjungan ke Masjid Nabawi, Madinah',
          desc:
              'Jamaah haji dan umrah dari Al-Ittifaqiah berkunjung ke Masjid Nabawi.',
          url: 'https://via.placeholder.com/400x300/9C27B0/white?text=Madinah',
        ),
        ImageItem(
          id: 5,
          title: 'Seminar Internasional Tahfidz Al-Quran',
          desc:
              'Menghadiri seminar internasional tahfidz di Brunei Darussalam.',
          url: 'https://via.placeholder.com/400x300/FF9800/white?text=Tahfidz',
        ),
        ImageItem(
          id: 6,
          title: 'Studi Banding ke Pesantren Gontor',
          desc:
              'Tim pengembangan kurikulum melakukan studi banding ke Pondok Modern Darussalam Gontor.',
          url: 'https://via.placeholder.com/400x300/607D8B/white?text=Gontor',
        ),
      ],
    );
  }

  // Static data untuk Galeri Tamu
  static Lembaga _createGaleriTamuData() {
    return Lembaga(
      id: 2,
      documentId: 'galeri-tamu',
      nama: 'Galeri Tamu VIP Al-Ittifaqiah',
      slug: 'galeri-tamu',
      images: [
        ImageItem(
          id: 1,
          title: 'Kunjungan Menteri Agama RI',
          desc:
              'Menteri Agama RI berkunjung untuk meresmikan pembangunan masjid baru.',
          url: 'https://via.placeholder.com/400x300/F44336/white?text=Menag+RI',
        ),
        ImageItem(
          id: 2,
          title: 'Audiensi dengan Gubernur Sumsel',
          desc:
              'Gubernur Sumatera Selatan melakukan kunjungan kerja dan audiensi dengan pimpinan pesantren.',
          url: 'https://via.placeholder.com/400x300/E91E63/white?text=Gubernur',
        ),
        ImageItem(
          id: 3,
          title: 'Kunjungan Dubes Arab Saudi',
          desc:
              'Duta Besar Arab Saudi untuk Indonesia mengunjungi pesantren dalam rangka kerjasama pendidikan.',
          url:
              'https://via.placeholder.com/400x300/9C27B0/white?text=Dubes+Saudi',
        ),
        ImageItem(
          id: 4,
          title: 'Silaturahmi dengan Ulama Malaysia',
          desc:
              'Delegasi ulama dari Malaysia berkunjung untuk mempererat hubungan ukhuwah islamiyah.',
          url: 'https://via.placeholder.com/400x300/2196F3/white?text=Ulama+MY',
        ),
        ImageItem(
          id: 5,
          title: 'Kunjungan Rektor UIN Jakarta',
          desc:
              'Rektor UIN Syarif Hidayatullah Jakarta berkunjung untuk kerjasama akademik.',
          url:
              'https://via.placeholder.com/400x300/4CAF50/white?text=Rektor+UIN',
        ),
        ImageItem(
          id: 6,
          title: 'Audiensi dengan Ketua MUI Sumsel',
          desc:
              'Ketua MUI Sumatera Selatan melakukan kunjungan silaturahmi dan pembinaan.',
          url:
              'https://via.placeholder.com/400x300/FF9800/white?text=MUI+Sumsel',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(title: 'Informasi Al-Ittifaqiah'),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Profil Al-Ittifaqiah',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const _ProfilScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Berita Al-Ittifaqiah',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BeritaAlIttifaqiahScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Jumlah Santri Al-Ittifaqiah',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsScreen.santri(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Jumlah SDM Al-Ittifaqiah',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsScreen.sdm(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Jumlah Alumni Al-Ittifaqiah',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsScreen.alumni(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Galeri Luar Negeri',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GaleriScreen(
                            title: 'Galeri Luar Negeri Al-Ittifaqiah',
                            lembaga: _createGaleriLuarNegeriData(),
                            crossAxisCount: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'Galeri Tamu',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GaleriScreen(
                            title: 'Galeri Tamu VIP Al-Ittifaqiah',
                            lembaga: _createGaleriTamuData(),
                            crossAxisCount: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ReusableListTileWidget(
                    value: null,
                    titleText: 'BluePrint ISCI',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BlueprintIsciScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
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

class _ProfilScreen extends StatelessWidget {
  const _ProfilScreen();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(title: 'Profil Al-Ittifaqiah'),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Sejarah Singkat',
                      'Pondok Pesantren Al-Ittifaqiah Indralaya didirikan pada tahun 1967 oleh K.H. Abdullah Syafi\'ie dengan visi mencetak generasi Muslim yang berakhlak mulia, berilmu, dan bermanfaat bagi umat.',
                    ),
                    _buildSection(
                      'Visi',
                      'Menjadi lembaga pendidikan Islam terdepan yang menghasilkan ulama dan cendekiawan Muslim yang berakhlak mulia, berilmu luas, dan berwawasan global.',
                    ),
                    _buildSection(
                      'Misi',
                      '• Menyelenggarakan pendidikan Islam yang komprehensif dan berkualitas\n'
                          '• Mengembangkan potensi santri dalam bidang akademik dan non-akademik\n'
                          '• Membangun karakter santri yang berakhlak mulia dan berjiwa kepemimpinan\n'
                          '• Menjalin kerjasama dengan berbagai lembaga dalam dan luar negeri',
                    ),
                    _buildSection(
                      'Lokasi',
                      'Jl. Lintas Timur KM. 32, Indralaya, Kabupaten Ogan Ilir, Sumatera Selatan 30662, Indonesia',
                    ),
                    _buildSection(
                      'Fasilitas Utama',
                      '• Masjid Agung Al-Ittifaqiah\n'
                          '• Asrama santri putra dan putri\n'
                          '• Gedung perkuliahan IAIQI\n'
                          '• Perpustakaan modern\n'
                          '• Laboratorium komputer dan bahasa\n'
                          '• Klinik kesehatan\n'
                          '• Koperasi dan BMT\n'
                          '• Lapangan olahraga\n'
                          '• Aula serbaguna',
                    ),
                    _buildSection(
                      'Prestasi Terkini',
                      '• Juara 1 Lomba Tahfidz Nasional 2024\n'
                          '• Akreditasi A untuk semua jenjang pendidikan\n'
                          '• Kerjasama dengan 15+ universitas dalam dan luar negeri\n'
                          '• Alumni tersebar di berbagai profesi strategis\n'
                          '• Penghargaan Pesantren Terbaik Sumsel 2023',
                    ),
                    const SizedBox(height: 16),
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

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
