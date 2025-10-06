import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/network/dio_client.dart';

/// Base class providing shared networking utilities for repositories.
abstract class BaseRepository {
  BaseRepository({Dio? dio}) : dio = dio ?? DioClient().client;

  static const _storage = FlutterSecureStorage();

  /// Configured Dio client that reuses the shared application settings.
  final Dio dio;

  /// Builds [Options] with default JSON headers and optional bearer auth.
  Options buildOptions({
    Map<String, String>? headers,
    bool includeAuthorization = true,
  }) {
    final resolvedHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (includeAuthorization) ..._authorizationHeader(),
      if (headers != null) ...headers,
    };

    return Options(headers: resolvedHeaders);
  }

  /// Builds [Options] with JWT from secure storage for authenticated requests.
  Future<Options> buildAuthenticatedOptions({
    Map<String, String>? headers,
  }) async {
    final resolvedHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...await _asyncAuthorizationHeader(),
      if (headers != null) ...headers,
    };

    return Options(headers: resolvedHeaders);
  }

  /// Ensures the provided response body can be treated as a map.
  Map<String, dynamic> ensureMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is String && data.isNotEmpty) {
      final decoded = json.decode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }

    throw Exception('Invalid response format.');
  }

  /// Converts Dio specific errors into a concise message.
  String mapDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final statusMessage = error.response?.statusMessage ?? 'Unknown error';
      return 'Status $statusCode: $statusMessage';
    }

    return error.message ?? 'Unexpected network error';
  }

  /// Returns the base URL configured for the Dio client.
  String get baseUrl => dio.options.baseUrl;

  Map<String, String> _authorizationHeader() {
    final token = dotenv.env['API_TOKEN_READONLY'];
    if (token != null && token.isNotEmpty) {
      return {'Authorization': 'Bearer $token'};
    }
    return const {};
  }

  /// Returns authorization header using JWT from secure storage.
  Future<Map<String, String>> _asyncAuthorizationHeader() async {
    try {
      final jwt = await _storage.read(key: 'jwt');
      if (jwt != null && jwt.isNotEmpty) {
        return {'Authorization': 'Bearer $jwt'};
      }
    } catch (e) {
      print('⚠️ [AUTH] Failed to read JWT from storage: $e');
    }
    return const {};
  }
}
