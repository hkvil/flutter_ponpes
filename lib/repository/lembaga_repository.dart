import 'package:dio/dio.dart';
import 'package:pesantren_app/models/lembaga_model.dart';

import 'base_repository.dart';

class LembagaRepository extends BaseRepository {
  LembagaRepository({Dio? dio}) : super(dio: dio);

  /// Ambil daftar lembaga untuk menu (nama + slug + timestamp)
  Future<List<Lembaga>> fetchAll() async {
    try {
      final response = await dio.get(
        '/api/lembagas',
        queryParameters: {
          'fields[0]': 'nama',
          'fields[1]': 'slug',
          'fields[2]': 'createdAt',
          'fields[3]': 'updatedAt',
          'sort': 'nama:asc',
          'pagination[pageSize]': 200,
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final body = ensureMap(response.data);
      return Lembaga.listFromStrapiEnvelope(body);
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching lembaga list: $message');
      throw Exception('Failed to fetch lembaga list: $message');
    }
  }

  /// Ambil detail lembaga by slug, lengkap dengan images/videos/kontak/profilMd/programKerjaMd
  Future<Lembaga?> fetchBySlug(String slug) async {
    print('\n🔄 [LEMBAGA_API] Starting API call...');
    print('📍 Slug: "$slug"');

    try {
      final response = await dio.get(
        '/api/lembagas',
        queryParameters: {
          'filters[slug][\$eq]': slug,
          'populate': 'all',
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      print(
          '🔧 [API_DEBUG] URL called with populate=all (plugin untuk deep populate)');

      print('\n✅ [LEMBAGA_API] Response received');
      print('📊 Status Code: ${response.statusCode}');
      print('📈 Response Headers: ${response.headers.map}');

      final body = ensureMap(response.data);
      print('📦 Response Body Keys: ${body.keys.toList()}');

      final data = (body['data'] as List?) ?? const [];
      print('📋 Data Array Length: ${data.length}');

      if (data.isEmpty) {
        print('❌ [LEMBAGA_API] No lembaga found with slug: "$slug"');
        print('💡 Available data structure: ${body.toString()}');
        return null;
      }

      print('\n🔄 [LEMBAGA_API] Processing data...');
      final rawData = data.first as Map<String, dynamic>;
      print('📄 Raw Data Keys: ${rawData.keys.toList()}');

      if (rawData['profilMd'] != null) {
        final profilLength = (rawData['profilMd'] as String).length;
        print('📝 profilMd: Found ($profilLength chars)');
        print(
            '📝 profilMd Preview: "${(rawData['profilMd'] as String).substring(0, (rawData['profilMd'] as String).length > 100 ? 100 : (rawData['profilMd'] as String).length)}${(rawData['profilMd'] as String).length > 100 ? "..." : ""}"');
      } else {
        print('📝 profilMd: NULL');
      }

      if (rawData['programKerjaMd'] != null) {
        final programKerjaLength = (rawData['programKerjaMd'] as String).length;
        print('📋 programKerjaMd: Found ($programKerjaLength chars)');
        print(
            '📋 programKerjaMd Preview: "${(rawData['programKerjaMd'] as String).substring(0, (rawData['programKerjaMd'] as String).length > 100 ? 100 : (rawData['programKerjaMd'] as String).length)}${(rawData['programKerjaMd'] as String).length > 100 ? "..." : ""}"');
      } else {
        print('📋 programKerjaMd: NULL');
      }

      if (rawData['frontImages'] is List) {
        final frontImagesCount = (rawData['frontImages'] as List).length;
        print('🖼️  frontImages: Found ($frontImagesCount images)');
        for (int i = 0;
            i < (rawData['frontImages'] as List).length && i < 3;
            i++) {
          final img = (rawData['frontImages'] as List)[i];
          if (img is Map && img['url'] is String) {
            print('🖼️  Image $i: ${img['url']}');
          }
        }
        if (frontImagesCount > 3) {
          print('🖼️  ... and ${frontImagesCount - 3} more images');
        }
      } else {
        print('🖼️  frontImages: NULL or empty');
      }

      final lembaga = Lembaga.fromJson(rawData);

      print('\n✅ [LEMBAGA_API] Data processing completed');
      print('🏛️  Lembaga Name: "${lembaga.nama}"');
      print('🔗 Lembaga Slug: "${lembaga.slug}"');
      print('📝 ProfilMd Available: ${lembaga.hasProfilContent()}');
      print('📋 ProgramKerjaMd Available: ${lembaga.hasProgramKerjaContent()}');
      print(
          '🖼️  FrontImages Available: ${lembaga.frontImages.isNotEmpty} (${lembaga.frontImages.length} images)');

      if (lembaga.hasProfilContent()) {
        print('📏 ProfilMd Length: ${lembaga.profilMd!.length} characters');
      }
      if (lembaga.hasProgramKerjaContent()) {
        print(
            '📏 ProgramKerjaMd Length: ${lembaga.programKerjaMd!.length} characters');
      }

      print('🎉 [LEMBAGA_API] Success! Returning lembaga data\n');
      return lembaga;
    } on DioException catch (e, stackTrace) {
      final message = mapDioError(e);
      print('\n❌ [LEMBAGA_API] ERROR occurred!');
      print('🚨 Error: $message');
      print('📍 StackTrace: $stackTrace');
      print('🔧 Slug attempted: "$slug"');
      print('💡 Please check API endpoint and network connection\n');
      rethrow;
    }
  }
}
