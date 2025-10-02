import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/banner_menu_utama_model.dart';

class BannerMenuUtamaRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Ambil banner berdasarkan title menu (PPI, INFORMASI, dll)
  Future<BannerMenuUtama?> getBannerByTitle(String title) async {
    print('\n🔄 [BANNER_API] Fetching banner for title: "$title"');

    final apiHost = dotenv.env['API_HOST'] ?? 'http://localhost:1337';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/banner-menu-utamas',
        queryParameters: {
          'filters[title][\$contains]': title,
          'populate': 'all',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
          },
        ),
      );

      print(
          '✅ [BANNER_API] Response received - Status: ${response.statusCode}');

      final body = response.data as Map<String, dynamic>;
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
    } catch (e, stackTrace) {
      print('❌ [BANNER_API] ERROR: $e');
      print('📍 StackTrace: $stackTrace');
      return null;
    }
  }

  /// Ambil semua banner yang tersedia
  Future<List<BannerMenuUtama>> getAllBanners() async {
    print('\n🔄 [BANNER_API] Fetching all banners');

    final apiHost = dotenv.env['API_HOST'] ?? 'http://localhost:1337';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/banner-menu-utamas',
        queryParameters: {
          'sort': 'title:asc',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
          },
        ),
      );

      print(
          '✅ [BANNER_API] Response received - Status: ${response.statusCode}');

      final body = response.data as Map<String, dynamic>;
      final banners = BannerMenuUtama.listFromStrapiEnvelope(body);

      print('🎉 [BANNER_API] Found ${banners.length} banners');
      for (final banner in banners) {
        print('   - ${banner.title} (ID: ${banner.id})');
      }

      return banners;
    } catch (e, stackTrace) {
      print('❌ [BANNER_API] ERROR: $e');
      print('📍 StackTrace: $stackTrace');
      return [];
    }
  }
}
