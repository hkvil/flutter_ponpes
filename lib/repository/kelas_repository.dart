import 'package:dio/dio.dart';

import '../models/kelas.dart';
import 'base_repository.dart';

class KelasRepository extends BaseRepository {
  KelasRepository({Dio? dio}) : super(dio: dio);

  /// Get all kelas by lembaga slug
  Future<List<Kelas>> getKelasByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchKelas(
      'lembaga:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  /// Get kelas by lembaga and tahun ajaran
  Future<List<Kelas>> getKelasByLembagaAndTahunAjaran(
    String lembagaSlug,
    String tahunAjaranName, {
    int? page,
    int? pageSize,
  }) {
    return _fetchKelas(
      'lembaga:$lembagaSlug:tahun:$tahunAjaranName',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][nama][\$eq]': tahunAjaranName,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'namaKelas:asc',
      },
    );
  }

  /// Get active kelas by lembaga
  Future<List<Kelas>> getActiveKelasByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchKelas(
      'active:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][aktif][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'namaKelas:asc',
      },
    );
  }

  /// Get kelas by tingkat (level) and lembaga
  Future<List<Kelas>> getKelasByTingkat(
    String lembagaSlug,
    int tingkat, {
    int? page,
    int? pageSize,
  }) {
    return _fetchKelas(
      'tingkat:$lembagaSlug:$tingkat',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tingkat][\$eq]': tingkat,
        'filters[tahunAjaran][aktif][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'namaKelas:asc',
      },
    );
  }

  /// Get single kelas by ID
  Future<Kelas?> getKelasById(int id) async {
    try {
      final response = await dio.get(
        '/api/kelass/$id',
        queryParameters: {
          'populate': 'deep',
        },
        options: buildOptions(),
      );

      final body = ensureMap(response.data);
      final data = body['data'];

      if (data is Map<String, dynamic>) {
        return Kelas.fromJson(data);
      }

      return null;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error getting kelas by id: $message');
      return null;
    }
  }

  Future<List<Kelas>> _fetchKelas(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/kelass',
        queryParameters: queryParameters,
        options: buildOptions(),
      );

      final body = ensureMap(response.data);
      final dataList = (body['data'] as List<dynamic>?) ?? const [];

      if (dataList.isEmpty) {
        return [];
      }

      return dataList
          .whereType<Map<String, dynamic>>()
          .map(Kelas.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching kelas ($context): $message');
      throw Exception('Failed to fetch kelas: $message');
    }
  }
}
