import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/detail_layout.dart';
import 'package:pesantren_app/widgets/banner_widget.dart';
import 'package:pesantren_app/models/banner_config.dart';
import '../widgets/responsive_wrapper.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../repository/lembaga_repository.dart';
import '../models/lembaga_model.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final List<String> menuItems;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.menuItems,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final LembagaRepository _repository = LembagaRepository();
  Lembaga? _cachedLembaga;
  bool _isLoadingData = false;
  String? _lembagaSlug;
  String? _loadingError;

  @override
  void initState() {
    super.initState();
    _preloadLembagaData();
  }

  Future<void> _preloadLembagaData() async {
    // Get slug dari title
    _lembagaSlug = MenuSlugMapper.getSlugByMenuTitle(widget.title);

    if (_lembagaSlug != null) {
      setState(() {
        _isLoadingData = true;
        _loadingError = null;
      });

      try {
        print(
            '🔄 Pre-loading data untuk: ${widget.title} (slug: $_lembagaSlug)');

        _cachedLembaga = await _repository.fetchBySlug(_lembagaSlug!);

        if (_cachedLembaga != null) {
          print('✅ Pre-load berhasil: ${_cachedLembaga!.nama}');
          print('📸 Images: ${_cachedLembaga!.images.length} foto');
          print('🎥 Videos: ${_cachedLembaga!.videos.length} video');
          print(
              '📄 Profil: ${_cachedLembaga!.hasProfilContent() ? "Ada" : "Kosong"}');
          print(
              '📋 Program Kerja: ${_cachedLembaga!.hasProgramKerjaContent() ? "Ada" : "Kosong"}');
        } else {
          print('❌ Pre-load gagal: Data tidak ditemukan');
          _loadingError = 'Data tidak ditemukan';
        }
      } catch (e) {
        print('❌ Pre-load error: $e');
        _loadingError = e.toString();
        _cachedLembaga = null;
      }

      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  /// Create BannerConfig from cached lembaga data
  BannerConfig _createBannerConfig() {
    if (_cachedLembaga != null) {
      return BannerConfig.fromLembaga(
        _cachedLembaga!.topBanner,
        _cachedLembaga!.botBanner,
      );
    }
    // Return empty banner config if no cached data
    return const BannerConfig();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            // Use BannerWidget with API data if available, fallback to TopBanner as placeholder
            (_cachedLembaga != null && _createBannerConfig().hasTopBanner)
                ? BannerWidget(
                    bannerConfig: _createBannerConfig(),
                    isTopBanner: true,
                    height: 150,
                  )
                : TopBanner(
                    assetPath: 'assets/banners/top.png',
                    height: 150,
                  ),

            // Loading indicator untuk pre-load
            if (_isLoadingData)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Memuat data ${widget.title}...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Error indicator jika ada error loading
            if (_loadingError != null && !_isLoadingData)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gagal memuat data online',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Menggunakan mode offline',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DetailLayout(
                  title: widget.title,
                  menuItems: widget.menuItems,
                  lembagaSlug: _lembagaSlug,
                  cachedLembaga: _cachedLembaga, // Pass cached data
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            (_cachedLembaga != null && _createBannerConfig().hasBottomBanner)
                ? BannerWidget(
                    bannerConfig: _createBannerConfig(),
                    isTopBanner: false,
                    height: 100,
                  )
                : BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}
