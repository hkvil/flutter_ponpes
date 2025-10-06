import 'package:flutter/foundation.dart';

import '../models/donasi_model.dart';
import '../repository/donasi_repository.dart';

class DonasiProvider extends ChangeNotifier {
  DonasiProvider({DonasiRepository? repository})
      : _repository = repository ?? DonasiRepository();

  final DonasiRepository _repository;

  List<DonasiModel> _donations = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoadedOnce = false;

  List<DonasiModel> get donations => List.unmodifiable(_donations);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDonations({int pageSize = 50, bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_hasLoadedOnce && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getDonations(pageSize: pageSize);
      _donations = response.data;
      _hasLoadedOnce = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDonations({int pageSize = 50}) async {
    _hasLoadedOnce = false;
    await fetchDonations(pageSize: pageSize, forceRefresh: true);
  }
}
