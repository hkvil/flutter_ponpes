import 'package:flutter/foundation.dart';

import '../models/kehadiran_guru.dart';
import '../models/kehadiran_santri.dart';
import '../repository/kehadiran_repository.dart';
import 'async_value.dart';

class KehadiranProvider extends ChangeNotifier {
  KehadiranProvider({KehadiranRepository? repository})
      : _repository = repository ?? KehadiranRepository();

  final KehadiranRepository _repository;

  final Map<String, AsyncValue<List<KehadiranSantri>>> _santriStates = {};
  final Map<String, AsyncValue<List<KehadiranGuru>>> _guruStates = {};

  AsyncValue<List<KehadiranSantri>> santriState(
    String lembagaSlug, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final key = _santriKey(lembagaSlug, startDate, endDate);
    return _santriStates.putIfAbsent(
      key,
      () => AsyncValue<List<KehadiranSantri>>(data: const []),
    );
  }

  AsyncValue<List<KehadiranGuru>> guruState(
    String lembagaSlug, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final key = _guruKey(lembagaSlug, startDate, endDate);
    return _guruStates.putIfAbsent(
      key,
      () => AsyncValue<List<KehadiranGuru>>(data: const []),
    );
  }

  Future<List<KehadiranSantri>> fetchSantriByLembaga(
    String lembagaSlug, {
    bool forceRefresh = false,
  }) async {
    return _loadSantri(
      lembagaSlug,
      null,
      null,
      () => _repository.getKehadiranSantriByLembaga(lembagaSlug),
      forceRefresh: forceRefresh,
    );
  }

  Future<List<KehadiranSantri>> fetchSantriByDateRange(
    String lembagaSlug,
    DateTime startDate,
    DateTime endDate, {
    bool forceRefresh = false,
  }) async {
    return _loadSantri(
      lembagaSlug,
      startDate,
      endDate,
      () => _repository.getKehadiranSantriByDateRange(
        lembagaSlug,
        startDate,
        endDate,
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<List<KehadiranGuru>> fetchGuruByLembaga(
    String lembagaSlug, {
    bool forceRefresh = false,
  }) async {
    return _loadGuru(
      lembagaSlug,
      null,
      null,
      () => _repository.getKehadiranGuruByLembaga(lembagaSlug),
      forceRefresh: forceRefresh,
    );
  }

  Future<List<KehadiranGuru>> fetchGuruByDateRange(
    String lembagaSlug,
    DateTime startDate,
    DateTime endDate, {
    bool forceRefresh = false,
  }) async {
    return _loadGuru(
      lembagaSlug,
      startDate,
      endDate,
      () => _repository.getKehadiranGuruByDateRange(
        lembagaSlug,
        startDate,
        endDate,
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<List<KehadiranSantri>> _loadSantri(
    String slug,
    DateTime? start,
    DateTime? end,
    Future<List<KehadiranSantri>> Function() loader, {
    bool forceRefresh = false,
  }) async {
    final state = santriState(slug, startDate: start, endDate: end);
    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await loader();
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<List<KehadiranGuru>> _loadGuru(
    String slug,
    DateTime? start,
    DateTime? end,
    Future<List<KehadiranGuru>> Function() loader, {
    bool forceRefresh = false,
  }) async {
    final state = guruState(slug, startDate: start, endDate: end);
    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await loader();
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  String _santriKey(String slug, DateTime? start, DateTime? end) {
    final startKey = start?.toIso8601String() ?? '';
    final endKey = end?.toIso8601String() ?? '';
    return 'santri|$slug|$startKey|$endKey';
  }

  String _guruKey(String slug, DateTime? start, DateTime? end) {
    final startKey = start?.toIso8601String() ?? '';
    final endKey = end?.toIso8601String() ?? '';
    return 'guru|$slug|$startKey|$endKey';
  }
}
