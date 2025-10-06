import 'package:flutter/foundation.dart';

import '../repository/slider_repository.dart';
import 'async_value.dart';

class SliderProvider extends ChangeNotifier {
  SliderProvider({SliderRepository? repository})
      : _repository = repository ?? SliderRepository();

  final SliderRepository _repository;
  final AsyncValue<List<String>> _sliderState =
      AsyncValue<List<String>>(data: const []);

  AsyncValue<List<String>> get sliderState => _sliderState;
  List<String> get imageUrls => List.unmodifiable(_sliderState.data ?? const []);

  Future<List<String>> fetchSliderImages({bool forceRefresh = false}) async {
    if (_sliderState.isLoading) return _sliderState.data ?? const [];
    if (_sliderState.hasLoaded && !forceRefresh) {
      return _sliderState.data ?? const [];
    }

    _sliderState.startLoading();
    notifyListeners();

    try {
      final images = await _repository.fetchSliderImageUrls();
      _sliderState.setData(List.unmodifiable(images));
      return images;
    } catch (error) {
      _sliderState.setError(error);
      return _sliderState.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  void clear() {
    _sliderState.reset();
    notifyListeners();
  }
}
