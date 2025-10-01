import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/tahun_ajaran.dart';

class TahunAjaranRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Get all tahun ajaran by lembaga
  Future<List<TahunAjaran>> getTahunAjaranByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/tahun-ajarans',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'lembaga',
        'sort': 'nama:desc',
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
        .map((item) => TahunAjaran.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get active tahun ajaran by lembaga
  Future<TahunAjaran?> getActiveTahunAjaranByLembaga(
    String lembagaSlug,
  ) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/tahun-ajarans',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[aktif][\$eq]': true,
        'pagination[pageSize]': 1,
        'populate': 'lembaga',
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
      return null;
    }

    return TahunAjaran.fromJson(dataList.first as Map<String, dynamic>);
  }

  /// Get tahun ajaran by nama and lembaga
  Future<TahunAjaran?> getTahunAjaranByNama(
    String lembagaSlug,
    String nama,
  ) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/tahun-ajarans',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[nama][\$eq]': nama,
        'pagination[pageSize]': 1,
        'populate': 'lembaga',
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
      return null;
    }

    return TahunAjaran.fromJson(dataList.first as Map<String, dynamic>);
  }

  /// Get tahun ajaran by year range (e.g., 2023-2024)
  Future<List<TahunAjaran>> getTahunAjaranByYearRange(
    String lembagaSlug,
    int startYear,
    int endYear, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/tahun-ajarans',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunMulai][\$gte]': startYear,
        'filters[tahunSelesai][\$lte]': endYear,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'lembaga',
        'sort': 'nama:desc',
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
        .map((item) => TahunAjaran.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get single tahun ajaran by ID
  Future<TahunAjaran?> getTahunAjaranById(int id) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/tahun-ajarans/$id',
        queryParameters: {
          'populate': 'lembaga',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
          },
        ),
      );

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;

      if (data == null) {
        return null;
      }

      return TahunAjaran.fromJson(data);
    } catch (e) {
      print('Error getting tahun ajaran by id: $e');
      return null;
    }
  }
}
