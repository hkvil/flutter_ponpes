import 'package:flutter/foundation.dart';

import '../models/informasi_al_ittifaqiah_model.dart';
import '../repository/informasi_al_ittifaqiah_repository.dart';
import 'async_value.dart';

class InformasiAlIttifaqiahProvider extends ChangeNotifier {
  InformasiAlIttifaqiahProvider({InformasiAlIttifaqiahRepository? repository})
      : _repository = repository ?? InformasiAlIttifaqiahRepository();

  final InformasiAlIttifaqiahRepository _repository;
  final AsyncValue<InformasiAlIttifaqiah?> _informasiState =
      AsyncValue<InformasiAlIttifaqiah?>();

  AsyncValue<InformasiAlIttifaqiah?> get informasiState => _informasiState;

  InformasiAlIttifaqiah? get informasi => _informasiState.data;

  Future<InformasiAlIttifaqiah?> fetchInformasi({
    bool forceRefresh = false,
  }) async {
    if (_informasiState.isLoading) return _informasiState.data;
    if (_informasiState.hasLoaded && !forceRefresh) {
      return _informasiState.data;
    }

    _informasiState.startLoading();
    notifyListeners();

    try {
      final data = await _repository.fetchInformasiAlIttifaqiah();
      _informasiState.setNullableData(data);
      return data;
    } catch (error) {
      _informasiState.setError(error);
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future<List<NewsItem>> fetchNews({bool forceRefresh = false}) async {
    final data = await fetchInformasi(forceRefresh: forceRefresh);
    return data?.news ?? const [];
  }

  Future<Map<String, List<GaleriItem>>> fetchGaleri({
    bool forceRefresh = false,
  }) async {
    final data = await fetchInformasi(forceRefresh: forceRefresh);
    return {
      'galeriTamu': data?.galeriTamu ?? const [],
      'galeriLuarNegeri': data?.galeriLuarNegeri ?? const [],
      'bluePrintISCI': data?.bluePrintISCI ?? const [],
    };
  }

  Future<Map<String, List<StatistikItem>>> fetchStatistik({
    bool forceRefresh = false,
  }) async {
    final data = await fetchInformasi(forceRefresh: forceRefresh);
    return {
      'santri': data?.santri ?? const [],
      'sdm': data?.sdm ?? const [],
      'alumni': data?.alumni ?? const [],
    };
  }

  void clear() {
    _informasiState.reset();
    notifyListeners();
  }
}
