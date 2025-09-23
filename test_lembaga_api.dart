import 'dart:io';
import 'dart:convert';

void main() async {
  // Hardcode the values from .env for this test
  final apiHost = 'http://localhost:1337';
  final apiToken =
      '12507733eefafbb3f08ca7214834e625ed0c115e05334ac27ea4e85e8045b39c1c58078b93261810ae5e298c59df627a33b3ddd849811df452d9dd81cf20de76dfb6b5349c3f6adbf3c1179fd25ed6f0a1d61418d20aa015c93325108a05b4121a0f6c046f5f85bdb875b7a569ed4b536e93c39b9e30c35c0d5386cffbdd34a0';

  print('🧪 Testing Lembaga API - Testing the 403 error fix');
  print('📍 API Host: $apiHost');
  print('🔑 API Token length: ${apiToken.length} chars');

  // Test the slug that was causing 403 error
  const testSlug = 'taman-kanak-kanak';

  print('\n📋 Testing fetchBySlug with slug: $testSlug');

  try {
    // Create the URI with proper encoding (our fix)
    final baseUri = Uri.parse('$apiHost/api/lembagas');
    final uri = baseUri.replace(
      queryParameters: {
        'filters[slug][\$eq]': testSlug,
        'populate': '*',
      },
    );

    print('🌐 Final URL: $uri');
    print('📤 Making API request with HttpClient...');

    // Use built-in HTTP client
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(uri);
    request.headers.set('Authorization', 'Bearer $apiToken');

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    print('✅ Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseData = json.decode(responseBody);
      print('📊 Response data keys: ${responseData.keys}');

      if (responseData['data'] != null) {
        final List data = responseData['data'];
        print('📝 Found ${data.length} lembaga(s)');

        if (data.isNotEmpty) {
          final lembaga = data.first;
          print('🎯 Lembaga ID: ${lembaga['id']}');
          print('📛 Lembaga nama: ${lembaga['nama'] ?? 'No name'}');
          print('🔗 Lembaga slug: ${lembaga['slug'] ?? 'No slug'}');
        }
      }
      print('\n🎉 SUCCESS: API call completed without 403 error!');
    } else {
      print('❌ HTTP Error: ${response.statusCode}');
      print('📄 Response body: $responseBody');
    }

    httpClient.close();
  } catch (e) {
    print('❌ Error: $e');
  }

  // Also test other potentially problematic slugs
  final testSlugs = [
    'madrasah-tsanawiyah',
    'sekolah-menengah-atas',
    'pondok-pesantren'
  ];

  print('\n🔄 Testing additional slugs...');

  for (final slug in testSlugs) {
    try {
      final baseUri = Uri.parse('$apiHost/api/lembagas');
      final uri = baseUri.replace(
        queryParameters: {
          'filters[slug][\$eq]': slug,
          'populate': '*',
        },
      );

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(uri);
      request.headers.set('Authorization', 'Bearer $apiToken');

      final response = await request.close();
      print('✅ $slug: Status ${response.statusCode}');
      httpClient.close();
    } catch (e) {
      print('❌ $slug: Error - $e');
    }
  }

  print('\n✨ Test completed!');
  exit(0);
}
