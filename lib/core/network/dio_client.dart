import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides a pre-configured [Dio] client for the application.
///
/// The client sets a base URL from environment variables, sensible
/// timeouts, and a default JSON content type so repositories can focus on
/// request-specific logic.
class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? Dio(_createBaseOptions());

  final Dio _dio;

  static BaseOptions _createBaseOptions() {
    final apiHost = dotenv.env['API_HOST'];
    final resolvedBaseUrl =
        (apiHost == null || apiHost.isEmpty) ? 'http://localhost:1337' : apiHost;

    return BaseOptions(
      baseUrl: resolvedBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Content-Type': 'application/json',
      },
    );
  }

  /// Returns the configured [Dio] instance.
  Dio get client => _dio;
}
