import 'package:flutter/foundation.dart';

import '../models/staff.dart';
import '../repository/staff_repository.dart';
import 'async_value.dart';

class StaffProvider extends ChangeNotifier {
  StaffProvider({StaffRepository? repository})
      : _repository = repository ?? StaffRepository();

  final StaffRepository _repository;
  final Map<String, AsyncValue<List<Staff>>> _staffStates = {};

  AsyncValue<List<Staff>> staffState(String slug) {
    return _staffStates.putIfAbsent(
      slug,
      () => AsyncValue<List<Staff>>(data: const []),
    );
  }

  Future<List<Staff>> fetchStaffByLembaga(
    String slug, {
    bool forceRefresh = false,
  }) async {
    final state = staffState(slug);
    if (state.isLoading) return state.data ?? const [];
    if (state.hasLoaded && !forceRefresh) {
      return state.data ?? const [];
    }

    state.startLoading();
    notifyListeners();

    try {
      final result = await _repository.getStaffByLembaga(slug);
      state.setData(List.unmodifiable(result));
      return result;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }
}
