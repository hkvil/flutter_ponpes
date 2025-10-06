import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/banner_config.dart';
import '../../providers/lembaga_provider.dart';

class BannerManager {
  static final BannerManager _instance = BannerManager._internal();
  factory BannerManager() => _instance;
  BannerManager._internal();

  // Cache untuk menyimpan banner configs per lembaga
  final Map<String, BannerConfig> _bannerCache = {};

  /// Get banner config untuk menu tertentu
  Future<BannerConfig> getBannerConfig(
    BuildContext context,
    String menuKey, {
    String? lembagaSlug,
  }) async {
    // Untuk banner yang sama di semua menu lembaga, kita cuma perlu lembagaSlug
    final cacheKey = lembagaSlug ?? 'default';

    // Cek cache dulu
    if (_bannerCache.containsKey(cacheKey)) {
      return _bannerCache[cacheKey]!;
    }

    try {
      // Jika ada lembagaSlug, ambil banner dari API
      if (lembagaSlug != null) {
        final provider = Provider.of<LembagaProvider>(context, listen: false);
        final lembaga = await provider.fetchBySlug(lembagaSlug);
        if (lembaga != null) {
          // Buat banner config dari topBanner dan botBanner lembaga
          final bannerConfig = BannerConfig.fromLembaga(
            lembaga.topBanner,
            lembaga.botBanner,
            // TODO: Jika ingin redirect URLs, bisa ditambahkan di model Lembaga
          );
          _bannerCache[cacheKey] = bannerConfig;
          return bannerConfig;
        }
      }

      // Fallback ke default config (no banner)
      const defaultConfig = BannerConfig();
      _bannerCache[cacheKey] = defaultConfig;
      return defaultConfig;
    } catch (e) {
      print('Error fetching banner config for lembaga $lembagaSlug: $e');
      // Return default config on error
      const defaultConfig = BannerConfig();
      _bannerCache[cacheKey] = defaultConfig;
      return defaultConfig;
    }
  }

  /// Get banner config secara synchronous dari cache atau default
  BannerConfig getBannerConfigSync(String menuKey, {String? lembagaSlug}) {
    // Untuk banner yang sama di semua menu lembaga, kita cuma perlu lembagaSlug
    final cacheKey = lembagaSlug ?? 'default';

    return _bannerCache[cacheKey] ?? const BannerConfig();
  }

  /// Pre-load banner config dari lembaga (topBanner & botBanner)
  Future<void> preloadBannerConfigs(
      BuildContext context, String lembagaSlug) async {
    try {
      final provider = Provider.of<LembagaProvider>(context, listen: false);
      final lembaga = await provider.fetchBySlug(lembagaSlug);
      if (lembaga != null) {
        // Buat banner config dari topBanner dan botBanner lembaga
        final bannerConfig = BannerConfig.fromLembaga(
          lembaga.topBanner,
          lembaga.botBanner,
        );
        _bannerCache[lembagaSlug] = bannerConfig;
      }
    } catch (e) {
      print('Error preloading banner configs for $lembagaSlug: $e');
    }
  }

  /// Clear cache untuk lembaga tertentu atau semua
  void clearCache([String? lembagaSlug]) {
    if (lembagaSlug != null) {
      _bannerCache.remove(lembagaSlug);
    } else {
      _bannerCache.clear();
    }
  }

  /// Check if banner is available for lembaga
  bool hasBannerConfig({String? lembagaSlug}) {
    final config = getBannerConfigSync('', lembagaSlug: lembagaSlug);
    return config.hasBanners;
  }
}
