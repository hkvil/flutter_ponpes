import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/prestasi.dart';

class PrestasiRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Get all prestasi by lembaga (filter by santri's lembaga)
  Future<List<Prestasi>> getPrestasiByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
    String? tahun,
    String? tingkat,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/prestasis',
      queryParameters: {
        'filters[santri][lembaga][slug][\$eq]': lembagaSlug,
        if (tahun != null) 'filters[tahun][\$eq]': tahun,
        if (tingkat != null) 'filters[tingkat][\$eq]': tingkat,
        'populate[santri]': true,
        'sort': 'tahun:desc',
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
        .map((item) => Prestasi.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get prestasi by kategori and lembaga
  Future<List<Prestasi>> getPrestasiByKategori(
    String lembagaSlug,
    String kategori, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/prestasis',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[kategori][\$eq]': kategori,
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
        .map((item) => Prestasi.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get prestasi by tingkat (level) and lembaga
  Future<List<Prestasi>> getPrestasiByTingkat(
    String lembagaSlug,
    String tingkat, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/prestasis',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tingkat][\$eq]': tingkat,
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
        .map((item) => Prestasi.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get prestasi by tahun ajaran and lembaga
  Future<List<Prestasi>> getPrestasiByTahunAjaran(
    String lembagaSlug,
    String tahunAjaranName, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/prestasis',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][nama][\$eq]': tahunAjaranName,
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
        .map((item) => Prestasi.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get prestasi by santri ID
  Future<List<Prestasi>> getPrestasiBySantriId(
    int santriId, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/prestasis',
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
        .map((item) => Prestasi.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get single prestasi by ID
  Future<Prestasi?> getPrestasiById(int id) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/prestasis/$id',
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

      return Prestasi.fromJson(data);
    } catch (e) {
      print('Error getting prestasi by id: $e');
      return null;
    }
  }
}
