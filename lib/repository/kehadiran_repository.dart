import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/kehadiran_santri.dart';
import '../models/kehadiran_guru.dart';

class KehadiranRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // ==================== KEHADIRAN SANTRI ====================

  /// Get kehadiran santri by lembaga
  Future<List<KehadiranSantri>> getKehadiranSantriByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kehadiran-santris',
      queryParameters: {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'populate[santri]': true,
        'populate[riwayatKelas][populate][tahunAjaran]': true,
        'sort': 'tanggal:desc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranSantri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kehadiran santri by date range
  Future<List<KehadiranSantri>> getKehadiranSantriByDateRange(
    String lembagaSlug,
    DateTime startDate,
    DateTime endDate, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kehadiran-santris',
      queryParameters: {
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
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranSantri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kehadiran santri by santri ID
  Future<List<KehadiranSantri>> getKehadiranBySantriId(
    int santriId, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kehadiran-santris',
      queryParameters: {
        'filters[santri][id][\$eq]': santriId,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranSantri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kehadiran santri by specific date
  Future<List<KehadiranSantri>> getKehadiranSantriByDate(
    String lembagaSlug,
    DateTime date, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _dio.get(
      '$apiHost/api/kehadiran-santris',
      queryParameters: {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tanggal][\$gte]': startOfDay.toIso8601String(),
        'filters[tanggal][\$lt]': endOfDay.toIso8601String(),
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranSantri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // ==================== KEHADIRAN GURU/STAFF ====================

  /// Get kehadiran guru by lembaga
  Future<List<KehadiranGuru>> getKehadiranGuruByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kehadiran-gurus',
      queryParameters: {
        'filters[guru][lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranGuru.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kehadiran guru by date range
  Future<List<KehadiranGuru>> getKehadiranGuruByDateRange(
    String lembagaSlug,
    DateTime startDate,
    DateTime endDate, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kehadiran-gurus',
      queryParameters: {
        'filters[guru][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tanggal][\$gte]': startDate.toIso8601String(),
        'filters[tanggal][\$lte]': endDate.toIso8601String(),
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranGuru.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kehadiran guru by guru ID
  Future<List<KehadiranGuru>> getKehadiranByGuruId(
    int guruId, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kehadiran-gurus',
      queryParameters: {
        'filters[guru][id][\$eq]': guruId,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranGuru.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kehadiran guru by specific date
  Future<List<KehadiranGuru>> getKehadiranGuruByDate(
    String lembagaSlug,
    DateTime date, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _dio.get(
      '$apiHost/api/kehadiran-gurus',
      queryParameters: {
        'filters[guru][lembaga][slug][\$eq]': lembagaSlug,
        'filters[tanggal][\$gte]': startOfDay.toIso8601String(),
        'filters[tanggal][\$lt]': endOfDay.toIso8601String(),
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
        },
      ),
    );

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      return [];
    }

    return dataList
        .map((item) => KehadiranGuru.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
