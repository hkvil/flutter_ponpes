class SliderModel {
  final List<String> imageUrls;
  SliderModel({required this.imageUrls});

  factory SliderModel.fromJson(Map<String, dynamic> json, String baseUrl) {
    final imagesJson = json['images'] as List<dynamic>? ?? [];
    final urls = imagesJson.map<String>((img) {
      final formats = img['formats'] as Map<String, dynamic>? ?? {};
      var url = formats['medium']?['url'] ?? img['url'] ?? '';
      // Remove '/api' from baseUrl if present
      var cleanBaseUrl = baseUrl;
      if (cleanBaseUrl.endsWith('/api')) {
        cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 4);
      }
      // Ensure only one slash between baseUrl and url
      if (!url.startsWith('http')) {
        if (url.startsWith('/')) {
          url = url.substring(1);
        }
        return cleanBaseUrl.endsWith('/')
            ? cleanBaseUrl + url
            : cleanBaseUrl + '/' + url;
      }
      return url;
    }).toList();
    return SliderModel(imageUrls: urls);
  }
}
