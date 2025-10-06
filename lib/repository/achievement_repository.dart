import 'package:dio/dio.dart';

import '../models/achievement_model.dart';
import 'base_repository.dart';

class AchievementRepository extends BaseRepository {
  AchievementRepository({Dio? dio}) : super(dio: dio);

  Future<List<AchievementModel>> fetchAchievements() async {
    print('Fetching achievements...');

    try {
      final response = await dio.get(
        '/api/prestasi-dan-penghargaan-pesantrens',
        queryParameters: {
          'populate': '*',
        },
        options: buildOptions(),
      );

      final body = ensureMap(response.data);
      print('Response data: $body');

      final achievements = AchievementModel.fromJsonList(body, baseUrl);
      print('Parsed ${achievements.length} achievements');
      return achievements;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching achievements: $message');
      throw Exception('Failed to fetch achievements: $message');
    }
  }
}
