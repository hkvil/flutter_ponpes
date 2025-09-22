import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/slider_model.dart';

class SliderRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<String>> fetchSliderImageUrls() async {
    print('Fetching slider images...');
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final apiToken = dotenv.env['API_TOKEN_READONLY'] ?? '';
    print('apiHost: $apiHost');
    print('apiToken: $apiToken');
    try {
      final response = await _dio.get(
        '$apiHost/sliders?populate=*',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );
      print('Response data: ${response.data}');
      final data = response.data['data'] as List<dynamic>? ?? [];
      print('Slider data: $data');
      if (data.isEmpty) return [];
      final slider = SliderModel.fromJson(data.first, apiHost);
      print('Parsed image URLs: ${slider.imageUrls}');
      return slider.imageUrls;
    } catch (e) {
      print('Dio error: $e');
      return [];
    }
  }
}
