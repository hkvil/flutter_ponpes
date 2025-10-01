import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/staff.dart';

class StaffRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Get staff by lembaga slug (active only)
  Future<List<Staff>> getStaffByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/staffs',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[isActive][\$eq]': true,
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
        .map((item) => Staff.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get all staff by lembaga slug (including inactive)
  Future<List<Staff>> getAllStaffByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/staffs',
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
        .map((item) => Staff.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get staff by jabatan and lembaga
  Future<List<Staff>> getStaffByJabatan(
    String lembagaSlug,
    String jabatan, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/staffs',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[jabatan][\$eq]': jabatan,
        'filters[isActive][\$eq]': true,
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
        .map((item) => Staff.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get teachers only by lembaga
  Future<List<Staff>> getTeachersByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    final response = await _dio.get(
      '$apiHost/api/staffs',
      queryParameters: {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[isGuru][\$eq]': true,
        'filters[isActive][\$eq]': true,
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
        .map((item) => Staff.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get single staff by ID
  Future<Staff?> getStaffById(int id) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

    try {
      final response = await _dio.get(
        '$apiHost/api/staffs/$id',
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

      return Staff.fromJson(data);
    } catch (e) {
      print('Error getting staff by id: $e');
      return null;
    }
  }
}
