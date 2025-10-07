import 'package:dio/dio.dart';

import '../models/pelanggaran.dart';
import 'base_repository.dart';

class PelanggaranRepository extends BaseRepository {
  PelanggaranRepository({Dio? dio}) : super(dio: dio);

  /// Get pelanggaran by lembaga slug
  Future<List<Pelanggaran>> getPelanggaranByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchPelanggaran(
      'lembaga:$lembagaSlug',
      {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        'populate[santri]': true,
        'sort': 'tanggal:desc',
        if (pageSize != null) 'pagination[pageSize]': pageSize,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  /// Get pelanggaran by santri ID
  Future<List<Pelanggaran>> getPelanggaranBySantriId(int santriId) {
    return _fetchPelanggaran(
      'santri:$santriId',
      {
        'filters[santri][id][\$eq]': santriId,
        'populate[santri]': true,
        'sort': 'tanggal:desc',
      },
    );
  }

  /// Get single pelanggaran by ID
  Future<Pelanggaran?> getPelanggaranById(int id) async {
    try {
      final response = await dio.get(
        '/api/pelanggarans/$id',
        options: await buildAuthenticatedOptions(),
      );

      final body = ensureMap(response.data);
      final data = body['data'] as Map<String, dynamic>?;

      if (data == null) {
        return null;
      }

      return Pelanggaran.fromJson(data);
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error getting pelanggaran by id: $message');
      return null;
    }
  }

  Future<List<Pelanggaran>> _fetchPelanggaran(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/pelanggarans',
        queryParameters: queryParameters,
        options:
            await buildAuthenticatedOptions(), // Authenticated endpoint - requires login
      );

      final body = ensureMap(response.data);
      final dataList = (body['data'] as List<dynamic>?) ?? const [];

      if (dataList.isEmpty) {
        return [];
      }

      return dataList
          .whereType<Map<String, dynamic>>()
          .map(Pelanggaran.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching pelanggaran ($context): $message');
      throw Exception('Failed to fetch pelanggaran: $message');
    }
  }
}
