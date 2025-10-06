import 'package:dio/dio.dart';

import '../models/slider_model.dart';
import 'base_repository.dart';

class SliderRepository extends BaseRepository {
  SliderRepository({Dio? dio}) : super(dio: dio);

  Future<List<String>> fetchSliderImageUrls() async {
    print('Fetching slider images...');

    try {
      final response = await dio.get(
        '/api/sliders',
        queryParameters: {
          'populate': '*',
        },
        options: buildOptions(),
      );

      final body = ensureMap(response.data);
      print('Response data: $body');

      final data = (body['data'] as List<dynamic>?) ?? const [];
      print('Slider data: $data');

      if (data.isEmpty) {
        return [];
      }

      final slider = SliderModel.fromJson(
        data.first as Map<String, dynamic>,
        baseUrl,
      );
      print('Parsed image URLs: ${slider.imageUrls}');
      return slider.imageUrls;
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Dio error while fetching slider images: $message');
      return [];
    }
  }
}
