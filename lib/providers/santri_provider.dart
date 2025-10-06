import 'package:flutter/foundation.dart';

import '../models/santri.dart';
import '../repository/santri_repository.dart';
import 'async_value.dart';

class SantriProvider extends ChangeNotifier {
  SantriProvider({SantriRepository? repository})
      : _repository = repository ?? SantriRepository();

  final SantriRepository _repository;
  final Map<String, AsyncValue<List<Santri>>> _santriStates = {};
  final Map<String, AsyncValue<List<Santri>>> _alumniStates = {};

  AsyncValue<List<Santri>> santriState(String slug) {
    return _santriStates.putIfAbsent(
      slug,
      () => AsyncValue<List<Santri>>(data: const []),
    );
  }

  AsyncValue<List<Santri>> alumniState(String slug, {String? tahunMasuk}) {
    final key = _alumniKey(slug, tahunMasuk);
    return _alumniStates.putIfAbsent(
      key,
      () => AsyncValue<List<Santri>>(data: const []),
    );
  }

  Future<List<Santri>> fetchSantriByLembaga(
    String slug, {
    bool forceRefresh = false,
  }) async {
    final state = santriState(slug);
    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getSantriByLembaga(slug);
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<List<Santri>> fetchAlumniByLembaga(
    String slug, {
    String? tahunMasuk,
    bool forceRefresh = false,
  }) async {
    final state = alumniState(slug, tahunMasuk: tahunMasuk);
    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getAlumniByLembaga(
        slug,
        tahunMasuk: tahunMasuk,
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

  String _alumniKey(String slug, String? tahunMasuk) {
    final tahunKey = tahunMasuk ?? 'all';
    return '$slug|$tahunKey';
  }
}
