import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/achievement_model.dart';

class AchievementRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<AchievementModel>> fetchAchievements() async {
    print('Fetching achievements...');
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';
    print('apiHost: $apiHost');
    print('apiToken: $apiToken');

    try {
      final response = await _dio.get(
        '$apiHost/api/prestasi-dan-penghargaan-pesantrens?populate=*',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );

      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        return AchievementModel.fromJsonList(response.data, apiHost);
      } else {
        throw Exception('Failed to load achievements: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching achievements: $e');
      throw Exception('Failed to fetch achievements: $e');
    }
  }
}
