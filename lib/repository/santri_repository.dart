import 'package:dio/dio.dart';

import '../models/santri.dart';
import 'base_repository.dart';

class SantriRepository extends BaseRepository {
  SantriRepository({Dio? dio}) : super(dio: dio);

  /// Get santri by lembaga slug (active tahun ajaran only)
  Future<List<Santri>> getSantriByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchSantri(
      'lembaga:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        if (pageSize != null) 'pagination[pageSize]': pageSize,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  /// Get alumni by lembaga slug
  Future<List<Santri>> getAlumniByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
    String? tahunMasuk,
  }) {
    return _fetchSantri(
      'alumni:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[isAlumni][\$eq]': true,
        if (tahunMasuk != null) 'filters[tahunMasuk][\$eq]': tahunMasuk,
        'sort': 'tahunMasuk:desc,nama:asc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  /// Get all santri by lembaga slug (including alumni)
  Future<List<Santri>> getAllSantriByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchSantri(
      'all:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  /// Get santri by lembaga and kelas (active tahun ajaran)
  Future<List<Santri>> getSantriByLembagaAndKelas(
    String lembagaSlug,
    String kelasName, {
    int? page,
    int? pageSize,
  }) {
    return _fetchSantri(
      'kelas:$kelasName',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'filters[riwayatKelas][kelas][namaKelas][\$eq]': kelasName,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  /// Get single santri by ID
  Future<Santri?> getSantriById(int id) async {
    try {
      final response = await dio.get(
        '/api/santris/$id',
        queryParameters: {
          'populate': 'deep',
        },
        options: buildOptions(),
      );

      final body = ensureMap(response.data);
      final data = body['data'];

      if (data is Map<String, dynamic>) {
        return Santri.fromJson(data);
      }

      return null;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error getting santri by id: $message');
      return null;
    }
  }

  Future<List<Santri>> _fetchSantri(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/santris',
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
          .map(Santri.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching santri ($context): $message');
      throw Exception('Failed to fetch santri: $message');
    }
  }
}
