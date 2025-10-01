import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/kelas.dart';

class KelasRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Get all kelas by lembaga slug
  Future<List<Kelas>> getKelasByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kelass',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 100,
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
        .map((item) => Kelas.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kelas by lembaga and tahun ajaran
  Future<List<Kelas>> getKelasByLembagaAndTahunAjaran(
    String lembagaSlug,
    String tahunAjaranName, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kelass',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][nama][\$eq]': tahunAjaranName,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'namaKelas:asc',
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
        .map((item) => Kelas.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get active kelas by lembaga
  Future<List<Kelas>> getActiveKelasByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kelass',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][aktif][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'namaKelas:asc',
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
        .map((item) => Kelas.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get kelas by tingkat (level) and lembaga
  Future<List<Kelas>> getKelasByTingkat(
    String lembagaSlug,
    int tingkat, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/kelass',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tingkat][\$eq]': tingkat,
        'filters[tahunAjaran][aktif][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'namaKelas:asc',
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
        .map((item) => Kelas.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get single kelas by ID
  Future<Kelas?> getKelasById(int id) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/kelass/$id',
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

      return Kelas.fromJson(data);
    } catch (e) {
      print('Error getting kelas by id: $e');
      return null;
    }
  }
}
