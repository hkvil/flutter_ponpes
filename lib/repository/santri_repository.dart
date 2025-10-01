import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/santri.dart';

class SantriRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Get santri by lembaga slug (active tahun ajaran only)
  Future<List<Santri>> getSantriByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/santris',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 25,
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
        .map((item) => Santri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get alumni by lembaga slug
  Future<List<Santri>> getAlumniByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/santris',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[isAlumni][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 25,
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
        .map((item) => Santri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get all santri by lembaga slug (including alumni)
  Future<List<Santri>> getAllSantriByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/santris',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 25,
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
        .map((item) => Santri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get santri by lembaga and kelas (active tahun ajaran)
  Future<List<Santri>> getSantriByLembagaAndKelas(
    String lembagaSlug,
    String kelasName, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/santris',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[riwayatKelas][tahunAjaran][aktif][\$eq]': true,
        'filters[riwayatKelas][kelas][namaKelas][\$eq]': kelasName,
        'pagination[pageSize]': pageSize ?? 25,
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
        .map((item) => Santri.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get single santri by ID
  Future<Santri?> getSantriById(int id) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/santris/$id',
        queryParameters: {
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
      final data = body['data'] as Map<String, dynamic>?;

      if (data == null) {
        return null;
      }

      return Santri.fromJson(data);
    } catch (e) {
      print('Error getting santri by id: $e');
      return null;
    }
  }
}
