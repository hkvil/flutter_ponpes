import 'package:dio/dio.dart';

import '../models/kehadiran_guru.dart';
import '../models/kehadiran_santri.dart';
import 'base_repository.dart';

class KehadiranRepository extends BaseRepository {
  KehadiranRepository({Dio? dio}) : super(dio: dio);

  // ==================== KEHADIRAN SANTRI ====================

  Future<List<KehadiranSantri>> getKehadiranSantriByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchSantri(
      'lembaga:$lembagaSlug',
      {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'populate[santri]': true,
        'populate[riwayatKelas][populate][tahunAjaran]': true,
        'sort': 'tanggal:desc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  Future<List<KehadiranSantri>> getKehadiranSantriByDateRange(
    String lembagaSlug,
    DateTime startDate,
    DateTime endDate, {
    int? page,
    int? pageSize,
  }) {
    return _fetchSantri(
      'date-range:$lembagaSlug',
      {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'filters[tanggal][\$gte]': startDate.toIso8601String().split('T')[0],
        'filters[tanggal][\$lte]': endDate.toIso8601String().split('T')[0],
        'populate[santri]': true,
        'populate[riwayatKelas][populate][tahunAjaran]': true,
        'sort': 'tanggal:desc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  Future<List<KehadiranSantri>> getKehadiranBySantriId(
    int santriId, {
    int? page,
    int? pageSize,
  }) {
    return _fetchSantri(
      'santri-id:$santriId',
      {
        'filters[santri][id][\$eq]': santriId,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
    );
  }

  Future<List<KehadiranSantri>> getKehadiranSantriByDate(
    String lembagaSlug,
    DateTime date, {
    int? page,
    int? pageSize,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _fetchSantri(
      'date:$lembagaSlug:${startOfDay.toIso8601String()}',
      {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tanggal][\$gte]': startOfDay.toIso8601String(),
        'filters[tanggal][\$lt]': endOfDay.toIso8601String(),
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  // ==================== KEHADIRAN GURU/STAFF ====================

  Future<List<KehadiranGuru>> getKehadiranGuruByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchGuru(
      'lembaga:$lembagaSlug',
      {
        'filters[staff][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][aktif][\$eq]': true,
        'populate[staff]': true,
        'populate[tahunAjaran]': true,
        'sort': 'tanggal:desc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  Future<List<KehadiranGuru>> getKehadiranGuruByDateRange(
    String lembagaSlug,
    DateTime startDate,
    DateTime endDate, {
    int? page,
    int? pageSize,
  }) {
    return _fetchGuru(
      'date-range:$lembagaSlug',
      {
        'filters[staff][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][aktif][\$eq]': true,
        'filters[tanggal][\$gte]': startDate.toIso8601String().split('T')[0],
        'filters[tanggal][\$lte]': endDate.toIso8601String().split('T')[0],
        'populate[staff]': true,
        'populate[tahunAjaran]': true,
        'sort': 'tanggal:desc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  Future<List<KehadiranGuru>> getKehadiranByGuruId(
    int guruId, {
    int? page,
    int? pageSize,
  }) {
    return _fetchGuru(
      'guru-id:$guruId',
      {
        'filters[guru][id][\$eq]': guruId,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
    );
  }

  Future<List<KehadiranGuru>> getKehadiranGuruByDate(
    String lembagaSlug,
    DateTime date, {
    int? page,
    int? pageSize,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _fetchGuru(
      'date:$lembagaSlug:${startOfDay.toIso8601String()}',
      {
        'filters[guru][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tanggal][\$gte]': startOfDay.toIso8601String(),
        'filters[tanggal][\$lt]': endOfDay.toIso8601String(),
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  Future<List<KehadiranSantri>> _fetchSantri(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/kehadiran-santris',
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
          .map(KehadiranSantri.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching kehadiran santri ($context): $message');
      throw Exception('Failed to fetch kehadiran santri: $message');
    }
  }

  Future<List<KehadiranGuru>> _fetchGuru(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/kehadiran-gurus',
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
          .map(KehadiranGuru.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching kehadiran guru ($context): $message');
      throw Exception('Failed to fetch kehadiran guru: $message');
    }
  }
}
