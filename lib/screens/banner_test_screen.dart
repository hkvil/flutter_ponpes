import 'package:flutter/material.dart';
import '../core/utils/banner_manager.dart';
import '../models/banner_config.dart';
import '../widgets/banner_widget.dart';

class BannerTestScreen extends StatefulWidget {
  const BannerTestScreen({super.key});

  @override
  State<BannerTestScreen> createState() => _BannerTestScreenState();
}

class _BannerTestScreenState extends State<BannerTestScreen> {
  final BannerManager _bannerManager = BannerManager();
  BannerConfig? _bannerConfig;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      print('🧪 [BANNER_TEST] Loading banners for taman-kanak-kanak...');
      final config = await _bannerManager.getBannerConfig(
        context,
        'profil',
        lembagaSlug: 'taman-kanak-kanak',
      );

      print('🧪 [BANNER_TEST] Loaded banner config:');
      print('   - Top Banner: ${config.topBannerUrl}');
      print('   - Bottom Banner: ${config.bottomBannerUrl}');
      print('   - Has Top: ${config.hasTopBanner}');
      print('   - Has Bottom: ${config.hasBottomBanner}');

      if (mounted) {
        setState(() {
          _bannerConfig = config;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('🧪 [BANNER_TEST] Error loading banners: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBanners,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _bannerConfig != null
                  ? BanneredContent(
                      bannerConfig: _bannerConfig!,
                      content: const SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Banner Test Content',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'This screen tests the banner system by loading banners for '
                              'the "taman-kanak-kanak" lembaga. If working correctly, you '
                              'should see banners above and below this content.',
                            ),
                            SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Banner Configuration:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Top Banner URL:'),
                                    Text('Bottom Banner URL:'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('No banner configuration loaded'),
                    ),
    );
  }
}
