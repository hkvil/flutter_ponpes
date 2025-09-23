

class AchievementModel {
  final String documentId;
  final String title;
  final String content;
  final String? thumbnailUrl;

  AchievementModel({
    required this.documentId,
    required this.title,
    required this.content,
    this.thumbnailUrl,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json, String apiHost) {
    // Parse thumbnail URL dari nested object
    String? thumbnailUrl;
    if (json['thumbnail'] != null) {
      final thumbnail = json['thumbnail'];
      String? imagePath;

      if (thumbnail['formats'] != null &&
          thumbnail['formats']['thumbnail'] != null) {
        // Gunakan thumbnail format untuk performance
        imagePath = thumbnail['formats']['thumbnail']['url'];
      } else if (thumbnail['url'] != null) {
        // Fallback ke URL utama jika thumbnail format tidak ada
        imagePath = thumbnail['url'];
      }

      if (imagePath != null) {
        thumbnailUrl = imagePath.isNotEmpty ? '$apiHost$imagePath' : null;
      }
    }

    print('thumbnailUrl: $thumbnailUrl');
    print('title: ${json['title']}');
    print('content: ${json['content']}');

    return AchievementModel(
      documentId: json['documentId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      thumbnailUrl: thumbnailUrl,
    );
  }

  static List<AchievementModel> fromJsonList(
      Map<String, dynamic> response, String apiHost) {
    final List<dynamic> data = response['data'] ?? [];
    return data
        .map((item) => AchievementModel.fromJson(item, apiHost))
        .toList();
  }
}
