import 'package:flutter/foundation.dart';

import '../models/banner_menu_utama_model.dart';
import '../repository/banner_menu_utama_repository.dart';
import 'async_value.dart';

class BannerMenuUtamaProvider extends ChangeNotifier {
  BannerMenuUtamaProvider({BannerMenuUtamaRepository? repository})
      : _repository = repository ?? BannerMenuUtamaRepository();

  final BannerMenuUtamaRepository _repository;
  final Map<String, AsyncValue<BannerMenuUtama?>> _bannerStates = {};

  AsyncValue<BannerMenuUtama?> bannerState(String title) {
    return _bannerStates.putIfAbsent(
      title,
      () => AsyncValue<BannerMenuUtama?>(),
    );
  }

  Future<BannerMenuUtama?> fetchBanner(String title,
      {bool forceRefresh = false}) async {
    final state = bannerState(title);

    if (state.isLoading) return state.data;
    if (state.hasLoaded && !forceRefresh) {
      return state.data;
    }

    state.startLoading();
    notifyListeners();

    try {
      final banner = await _repository.getBannerByTitle(title);
      state.setNullableData(banner);
      return banner;
    } catch (error) {
      state.setError(error);
      return null;
    } finally {
      notifyListeners();
    }
  }

  void clearBanner(String title) {
    _bannerStates.remove(title);
    notifyListeners();
  }
}
