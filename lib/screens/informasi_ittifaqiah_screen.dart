import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import 'package:pesantren_app/widgets/top_bar.dart';
import 'package:pesantren_app/widgets/reusable_list_tile.dart';

import 'berita_al_ittifaqiah_screen.dart';
import 'statistics_screen.dart';
import 'galeri_screen.dart';
import 'blueprint_isci__screen.dart';
import '../models/lembaga_model.dart';
import '../models/informasi_al_ittifaqiah_model.dart';
import '../providers/informasi_al_ittifaqiah_provider.dart';
import '../core/config/markdown_config.dart';

class InformasiIttifaqiahScreen extends StatefulWidget {
  const InformasiIttifaqiahScreen({super.key});

  @override
  State<InformasiIttifaqiahScreen> createState() =>
      _InformasiIttifaqiahScreenState();
}

class _InformasiIttifaqiahScreenState extends State<InformasiIttifaqiahScreen> {
  InformasiAlIttifaqiah? _informasiData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final provider = context.read<InformasiAlIttifaqiahProvider>();
      final data = await provider.fetchInformasi(forceRefresh: true);
      final state = provider.informasiState;

      // Debug print untuk melihat data yang dimuat
      print('DEBUG: Data loaded successfully');
      print('DEBUG: Profil available: ${data?.hasProfilContent() ?? false}');
      print('DEBUG: Galeri Tamu: ${data?.galeriTamu.length ?? 0} items');
      print(
          'DEBUG: Galeri Luar Negeri: ${data?.galeriLuarNegeri.length ?? 0} items');
      print('DEBUG: BluePrint ISCI: ${data?.bluePrintISCI.length ?? 0} items');
      print('DEBUG: News: ${data?.news.length ?? 0} items');
      print('DEBUG: Santri: ${data?.santri.length ?? 0} records');
      print('DEBUG: SDM: ${data?.sdm.length ?? 0} records');
      print('DEBUG: Alumni: ${data?.alumni.length ?? 0} records');

      setState(() {
        _informasiData = data;
        _isLoading = false;
        _errorMessage = state.errorMessage;
      });
    } catch (e) {
      print('DEBUG: Error loading data: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  // Convert GaleriItem to ImageItem untuk kompatibilitas dengan GaleriScreen
  List<ImageItem> _convertGaleriToImageItems(List<GaleriItem> galeriItems) {
    return galeriItems
        .map((galeri) => ImageItem(
              id: galeri.id,
              title: galeri.title,
              desc: galeri.desc,
              date: galeri.date,
              url: galeri.imageUrl,
            ))
        .toList();
  }

  // Create Lembaga object untuk kompatibilitas dengan GaleriScreen
  Lembaga _createLembagaFromGaleri(
      List<GaleriItem> galeriItems, String nama, String slug) {
    return Lembaga(
      id: 1,
      documentId: slug,
      nama: nama,
      slug: slug,
      images: _convertGaleriToImageItems(galeriItems),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadData,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            ReusableListTileWidget(
                              value: null,
                              titleText: 'Profil Al-Ittifaqiah',
                              onTap: () {
                                if (_informasiData?.hasProfilContent() ==
                                    true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _ProfilScreen(
                                        profilMd: _informasiData!.profilMd!,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Data profil tidak tersedia'),
                                    ),
                                  );
                                }
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
                                final santriData = _informasiData?.santri ?? [];
                                print(
                                    'DEBUG: Santri data: ${santriData.length} records');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StatisticsScreen.santri(santriData),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            ReusableListTileWidget(
                              value: null,
                              titleText: 'Jumlah SDM Al-Ittifaqiah',
                              onTap: () {
                                final sdmData = _informasiData?.sdm ?? [];
                                print(
                                    'DEBUG: SDM data: ${sdmData.length} records');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StatisticsScreen.sdm(sdmData),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            ReusableListTileWidget(
                              value: null,
                              titleText: 'Jumlah Alumni Al-Ittifaqiah',
                              onTap: () {
                                final alumniData = _informasiData?.alumni ?? [];
                                print(
                                    'DEBUG: Alumni data: ${alumniData.length} records');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StatisticsScreen.alumni(alumniData),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            ReusableListTileWidget(
                              value: null,
                              titleText: 'Galeri Luar Negeri',
                              onTap: () {
                                final galeriData =
                                    _informasiData?.galeriLuarNegeri ?? [];
                                print(
                                    'DEBUG: Galeri Luar Negeri data: ${galeriData.length} items');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GaleriScreen(
                                      title: 'Galeri Luar Negeri Al-Ittifaqiah',
                                      lembaga: _createLembagaFromGaleri(
                                        galeriData,
                                        'Luar Negeri Al-Ittifaqiah',
                                        'galeri-luar-negeri',
                                      ),
                                      crossAxisCount: 1,
                                      showTabs: false,
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
                                final galeriData =
                                    _informasiData?.galeriTamu ?? [];
                                print(
                                    'DEBUG: Galeri Tamu data: ${galeriData.length} items');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GaleriScreen(
                                      title: 'Galeri Tamu',
                                      lembaga: _createLembagaFromGaleri(
                                        galeriData,
                                        'Tamu',
                                        'galeri-tamu',
                                      ),
                                      crossAxisCount: 1,
                                      showTabs: false,
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
                                final bluePrintData =
                                    _informasiData?.bluePrintISCI ?? [];
                                print(
                                    'DEBUG: BluePrint ISCI data: ${bluePrintData.length} items');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlueprintIsciScreen(
                                      blueprintItems: bluePrintData,
                                    ),
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
  final String profilMd;
  const _ProfilScreen({required this.profilMd});

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
                    // Display markdown content from API with proper formatting
                    MarkdownBlock(
                      data: profilMd,
                      config: AppMarkdownConfig.responsiveConfig(context),
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
}
