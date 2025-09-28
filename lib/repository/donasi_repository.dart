import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/donasi_api_response.dart';
import '../models/donasi_model.dart';

class DonasiRepository {
  static const String _endpoint = '/api/donasis';

  // Get all donations with populate media
  Future<DonasiApiResponse> getDonations({
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final apiHost = dotenv.env['API_HOST'] ?? '';
      final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

      final queryParams = {
        'pagination[page]': page.toString(),
        'pagination[pageSize]': pageSize.toString(),
        'populate': 'media', // Populate media relation
      };

      final uri = Uri.parse('$apiHost$_endpoint').replace(
        queryParameters: queryParams,
      );

      print('Fetching donations from: $uri');
      print('Using token: ${apiToken.substring(0, 20)}...');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );
      print('Donations API Response Status: ${response.statusCode}');
      print('Donations API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return DonasiApiResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to fetch donations. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donations: $e');
      throw Exception('Failed to fetch donations: $e');
    }
  }

  // Get single donation by ID
  Future<DonasiModel?> getDonationById(int id) async {
    try {
      final apiHost = dotenv.env['API_HOST'] ?? '';
      final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

      final uri = Uri.parse('$apiHost$_endpoint/$id').replace(
        queryParameters: {
          'populate': 'media',
        },
      );

      print('Fetching donation by ID from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );

      print('Donation by ID API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          return DonasiModel.fromJson(jsonData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching donation by ID: $e');
      return null;
    }
  }

  // Get donations with specific status (active, completed, expired)
  Future<DonasiApiResponse> getDonationsByStatus({
    String status = 'active',
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final now =
          DateTime.now().toIso8601String().split('T')[0]; // Format: YYYY-MM-DD

      Map<String, String> filters = {};

      switch (status) {
        case 'active':
          filters['deadline[\$gte]'] = now;
          break;
        case 'expired':
          filters['deadline[\$lt]'] = now;
          break;
        case 'completed':
          // This would require custom logic on backend
          // For now, we'll just fetch all and filter on client
          break;
      }

      final queryParams = {
        'pagination[page]': page.toString(),
        'pagination[pageSize]': pageSize.toString(),
        'populate': 'media',
        ...filters,
      };

      final apiHost = dotenv.env['API_HOST'] ?? '';
      final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

      final uri = Uri.parse('$apiHost$_endpoint').replace(
        queryParameters: queryParams,
      );

      print('Fetching donations by status from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return DonasiApiResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to fetch donations by status. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donations by status: $e');
      throw Exception('Failed to fetch donations by status: $e');
    }
  }

  // Search donations by title
  Future<DonasiApiResponse> searchDonations({
    required String query,
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final queryParams = {
        'pagination[page]': page.toString(),
        'pagination[pageSize]': pageSize.toString(),
        'populate': 'media',
        'filters[title][\$containsi]': query, // Case insensitive search
      };

      final apiHost = dotenv.env['API_HOST'] ?? '';
      final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';

      final uri = Uri.parse('$apiHost$_endpoint').replace(
        queryParameters: queryParams,
      );

      print('Searching donations from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return DonasiApiResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to search donations. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching donations: $e');
      throw Exception('Failed to search donations: $e');
    }
  }

  // Helper method to get donations sorted by deadline (urgent first)
  Future<List<DonasiModel>> getUrgentDonations({int limit = 5}) async {
    try {
      final response = await getDonations(pageSize: 100); // Get more to sort

      // Filter active donations and sort by deadline
      final activeDonations =
          response.data.where((donation) => !donation.isExpired).toList();

      activeDonations.sort((a, b) => a.sisaHari.compareTo(b.sisaHari));

      return activeDonations.take(limit).toList();
    } catch (e) {
      print('Error getting urgent donations: $e');
      return [];
    }
  }

  // Helper method to get donations sorted by progress (almost reached target)
  Future<List<DonasiModel>> getAlmostCompleteDonations({int limit = 5}) async {
    try {
      final response = await getDonations(pageSize: 100); // Get more to sort

      // Filter active donations and sort by progress (highest first)
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
