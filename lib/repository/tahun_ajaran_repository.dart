import 'package:dio/dio.dart';

import '../models/tahun_ajaran.dart';
import 'base_repository.dart';

class TahunAjaranRepository extends BaseRepository {
  TahunAjaranRepository({Dio? dio}) : super(dio: dio);

  /// Get all tahun ajaran by lembaga
  Future<List<TahunAjaran>> getTahunAjaranByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchTahunAjaran(
      'lembaga:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'lembaga',
        'sort': 'nama:desc',
      },
    );
  }

  /// Get active tahun ajaran by lembaga
  Future<TahunAjaran?> getActiveTahunAjaranByLembaga(String lembagaSlug) async {
    final items = await _fetchTahunAjaran(
      'active:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[aktif][\$eq]': true,
        'pagination[pageSize]': 1,
        'populate': 'lembaga',
      },
    );
    return items.isEmpty ? null : items.first;
  }

  /// Get tahun ajaran by nama and lembaga
  Future<TahunAjaran?> getTahunAjaranByNama(
    String lembagaSlug,
    String nama,
  ) async {
    final items = await _fetchTahunAjaran(
      'nama:$nama',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[nama][\$eq]': nama,
        'pagination[pageSize]': 1,
        'populate': 'lembaga',
      },
    );
    return items.isEmpty ? null : items.first;
  }

  /// Get tahun ajaran by year range (e.g., 2023-2024)
  Future<List<TahunAjaran>> getTahunAjaranByYearRange(
    String lembagaSlug,
    int startYear,
    int endYear, {
    int? page,
    int? pageSize,
  }) {
    return _fetchTahunAjaran(
      'range:$startYear-$endYear',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunMulai][\$gte]': startYear,
        'filters[tahunSelesai][\$lte]': endYear,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'lembaga',
        'sort': 'nama:desc',
      },
    );
  }

  /// Get single tahun ajaran by ID
  Future<TahunAjaran?> getTahunAjaranById(int id) async {
    try {
      final response = await dio.get(
        '/api/tahun-ajarans/$id',
        queryParameters: {
          'populate': 'lembaga',
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final body = ensureMap(response.data);
      final data = body['data'];

      if (data is Map<String, dynamic>) {
        return TahunAjaran.fromJson(data);
      }

      return null;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error getting tahun ajaran by id: $message');
      return null;
    }
  }

  Future<List<TahunAjaran>> _fetchTahunAjaran(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/tahun-ajarans',
        queryParameters: queryParameters,
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final body = ensureMap(response.data);
      final dataList = (body['data'] as List<dynamic>?) ?? const [];

      if (dataList.isEmpty) {
        return [];
      }

      return dataList
          .whereType<Map<String, dynamic>>()
          .map(TahunAjaran.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching tahun ajaran ($context): $message');
      throw Exception('Failed to fetch tahun ajaran: $message');
    }
  }
}
