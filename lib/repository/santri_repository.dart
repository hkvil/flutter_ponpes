import 'package:dio/dio.dart';

import '../models/santri.dart';
import '../models/pagination.dart';
import 'base_repository.dart';

class SantriRepository extends BaseRepository {
  SantriRepository({Dio? dio}) : super(dio: dio);

  /// Get santri by lembaga slug (active tahun ajaran only)
  Future<PaginatedResponse<Santri>> getSantriByLembaga(
    String lembagaSlug, {
    int page = 1,
    int pageSize = 20,
  }) {
    return _fetchSantri(
      'lembaga:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'pagination[pageSize]': pageSize,
        'pagination[page]': page,
      },
    );
  }

  /// Get alumni by lembaga slug
  Future<PaginatedResponse<Santri>> getAlumniByLembaga(
    String lembagaSlug, {
    int page = 1,
    int pageSize = 20,
    String? tahunMasuk,
  }) {
    return _fetchSantri(
      'alumni:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[isAlumni][\$eq]': true,
        if (tahunMasuk != null) 'filters[tahunMasuk][\$eq]': tahunMasuk,
        'sort': 'tahunMasuk:desc,nama:asc',
        'pagination[pageSize]': pageSize,
        'pagination[page]': page,
      },
    );
  }

  /// Get all santri by lembaga slug (including alumni)
  Future<PaginatedResponse<Santri>> getAllSantriByLembaga(
    String lembagaSlug, {
    int page = 1,
    int pageSize = 25,
  }) {
    return _fetchSantri(
      'all:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize,
        'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  /// Get santri by lembaga and kelas (active tahun ajaran)
  Future<PaginatedResponse<Santri>> getSantriByLembagaAndKelas(
    String lembagaSlug,
    String kelasName, {
    int page = 1,
    int pageSize = 25,
  }) {
    print('kelasName LOG:$kelasName');
    return _fetchSantri(
      'kelas:$kelasName',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'filters[kelasAktif]': kelasName,
        'pagination[pageSize]': pageSize,
        'pagination[page]': page,
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

  Future<PaginatedResponse<Santri>> _fetchSantri(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/santris',
        queryParameters: queryParameters,
        options:
            await buildAuthenticatedOptions(), // Authenticated endpoint - requires login
      );

      final body = ensureMap(response.data);
      final dataList = (body['data'] as List<dynamic>?) ?? const [];
      final meta = body['meta'] as Map<String, dynamic>? ?? {};

      final santriList = dataList
          .whereType<Map<String, dynamic>>()
          .map(Santri.fromJson)
          .toList();

      final paginationMeta = PaginationMeta.fromJson(meta);

      return PaginatedResponse<Santri>(
        data: santriList,
        meta: paginationMeta,
      );
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching santri ($context): $message');
      throw Exception('Failed to fetch santri: $message');
    }
  }
}
