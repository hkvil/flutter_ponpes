import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../repository/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository() {
    _initAuth();
  }

  final AuthRepository _repository;
  final _storage = const FlutterSecureStorage();

  // State untuk proses otentikasi
  bool _isAuthenticating = false;
  String? _authError;

  // State untuk sesi pengguna
  bool _isLoggedIn = false;
  User? _user;
  bool _isInitialized = false;

  // Getters
  bool get isAuthenticating => _isAuthenticating;
  String? get authError => _authError;
  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  bool get isInitialized => _isInitialized;

  // Cek status login saat aplikasi dimulai
  Future<void> _initAuth() async {
    final storedToken = await _storage.read(key: 'jwt');
    if (storedToken != null) {
      await _fetchAndSetUser();
    } else {
      _isLoggedIn = false;
    }
    _isInitialized = true;
    notifyListeners();
  }

  // Helper untuk mengambil data user dan set state
  Future<void> _fetchAndSetUser() async {
    final userData = await _repository.fetchCurrentUser();
    if (userData != null) {
      _user = User.fromJson(userData);
      _isLoggedIn = true;
      await _storage.write(key: 'user_data', value: jsonEncode(userData));
    } else {
      await logout();
    }
    notifyListeners();
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    if (_isAuthenticating) return false;

    _isAuthenticating = true;
    _authError = null;
    notifyListeners();

    try {
      final errorMessage = await _repository.login(
        identifier: identifier,
        password: password,
      );

      if (errorMessage == null) {
        await _fetchAndSetUser();
        return _isLoggedIn;
      } else {
        _authError = errorMessage;
        return false;
      }
    } catch (error) {
      _authError = error.toString();
      return false;
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthRepository.clearAuthData();
    _isLoggedIn = false;
    _user = null;
    await _storage.delete(key: 'user_data');
    notifyListeners();
  }

  void clearError() {
    _authError = null;
    notifyListeners();
  }
}
