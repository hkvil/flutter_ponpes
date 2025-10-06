import 'package:flutter/foundation.dart';

import '../models/lembaga_model.dart';
import '../repository/lembaga_repository.dart';
import 'async_value.dart';

class LembagaProvider extends ChangeNotifier {
  LembagaProvider({LembagaRepository? repository})
      : _repository = repository ?? LembagaRepository();

  final LembagaRepository _repository;

  final AsyncValue<List<Lembaga>> _lembagaListState =
      AsyncValue<List<Lembaga>>(data: const []);
  final Map<String, AsyncValue<Lembaga?>> _lembagaBySlug = {};

  AsyncValue<List<Lembaga>> get lembagaListState => _lembagaListState;

  List<Lembaga> get lembagaList =>
      List.unmodifiable(_lembagaListState.data ?? const []);

  AsyncValue<Lembaga?> lembagaState(String slug) {
    return _lembagaBySlug.putIfAbsent(
      slug,
      () => AsyncValue<Lembaga?>(),
    );
  }

  Lembaga? getCachedLembaga(String slug) => lembagaState(slug).data;

  String? errorForSlug(String slug) => lembagaState(slug).errorMessage;

  bool isLoadingSlug(String slug) => lembagaState(slug).isLoading;

  Future<List<Lembaga>> fetchAll({bool forceRefresh = false}) async {
    if (_lembagaListState.isLoading) return _lembagaListState.data ?? const [];
    if (_lembagaListState.hasLoaded && !forceRefresh) {
      return _lembagaListState.data ?? const [];
    }

    _lembagaListState.startLoading();
    notifyListeners();

    try {
      final result = await _repository.fetchAll();
      _lembagaListState.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      _lembagaListState.setError(error);
      return _lembagaListState.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<Lembaga?> fetchBySlug(String slug, {bool forceRefresh = false}) async {
    final state = lembagaState(slug);
    if (state.isLoading) return state.data;
    if (state.hasLoaded && !forceRefresh) {
      return state.data;
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.fetchBySlug(slug);
      state.setNullableData(result);
      return result;
    } catch (error) {
      state.setError(error);
      return state.data;
    } finally {
      notifyListeners();
    }
  }

  void clear() {
    _lembagaListState.reset();
    _lembagaBySlug.clear();
    notifyListeners();
  }
}
