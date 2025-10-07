import 'package:flutter/foundation.dart';

import '../models/pelanggaran.dart';
import '../repository/pelanggaran_repository.dart';
import 'async_value.dart';

class PelanggaranProvider extends ChangeNotifier {
  PelanggaranProvider({PelanggaranRepository? repository})
      : _repository = repository ?? PelanggaranRepository();

  final PelanggaranRepository _repository;
  final Map<String, AsyncValue<List<Pelanggaran>>> _pelanggaranStates = {};

  AsyncValue<List<Pelanggaran>> pelanggaranState(String slug) {
    return _pelanggaranStates.putIfAbsent(
      slug,
      () => AsyncValue<List<Pelanggaran>>(data: const []),
    );
  }

  Future<List<Pelanggaran>> fetchPelanggaranByLembaga(
    String slug, {
    bool forceRefresh = false,
  }) async {
    final state = pelanggaranState(slug);
    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getPelanggaranByLembaga(slug);
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<List<Pelanggaran>> fetchPelanggaranBySantriId(int santriId) async {
    try {
      return await _repository.getPelanggaranBySantriId(santriId);
    } catch (error) {
      print('Error fetching pelanggaran by santri ID: $error');
      return const [];
    }
  }

  Future<Pelanggaran?> fetchPelanggaranById(int id) async {
    try {
      return await _repository.getPelanggaranById(id);
    } catch (error) {
      print('Error fetching pelanggaran by ID: $error');
      return null;
    }
  }

  void clearData(String slug) {
    _pelanggaranStates.remove(slug);
    notifyListeners();
  }
}
