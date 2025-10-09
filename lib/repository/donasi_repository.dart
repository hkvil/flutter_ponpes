import 'package:dio/dio.dart';

import '../models/donasi_api_response.dart';
import '../models/donasi_model.dart';
import 'base_repository.dart';

class DonasiRepository extends BaseRepository {
  DonasiRepository({Dio? dio}) : super(dio: dio);

  static const String _endpoint = '/api/donasis';

  Future<DonasiApiResponse> getDonations({
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final response = await dio.get(
        _endpoint,
        queryParameters: {
          'pagination[page]': page.toString(),
          'pagination[pageSize]': pageSize.toString(),
          'populate[media]': true,
          'populate[transaksi]': true,
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final jsonData = ensureMap(response.data);
      return DonasiApiResponse.fromJson(jsonData);
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching donations: $message');
      throw Exception('Failed to fetch donations: $message');
    }
  }

  Future<DonasiModel?> getDonationById(int id) async {
    try {
      final response = await dio.get(
        '$_endpoint/$id',
        queryParameters: {
          'populate[media]': true,
          'populate[transaksi]': true,
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final jsonData = ensureMap(response.data);
      if (jsonData['data'] != null) {
        return DonasiModel.fromJson(jsonData['data']);
      }

      return null;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching donation by ID: $message');
      return null;
    }
  }

  Future<DonasiApiResponse> getDonationsByStatus({
    String status = 'active',
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final now = DateTime.now().toIso8601String().split('T')[0];
      final filters = <String, String>{};

      switch (status) {
        case 'active':
          filters['deadline[\$gte]'] = now;
          break;
        case 'expired':
          filters['deadline[\$lt]'] = now;
          break;
        case 'completed':
          break;
      }

      final response = await dio.get(
        _endpoint,
        queryParameters: {
          'pagination[page]': page.toString(),
          'pagination[pageSize]': pageSize.toString(),
          'populate': 'media',
          ...filters,
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final jsonData = ensureMap(response.data);
      return DonasiApiResponse.fromJson(jsonData);
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching donations by status: $message');
      throw Exception('Failed to fetch donations by status: $message');
    }
  }

  Future<DonasiApiResponse> searchDonations({
    required String query,
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final response = await dio.get(
        _endpoint,
        queryParameters: {
          'pagination[page]': page.toString(),
          'pagination[pageSize]': pageSize.toString(),
          'populate': 'media',
          'filters[title][\$containsi]': query,
        },
        options: buildPublicOptions(), // Public endpoint - no auth required
      );

      final jsonData = ensureMap(response.data);
      return DonasiApiResponse.fromJson(jsonData);
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error searching donations: $message');
      throw Exception('Failed to search donations: $message');
    }
  }

  Future<List<DonasiModel>> getUrgentDonations({int limit = 5}) async {
    try {
      final response = await getDonations(pageSize: 100);

      final activeDonations =
          response.data.where((donation) => !donation.isExpired).toList();

      activeDonations.sort((a, b) => a.sisaHari.compareTo(b.sisaHari));

      return activeDonations.take(limit).toList();
    } catch (e) {
      print('Error getting urgent donations: $e');
      return [];
    }
  }

  Future<List<DonasiModel>> getAlmostCompleteDonations({int limit = 5}) async {
    try {
      final response = await getDonations(pageSize: 100);

      final activeDonations = response.data
          .where((donation) => !donation.isExpired && !donation.isTargetReached)
          .toList();

      activeDonations.sort((a, b) => b.progress.compareTo(a.progress));

      return activeDonations.take(limit).toList();
    } catch (e) {
      print('Error getting almost complete donations: $e');
      return [];
    }
  }
}
