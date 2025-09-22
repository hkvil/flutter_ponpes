/// Konfigurasi global & helper untuk akses Strapi.
///
/// Set lewat --dart-define saat run/build:
///   flutter run \
///     --dart-define=STRAPI_BASE_URL=https://cms.example.com \
///     --dart-define=STRAPI_TOKEN=YOUR_TOKEN
///
/// Jika tidak diset, default ke http://localhost:1337 (dev lokal).
import 'package:dio/dio.dart';

class AppConfig {
  static Dio dio = Dio(BaseOptions(
    baseUrl: strapiBaseUrl,
    connectTimeout: Duration(milliseconds: connectTimeoutMs),
    receiveTimeout: Duration(milliseconds: readTimeoutMs),
    headers: {
      'Content-Type': 'application/json',
      if (strapiToken.isNotEmpty) 'Authorization': 'Bearer $strapiToken',
    },
  ));

  /// Base URL Strapi (boleh tanpa trailing slash).
  static const strapiBaseUrl = String.fromEnvironment(
    'STRAPI_BASE_URL',
    defaultValue: 'http://localhost:1337',
  );

  /// Token Strapi (opsional). Kosongkan jika API public.
  static const strapiToken = String.fromEnvironment(
    'STRAPI_TOKEN',
    defaultValue: '',
  );

  /// Ukuran default pagination saat list.
  static const defaultPageSize = int.fromEnvironment(
    'PAGE_SIZE',
    defaultValue: 200,
  );

  /// Timeout opsional (ms) kalau nanti ingin dipakai di http client.
  static const connectTimeoutMs = int.fromEnvironment(
    'CONNECT_TIMEOUT_MS',
    defaultValue: 10000,
  );
  static const readTimeoutMs = int.fromEnvironment(
    'READ_TIMEOUT_MS',
    defaultValue: 20000,
  );

  /// Build URI ke endpoint API Strapi dengan query map.
  /// Contoh:
  ///   final uri = AppConfig.apiUri('/api/lembagas', {
  ///     'fields[0]': 'nama',
  ///     'fields[1]': 'slug',
  ///     'sort': 'nama:asc',
  ///     'pagination[pageSize]': AppConfig.defaultPageSize,
  ///   });
  static Uri apiUri(String path, [Map<String, dynamic>? query]) {
    final base = _trimTrailingSlash(strapiBaseUrl);
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p')
        .replace(queryParameters: _stringifyQuery(query));
  }

  /// Header default untuk HTTP request (JSON).
  /// Auto menambahkan Authorization Bearer jika token tersedia.
  static Map<String, String> headers([Map<String, String>? extra]) {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (strapiToken.isNotEmpty) h['Authorization'] = 'Bearer $strapiToken';
    if (extra != null) h.addAll(extra);
    return h;
  }

  /// Normalisasi URL relatif (dari Strapi upload) menjadi absolut.
  /// - '/uploads/x.jpg' -> 'https://base/uploads/x.jpg'
  /// - 'http(s)://...' -> tetap
  static String absoluteUrl(String maybeRelative) {
    if (maybeRelative.isEmpty) return '';
    final u = maybeRelative;
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    final base = _trimTrailingSlash(strapiBaseUrl);
    if (u.startsWith('/')) return '$base$u';
    return '$base/$u';
  }

  // =======================
  // Helpers private
  // =======================
  static String _trimTrailingSlash(String s) =>
      s.endsWith('/') ? s.substring(0, s.length - 1) : s;

  static Map<String, String>? _stringifyQuery(Map<String, dynamic>? q) {
    if (q == null || q.isEmpty) return null;
    final out = <String, String>{};
    q.forEach((k, v) {
      if (v == null) return;
      if (v is Iterable) {
        out[k] = v.join(',');
      } else {
        out[k] = '$v';
      }
    });
    return out;
  }
}
