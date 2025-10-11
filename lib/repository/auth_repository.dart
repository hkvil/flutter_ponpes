import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'base_repository.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({Dio? dio}) : super(dio: dio);

  static const _storage = FlutterSecureStorage();

  /// Token expiry duration in hours (default: 24 hours = 1 day)
  static const int _tokenExpiryHours = 24;

  /// Get token expiry duration from environment or use default
  static int get tokenExpiryHours {
    final envValue = dotenv.env['JWT_EXPIRY_HOURS'];
    if (envValue != null) {
      final parsed = int.tryParse(envValue);
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }
    return _tokenExpiryHours;
  }

  /// Check if the stored JWT token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final loginTimeStr = await _storage.read(key: 'jwt_login_time');
      if (loginTimeStr == null) {
        print(
            '⏰ [TOKEN_EXPIRY] No login time found - token considered expired');
        return true;
      }

      final loginTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(loginTimeStr));
      final now = DateTime.now();
      final expiryDuration = Duration(hours: tokenExpiryHours);
      final expiryTime = loginTime.add(expiryDuration);

      final isExpired = now.isAfter(expiryTime);
      final remainingTime = expiryTime.difference(now);

      print('⏰ [TOKEN_EXPIRY] Token expiry check:');
      print('⏰ [TOKEN_EXPIRY] - Login time: $loginTime');
      print('⏰ [TOKEN_EXPIRY] - Current time: $now');
      print('⏰ [TOKEN_EXPIRY] - Expiry duration: ${tokenExpiryHours} hours');
      print('⏰ [TOKEN_EXPIRY] - Expiry time: $expiryTime');
      print('⏰ [TOKEN_EXPIRY] - Is expired: $isExpired');

      if (!isExpired && remainingTime.inMinutes < 60) {
        print(
            '⏰ [TOKEN_EXPIRY] - Remaining time: ${remainingTime.inMinutes} minutes');
      }

      return isExpired;
    } catch (e) {
      print('⏰ [TOKEN_EXPIRY] Error checking token expiry: $e');
      return true; // Consider expired if error occurs
    }
  }

  /// Test koneksi ke API endpoint
  static Future<void> testApiConnection() async {
    final apiHost = dotenv.env['API_HOST']!;
    print('🔗 [API_TEST] Testing connection to: $apiHost');

    final repo = AuthRepository();
    try {
      final response = await repo.dio.get(
        '/api/users/me',
        options: await repo.buildAuthenticatedOptions(),
      );
      print('🔗 [API_TEST] ✅ API accessible, status: ${response.statusCode}');
    } catch (e) {
      print('🔗 [API_TEST] ❌ API connection failed: $e');
      if (e is DioException) {
        print('🔗 [API_TEST] - Error type: ${e.type}');
        print('🔗 [API_TEST] - Message: ${e.message}');
      }
    }
  }

  /// Melakukan login ke Strapi dan simpan JWT + waktu login.
  Future<String?> login({
    required String identifier,
    required String password,
  }) async {
    const url = '/api/auth/local';

    print('🔐 [AUTH] Starting login process...');
    print('🔐 [AUTH] Base URL: $baseUrl');
    print('🔐 [AUTH] Login URL: $url');
    print('🔐 [AUTH] Identifier: $identifier');
    print('🔐 [AUTH] Password length: ${password.length}');

    try {
      print('🔐 [AUTH] Sending POST request...');
      final response = await dio.post(
        url,
        data: {
          'identifier': identifier,
          'password': password,
        },
        options: buildOptions(includeAuthorization: false),
      );

      final data = ensureMap(response.data);

      print('🔐 [AUTH] Response received');
      print('🔐 [AUTH] Status Code: ${response.statusCode}');
      print('🔐 [AUTH] Response Headers: ${response.headers}');
      print('🔐 [AUTH] Response Data: $data');

      if (response.statusCode == 200 && data['jwt'] != null) {
        final jwt = data['jwt'] as String;
        print('🔐 [AUTH] ✅ Login successful! JWT received');
        print('🔐 [AUTH] JWT length: ${jwt.length}');
        print(
            '🔐 [AUTH] JWT preview: ${jwt.substring(0, jwt.length > 20 ? 20 : jwt.length)}...');

        await _storage.write(key: 'jwt', value: jwt);
        await _storage.write(
          key: 'jwt_login_time',
          value: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        print('🔐 [AUTH] ✅ JWT and timestamp saved to secure storage');
        return null; // sukses
      } else {
        final error = data['error'];
        final errorMsg = error is Map<String, dynamic>
            ? error['message'] ?? 'Login gagal'
            : 'Login gagal';
        print('🔐 [AUTH] ❌ Login failed: $errorMsg');
        return errorMsg;
      }
    } on DioException catch (e) {
      print('🔐 [AUTH] ❌ DioException details:');
      print('🔐 [AUTH] - Type: ${e.type}');
      print('🔐 [AUTH] - Message: ${e.message}');
      print('🔐 [AUTH] - Response Status: ${e.response?.statusCode}');
      print('🔐 [AUTH] - Response Data: ${e.response?.data}');
      print('🔐 [AUTH] - Response Headers: ${e.response?.headers}');

      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        return responseData['error']?['message'] ?? 'Login gagal';
      }
      return 'Login gagal: ${mapDioError(e)}';
    } catch (e) {
      print('🔐 [AUTH] ❌ Exception occurred: ${e.runtimeType}');
      print('🔐 [AUTH] ❌ Exception details: $e');
      return 'Login gagal: $e';
    }
  }

  /// Mengambil data pengguna yang sedang login menggunakan token yang tersimpan.
  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    // Check if token is expired first
    final tokenExpired = await isTokenExpired();
    if (tokenExpired) {
      print('❌ [AUTH] Token expired, clearing auth data');
      await clearAuthData();
      return null;
    }

    try {
      final response = await dio.get(
        '/api/users/me',
        options:
            await buildAuthenticatedOptions(), // Menggunakan JWT dari secure storage
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ [AUTH] Failed to fetch current user: $e');
      // If we get 401, token might be invalid/expired, clear auth data
      if (e is DioException && e.response?.statusCode == 401) {
        print('❌ [AUTH] 401 Unauthorized - clearing auth data');
        await clearAuthData();
      }
      return null;
    }
  }

  /// Debug method untuk memeriksa JWT yang tersimpan
  static Future<void> debugStoredJWT() async {
    print('📱 [STORAGE_DEBUG] ===== JWT Storage Debug =====');

    try {
      final jwt = await _storage.read(key: 'jwt');
      final loginTime = await _storage.read(key: 'jwt_login_time');

      if (jwt != null) {
        print('📱 [STORAGE_DEBUG] ✅ JWT found in storage');
        print('📱 [STORAGE_DEBUG] JWT length: ${jwt.length}');
        print(
            '📱 [STORAGE_DEBUG] JWT preview: ${jwt.substring(0, jwt.length > 20 ? 20 : jwt.length)}...');

        if (loginTime != null) {
          final loginDateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(loginTime));
          final now = DateTime.now();
          final duration = now.difference(loginDateTime);
          final expiryDuration = Duration(hours: tokenExpiryHours);
          final expiryTime = loginDateTime.add(expiryDuration);
          final isExpired = now.isAfter(expiryTime);

          print('📱 [STORAGE_DEBUG] Login time: $loginDateTime');
          print(
              '📱 [STORAGE_DEBUG] Time since login: ${duration.inMinutes} minutes ago');
          print('📱 [STORAGE_DEBUG] Token expiry: ${tokenExpiryHours} hours');
          print('📱 [STORAGE_DEBUG] Expiry time: $expiryTime');
          print('📱 [STORAGE_DEBUG] Is expired: $isExpired');

          if (!isExpired) {
            final remaining = expiryTime.difference(now);
            print(
                '📱 [STORAGE_DEBUG] Remaining time: ${remaining.inHours} hours ${remaining.inMinutes % 60} minutes');
          }
        } else {
          print('📱 [STORAGE_DEBUG] ⚠️ JWT found but no login time recorded');
        }
      } else {
        print('📱 [STORAGE_DEBUG] ❌ No JWT found in storage');
      }
    } catch (e) {
      print('📱 [STORAGE_DEBUG] ❌ Error reading from storage: $e');
    }

    print('📱 [STORAGE_DEBUG] ===============================');
  }

  /// Clear all auth data (for debugging)
  static Future<void> clearAuthData() async {
    print('🗑️ [AUTH_CLEAR] Clearing all auth data...');
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'jwt_login_time');
    print('🗑️ [AUTH_CLEAR] ✅ Auth data cleared');
  }
}
