import 'package:flutter/foundation.dart';

import '../models/achievement_model.dart';
import '../repository/achievement_repository.dart';
import 'async_value.dart';

class AchievementProvider extends ChangeNotifier {
  AchievementProvider({AchievementRepository? repository})
      : _repository = repository ?? AchievementRepository();

  final AchievementRepository _repository;
  final AsyncValue<List<AchievementModel>> _achievementsState =
      AsyncValue<List<AchievementModel>>(data: const []);

  AsyncValue<List<AchievementModel>> get achievementsState =>
      _achievementsState;

  List<AchievementModel> get achievements =>
      List.unmodifiable(_achievementsState.data ?? const []);

  Future<void> fetchAchievements({bool forceRefresh = false}) async {
    if (_achievementsState.isLoading) return;
    if (_achievementsState.hasLoaded && !forceRefresh) return;

    _achievementsState.startLoading();
    notifyListeners();

    try {
      final result = await _repository.fetchAchievements();
      _achievementsState.setData(List.unmodifiable(result));
    } catch (error) {
      _achievementsState.setError(error);
    } finally {
      notifyListeners();
    }
  }

  void clear() {
    _achievementsState.reset();
    notifyListeners();
  }
}
