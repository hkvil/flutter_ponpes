import 'package:flutter/foundation.dart';

import '../repository/kelas_repository.dart';
import 'async_value.dart';

class KelasProvider extends ChangeNotifier {
  KelasProvider({KelasRepository? repository})
      : _repository = repository ?? KelasRepository();

  final KelasRepository _repository;
  final Map<String, AsyncValue<List<String>>> _kelasBySlug = {};

  AsyncValue<List<String>> kelasState(String slug) {
    return _kelasBySlug.putIfAbsent(
      slug,
      () => AsyncValue<List<String>>(data: const []),
    );
  }

  List<String> kelasList(String slug) {
    final state = kelasState(slug);
    return List.unmodifiable(state.data ?? const []);
  }

  Future<List<String>> fetchKelas(
    String slug, {
    int pageSize = 100,
    bool forceRefresh = false,
  }) async {
    final state = kelasState(slug);

    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getKelasByLembaga(
        slug,
        pageSize: pageSize,
      );
      final kelasNames = result
          .map((kelas) => kelas.namaKelas)
          .where((name) => name.isNotEmpty)
          .toList();
      state.setData(List.unmodifiable(kelasNames));
      return kelasNames;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  void clearForSlug(String slug) {
    _kelasBySlug.remove(slug);
    notifyListeners();
  }
}
