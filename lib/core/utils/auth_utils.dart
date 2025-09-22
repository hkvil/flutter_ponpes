import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/detail_lists.dart';

/// Returns the correct detail menu items for a given title and item.
List<String> getDetailMenuItems(String title) {
  print(title);
  if (title == 'Organ Penyelenggara Pendidikan Formal') {
    return menuItemsJenis2;
  }
  return menuItemsJenis1;
}

/// Mengecek status login dan expired token JWT.
/// [expiredDurationMs] default 24 jam.
Future<bool> checkIsLoggedIn(
    {int expiredDurationMs = 24 * 60 * 60 * 1000}) async {
  final storage = FlutterSecureStorage();
  final jwt = await storage.read(key: 'jwt');
  final loginTimeStr = await storage.read(key: 'jwt_login_time');
  if (jwt != null && jwt.isNotEmpty && loginTimeStr != null) {
    final loginTime = int.tryParse(loginTimeStr) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - loginTime < expiredDurationMs) {
      return true;
    } else {
      await storage.delete(key: 'jwt');
      await storage.delete(key: 'jwt_login_time');
    }
  }
  return false;
}
