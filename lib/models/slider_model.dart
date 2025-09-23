class SliderModel {
  final List<String> imageUrls;
  SliderModel({required this.imageUrls});

  factory SliderModel.fromJson(Map<String, dynamic> json, String baseUrl) {
    final imagesJson = json['images'] as List<dynamic>? ?? [];
    final urls = imagesJson.map<String>((img) {
      final formats = img['formats'] as Map<String, dynamic>? ?? {};
      final imagePath = formats['medium']?['url'] ?? img['url'] ?? '';
      return imagePath.isNotEmpty ? '$baseUrl$imagePath' : '';
    }).toList();
    return SliderModel(imageUrls: urls);
  }
}
