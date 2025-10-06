import 'package:flutter/foundation.dart';

import '../models/tahun_ajaran.dart';
import '../repository/tahun_ajaran_repository.dart';
import 'async_value.dart';

class TahunAjaranProvider extends ChangeNotifier {
  TahunAjaranProvider({TahunAjaranRepository? repository})
      : _repository = repository ?? TahunAjaranRepository();

  final TahunAjaranRepository _repository;

  final Map<String, AsyncValue<List<TahunAjaran>>> _listByLembaga = {};
  final Map<String, AsyncValue<TahunAjaran?>> _activeByLembaga = {};
  final Map<String, AsyncValue<TahunAjaran?>> _byNama = {};
  final Map<String, AsyncValue<List<TahunAjaran>>> _byRange = {};
  final Map<int, AsyncValue<TahunAjaran?>> _byId = {};

  AsyncValue<List<TahunAjaran>> listState(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    final key = _listKey(lembagaSlug, page: page, pageSize: pageSize);
    return _listByLembaga.putIfAbsent(
      key,
      () => AsyncValue<List<TahunAjaran>>(data: const []),
    );
  }

  AsyncValue<TahunAjaran?> activeState(String lembagaSlug) {
    return _activeByLembaga.putIfAbsent(
      lembagaSlug,
      () => AsyncValue<TahunAjaran?>(),
    );
  }

  AsyncValue<TahunAjaran?> namaState(String lembagaSlug, String nama) {
    final key = _namaKey(lembagaSlug, nama);
    return _byNama.putIfAbsent(
      key,
      () => AsyncValue<TahunAjaran?>(),
    );
  }

  AsyncValue<List<TahunAjaran>> rangeState(
    String lembagaSlug,
    int startYear,
    int endYear, {
    int? page,
    int? pageSize,
  }) {
    final key = _rangeKey(
      lembagaSlug,
      startYear,
      endYear,
      page: page,
      pageSize: pageSize,
    );
    return _byRange.putIfAbsent(
      key,
      () => AsyncValue<List<TahunAjaran>>(data: const []),
    );
  }

  AsyncValue<TahunAjaran?> idState(int id) {
    return _byId.putIfAbsent(
      id,
      () => AsyncValue<TahunAjaran?>(),
    );
  }

  List<TahunAjaran> cachedList(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    return List.unmodifiable(
      listState(lembagaSlug, page: page, pageSize: pageSize).data ?? const [],
    );
  }

  TahunAjaran? cachedActive(String lembagaSlug) {
    return activeState(lembagaSlug).data;
  }

  TahunAjaran? cachedByNama(String lembagaSlug, String nama) {
    return namaState(lembagaSlug, nama).data;
  }

  TahunAjaran? cachedById(int id) {
    return idState(id).data;
  }

  Future<List<TahunAjaran>> fetchByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
    bool forceRefresh = false,
  }) async {
    final state = listState(lembagaSlug, page: page, pageSize: pageSize);

    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getTahunAjaranByLembaga(
        lembagaSlug,
        page: page,
        pageSize: pageSize,
      );
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<TahunAjaran?> fetchActiveTahunAjaran(
    String lembagaSlug, {
    bool forceRefresh = false,
  }) async {
    final state = activeState(lembagaSlug);

    if (state.isLoading) return state.data;
    if (state.hasLoaded && !forceRefresh) {
      return state.data;
    }

    state.startLoading();
    notifyListeners();

    try {
      final result =
          await _repository.getActiveTahunAjaranByLembaga(lembagaSlug);
      state.setNullableData(result);
      return result;
    } catch (error) {
      state.setError(error);
      return state.data;
    } finally {
      notifyListeners();
    }
  }

  Future<TahunAjaran?> fetchByNama(
    String lembagaSlug,
    String nama, {
    bool forceRefresh = false,
  }) async {
    final state = namaState(lembagaSlug, nama);

    if (state.isLoading) return state.data;
    if (state.hasLoaded && !forceRefresh) {
      return state.data;
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getTahunAjaranByNama(
        lembagaSlug,
        nama,
      );
      state.setNullableData(result);
      return result;
    } catch (error) {
      state.setError(error);
      return state.data;
    } finally {
      notifyListeners();
    }
  }

  Future<List<TahunAjaran>> fetchByYearRange(
    String lembagaSlug,
    int startYear,
    int endYear, {
    int? page,
    int? pageSize,
    bool forceRefresh = false,
  }) async {
    final state = rangeState(
      lembagaSlug,
      startYear,
      endYear,
      page: page,
      pageSize: pageSize,
    );

    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getTahunAjaranByYearRange(
        lembagaSlug,
        startYear,
        endYear,
        page: page,
        pageSize: pageSize,
      );
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<TahunAjaran?> fetchById(
    int id, {
    bool forceRefresh = false,
  }) async {
    final state = idState(id);

    if (state.isLoading) return state.data;
    if (state.hasLoaded && !forceRefresh) {
      return state.data;
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getTahunAjaranById(id);
      state.setNullableData(result);
      return result;
    } catch (error) {
      state.setError(error);
      return state.data;
    } finally {
      notifyListeners();
    }
  }

  void clearCache() {
    _listByLembaga.clear();
    _activeByLembaga.clear();
    _byNama.clear();
    _byRange.clear();
    _byId.clear();
    notifyListeners();
  }

  String _listKey(
    String lembagaSlug, {
    int? page,
    int? pageSize,
  }) {
    final normalizedSlug = lembagaSlug.toLowerCase();
    final pageLabel = page?.toString() ?? 'default';
    final sizeLabel = pageSize?.toString() ?? 'default';
    return '$normalizedSlug|page:$pageLabel|size:$sizeLabel';
  }

  String _namaKey(String lembagaSlug, String nama) {
    return '${lembagaSlug.toLowerCase()}|${nama.toLowerCase()}';
  }

  String _rangeKey(
    String lembagaSlug,
    int startYear,
    int endYear, {
    int? page,
    int? pageSize,
  }) {
    final pageLabel = page?.toString() ?? 'default';
    final sizeLabel = pageSize?.toString() ?? 'default';
    return '${lembagaSlug.toLowerCase()}|$startYear-$endYear|page:$pageLabel|size:$sizeLabel';
  }
}
