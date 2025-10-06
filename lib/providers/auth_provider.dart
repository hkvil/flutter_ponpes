import 'package:flutter/foundation.dart';

import '../repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  bool _isAuthenticating = false;
  String? _authError;

  bool get isAuthenticating => _isAuthenticating;
  String? get authError => _authError;

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    if (_isAuthenticating) return false;

    _isAuthenticating = true;
    _authError = null;
    notifyListeners();

    try {
      final message = await _repository.login(
        identifier: identifier,
        password: password,
      );

      if (message == null) {
        return true;
      }

      _authError = message;
      return false;
    } catch (error) {
      _authError = error.toString();
      return false;
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  void clearError() {
    _authError = null;
    notifyListeners();
  }
}
