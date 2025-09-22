import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  static const _storage = FlutterSecureStorage();

  /// Melakukan login ke Strapi dan simpan JWT + waktu login.
  Future<String?> login(
      {required String identifier, required String password}) async {
    final apiHost = dotenv.env['API_HOST'] ?? '';
    final url = '$apiHost/auth/local';
    try {
      final response = await Dio().post(
        url,
        data: {
          'identifier': identifier,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 && response.data['jwt'] != null) {
        final jwt = response.data['jwt'] as String;
        await _storage.write(key: 'jwt', value: jwt);
        await _storage.write(
          key: 'jwt_login_time',
          value: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        return null; // sukses
      } else {
        return response.data['error']?['message'] ?? 'Login gagal';
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data['error']?['message'] ?? 'Login gagal';
      }
      return 'Login gagal: ${e.toString()}';
    }
  }
}
