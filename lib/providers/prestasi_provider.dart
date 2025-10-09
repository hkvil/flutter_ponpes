import 'package:flutter/foundation.dart';

import '../models/prestasi.dart';
import '../repository/prestasi_repository.dart';
import 'async_value.dart';

class PrestasiProvider extends ChangeNotifier {
  PrestasiProvider({PrestasiRepository? repository})
      : _repository = repository ?? PrestasiRepository();

  final PrestasiRepository _repository;
  final Map<String, AsyncValue<List<Prestasi>>> _prestasiStates = {};

  AsyncValue<List<Prestasi>> prestasiState(
    String lembagaSlug, {
    String? tahun,
    String? tingkat,
    String? type,
  }) {
    final key = _buildKey(lembagaSlug, tahun, tingkat, type);
    return _prestasiStates.putIfAbsent(
      key,
      () => AsyncValue<List<Prestasi>>(data: const []),
    );
  }

  Future<List<Prestasi>> fetchPrestasiByLembaga(
    String lembagaSlug, {
    String? tahun,
    String? tingkat,
    String? type,
    bool forceRefresh = false,
  }) async {
    final state = prestasiState(
      lembagaSlug,
      tahun: tahun,
      tingkat: tingkat,
      type: type,
    );

    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    // Remove immediate notifyListeners() to avoid calling during build phase

    try {
      final result = await _repository.getPrestasiByLembaga(
        lembagaSlug,
        tahun: tahun,
        tingkat: tingkat,
        type: type,
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

  String _buildKey(String slug, String? tahun, String? tingkat, String? type) {
    final tahunKey = tahun ?? 'all';
    final tingkatKey = tingkat ?? 'all';
    final typeKey = type ?? 'santri';
    return '$slug|$tahunKey|$tingkatKey|$typeKey';
  }
}
