import 'package:dio/dio.dart';
import 'package:pesantren_app/models/informasi_al_ittifaqiah_model.dart';

import 'base_repository.dart';

class InformasiAlIttifaqiahRepository extends BaseRepository {
  InformasiAlIttifaqiahRepository({Dio? dio}) : super(dio: dio);

  /// Ambil data informasi Al-Ittifaqiah lengkap dengan populate=all
  Future<InformasiAlIttifaqiah?> fetchInformasiAlIttifaqiah() async {
    print('\n🔄 [INFORMASI_API] Starting API call...');
    print('📍 Endpoint: /api/informasi-al-ittifaqiah');

    try {
      final response = await dio.get(
        '/api/informasi-al-ittifaqiah',
        queryParameters: {
          'populate': 'all',
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      print('🔧 [API_DEBUG] URL called with populate=all');
      print('\n✅ [INFORMASI_API] Response received');
      print('📊 Status Code: ${response.statusCode}');
      print('📈 Response Headers: ${response.headers.map}');

      final body = ensureMap(response.data);
      print('📦 Response Body Keys: ${body.keys.toList()}');

      final data = body['data'];
      if (data == null) {
        print('❌ [INFORMASI_API] No data found in response');
        print('💡 Response structure: ${body.toString()}');
        return null;
      }

      print('\n🔄 [INFORMASI_API] Processing data...');
      final rawData = data as Map<String, dynamic>;
      print('📄 Raw Data Keys: ${rawData.keys.toList()}');

      if (rawData['profilMd'] != null) {
        final profilLength = (rawData['profilMd'] as String).length;
        print('📝 profilMd: Found ($profilLength chars)');
      } else {
        print('📝 profilMd: NULL');
      }

      if (rawData['galeriTamu'] is List) {
        final galeriTamuCount = (rawData['galeriTamu'] as List).length;
        print('🖼️ galeriTamu: Found ($galeriTamuCount items)');
      }

      if (rawData['galeriLuarNegeri'] is List) {
        final galeriLuarNegeriCount =
            (rawData['galeriLuarNegeri'] as List).length;
        print('🌍 galeriLuarNegeri: Found ($galeriLuarNegeriCount items)');
      }

      if (rawData['bluePrintISCI'] is List) {
        final bluePrintCount = (rawData['bluePrintISCI'] as List).length;
        print('🏗️ bluePrintISCI: Found ($bluePrintCount items)');
      }

      if (rawData['news'] is List) {
        final newsCount = (rawData['news'] as List).length;
        print('📰 news: Found ($newsCount items)');
      }

      if (rawData['santri'] is List) {
        final santriCount = (rawData['santri'] as List).length;
        print('👨‍🎓 santri: Found ($santriCount records)');
      }

      if (rawData['sdm'] is List) {
        final sdmCount = (rawData['sdm'] as List).length;
        print('👩‍🏫 sdm: Found ($sdmCount records)');
      }

      if (rawData['alumni'] is List) {
        final alumniCount = (rawData['alumni'] as List).length;
        print('🎓 alumni: Found ($alumniCount records)');
      }

      final informasi = InformasiAlIttifaqiah.fromJson(rawData);

      print('\n✅ [INFORMASI_API] Data processing completed');
      print('🏛️ ID: ${informasi.id}');
      print('📝 ProfilMd Available: ${informasi.hasProfilContent()}');
      print('🖼️ Galeri Tamu: ${informasi.galeriTamu.length} items');
      print(
          '🌍 Galeri Luar Negeri: ${informasi.galeriLuarNegeri.length} items');
      print('🏗️ BluePrint ISCI: ${informasi.bluePrintISCI.length} items');
      print('📰 News: ${informasi.news.length} items');
      print('👨‍🎓 Santri Statistics: ${informasi.santri.length} records');
      print('👩‍🏫 SDM Statistics: ${informasi.sdm.length} records');
      print('🎓 Alumni Statistics: ${informasi.alumni.length} records');

      if (informasi.hasProfilContent()) {
        print('📏 ProfilMd Length: ${informasi.profilMd!.length} characters');
      }

      print('🎉 [INFORMASI_API] Success! Returning informasi data\n');
      return informasi;
    } on DioException catch (e, stackTrace) {
      final message = mapDioError(e);
      print('\n❌ [INFORMASI_API] ERROR occurred!');
      print('🚨 Error: $message');
      print('📍 StackTrace: $stackTrace');
      print('💡 Please check API endpoint and network connection\n');
      rethrow;
    }
  }

  /// Ambil hanya data statistik (santri, sdm, alumni) untuk halaman statistik
  Future<Map<String, List<StatistikItem>>> fetchStatistik() async {
    print('\n🔄 [STATISTIK_API] Fetching statistics only...');

    final informasi = await fetchInformasiAlIttifaqiah();
    if (informasi == null) {
      return {
        'santri': <StatistikItem>[],
        'sdm': <StatistikItem>[],
        'alumni': <StatistikItem>[],
      };
    }

    print('📊 [STATISTIK_API] Extracted statistics:');
    print('👨‍🎓 Santri: ${informasi.santri.length} records');
    print('👩‍🏫 SDM: ${informasi.sdm.length} records');
    print('🎓 Alumni: ${informasi.alumni.length} records');

    return {
      'santri': informasi.santri,
      'sdm': informasi.sdm,
      'alumni': informasi.alumni,
    };
  }

  /// Ambil hanya data galeri untuk halaman galeri
  Future<Map<String, List<GaleriItem>>> fetchGaleri() async {
    print('\n🔄 [GALERI_API] Fetching galleries only...');

    final informasi = await fetchInformasiAlIttifaqiah();
    if (informasi == null) {
      return {
        'galeriTamu': <GaleriItem>[],
        'galeriLuarNegeri': <GaleriItem>[],
        'bluePrintISCI': <GaleriItem>[],
      };
    }

    print('🖼️ [GALERI_API] Extracted galleries:');
    print('🖼️ Galeri Tamu: ${informasi.galeriTamu.length} items');
    print('🌍 Galeri Luar Negeri: ${informasi.galeriLuarNegeri.length} items');
    print('🏗️ BluePrint ISCI: ${informasi.bluePrintISCI.length} items');

    return {
      'galeriTamu': informasi.galeriTamu,
      'galeriLuarNegeri': informasi.galeriLuarNegeri,
      'bluePrintISCI': informasi.bluePrintISCI,
    };
  }

  /// Ambil hanya data berita untuk halaman berita
  Future<List<NewsItem>> fetchNews() async {
    print('\n🔄 [NEWS_API] Fetching news only...');

    final informasi = await fetchInformasiAlIttifaqiah();
    if (informasi == null) {
      return <NewsItem>[];
    }

    print('📰 [NEWS_API] Extracted news: ${informasi.news.length} items');
    return informasi.news;
  }
}
