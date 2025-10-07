import 'package:dio/dio.dart';

import '../models/banner_menu_utama_model.dart';
import 'base_repository.dart';

class BannerMenuUtamaRepository extends BaseRepository {
  BannerMenuUtamaRepository({Dio? dio}) : super(dio: dio);

  /// Ambil banner berdasarkan title menu (PPI, INFORMASI, dll)
  Future<BannerMenuUtama?> getBannerByTitle(String title) async {
    print('\n🔄 [BANNER_API] Fetching banner for title: "$title"');
    print('📍 Endpoint: /api/banner-menu-utamas');

    try {
      final response = await dio.get(
        '/api/banner-menu-utamas',
        queryParameters: {
          'filters[title][\$contains]': title,
          'populate': 'all',
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      print(
          '✅ [BANNER_API] Response received - Status: ${response.statusCode}');

      final body = ensureMap(response.data);
      final data = (body['data'] as List?) ?? const [];

      print('📦 [BANNER_API] Data count: ${data.length}');

      if (data.isEmpty) {
        print('❌ [BANNER_API] No banner found for title: "$title"');
        return null;
      }

      final banner =
          BannerMenuUtama.fromJson(data.first as Map<String, dynamic>);

      print('🎉 [BANNER_API] Banner found:');
      print('   - ID: ${banner.id}');
      print('   - Title: ${banner.title}');
      print('   - Top Banner: ${banner.topBannerUrl ?? 'null'}');
      print('   - Bottom Banner: ${banner.bottomBannerUrl ?? 'null'}');

      return banner;
    } on DioException catch (e, stackTrace) {
      final message = mapDioError(e);
      print('❌ [BANNER_API] ERROR: $message');
      print('📍 StackTrace: $stackTrace');
      return null;
    }
  }

  /// Ambil semua banner yang tersedia
  Future<List<BannerMenuUtama>> getAllBanners() async {
    print('\n🔄 [BANNER_API] Fetching all banners');

    try {
      final response = await dio.get(
        '/api/banner-menu-utamas',
        queryParameters: {
          'sort': 'title:asc',
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      print(
          '✅ [BANNER_API] Response received - Status: ${response.statusCode}');

      final body = ensureMap(response.data);
      final banners = BannerMenuUtama.listFromStrapiEnvelope(body);

      print('🎉 [BANNER_API] Found ${banners.length} banners');
      for (final banner in banners) {
        print('   - ${banner.title} (ID: ${banner.id})');
      }

      return banners;
    } on DioException catch (e, stackTrace) {
      final message = mapDioError(e);
      print('❌ [BANNER_API] ERROR: $message');
      print('📍 StackTrace: $stackTrace');
      return [];
    }
  }
}
