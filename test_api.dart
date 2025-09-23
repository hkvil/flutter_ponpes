import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Test simple API call tanpa Dio
  await testSimpleApiCall();
}

Future<void> testSimpleApiCall() async {
  try {
    final url =
        'http://localhost:1337/api/lembagas?filters[slug][\$eq]=taman-kanak-kanak&populate=*';
    print('🔄 Testing URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 12507733eefafbb3f08ca7214834e625ed0c115e05334ac27ea4e85e8045b39c1c58078b93261810ae5e298c59df627a33b3ddd849811df452d9dd81cf20de76dfb6b5349c3f6adbf3c1179fd25ed6f0a1d61418d20aa015c93325108a05b4121a0f6c046f5f85bdb875b7a569ed4b536e93c39b9e30c35c0d5386cffbdd34a0'
      },
    );

    print('✅ Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('📦 Response: ${data.toString().substring(0, 200)}...');
    } else {
      print('❌ Error: ${response.body}');
    }
  } catch (e) {
    print('🚨 Exception: $e');
  }
}
