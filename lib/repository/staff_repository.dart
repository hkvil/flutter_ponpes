import 'package:dio/dio.dart';

import '../models/staff.dart';
import 'base_repository.dart';

class StaffRepository extends BaseRepository {
  StaffRepository({Dio? dio}) : super(dio: dio);

  /// Get staff by lembaga slug (active only)
  Future<List<Staff>> getStaffByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchStaff(
      'active:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[aktif][\$eq]': true,
        'populate[lembaga]': true,
        'sort': 'nama:asc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  /// Get all staff by lembaga slug (including inactive)
  Future<List<Staff>> getAllStaffByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchStaff(
      'all:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  /// Get staff by jabatan and lembaga
  Future<List<Staff>> getStaffByJabatan(
    String lembagaSlug,
    String jabatan, {
    int? page,
    int? pageSize,
  }) {
    return _fetchStaff(
      'jabatan:$jabatan',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[jabatan][\$eq]': jabatan,
        'filters[isActive][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  /// Get teachers only by lembaga
  Future<List<Staff>> getTeachersByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return _fetchStaff(
      'teacher:$lembagaSlug',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[isGuru][\$eq]': true,
        'filters[isActive][\$eq]': true,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
      },
    );
  }

  /// Get single staff by ID
  Future<Staff?> getStaffById(int id) async {
    try {
      final response = await dio.get(
        '/api/staffs/$id',
        queryParameters: {
          'populate': 'deep',
        },
        options: buildOptions(),
      );

      final body = ensureMap(response.data);
      final data = body['data'];

      if (data is Map<String, dynamic>) {
        return Staff.fromJson(data);
      }

      return null;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error getting staff by id: $message');
      return null;
    }
  }

  Future<List<Staff>> _fetchStaff(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/staffs',
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
          .map(Staff.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching staff ($context): $message');
      throw Exception('Failed to fetch staff: $message');
    }
  }
}
