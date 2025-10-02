import 'package:flutter_dotenv/flutter_dotenv.dart';

// Helper function to resolve relative URLs
String _absoluteUrl(String maybeRelative) {
  if (maybeRelative.isEmpty) return '';
  if (maybeRelative.startsWith('http://') ||
      maybeRelative.startsWith('https://')) {
    return maybeRelative;
  }
  final baseUrl = dotenv.env['API_HOST'] ?? 'http://localhost:1337';
  final cleanBase = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;
  if (maybeRelative.startsWith('/')) {
    return '$cleanBase$maybeRelative';
  }
  return '$cleanBase/$maybeRelative';
}

class BannerMenuUtama {
  final int id;
  final String documentId;
  final String title;
  final String? topBannerUrl;
  final String? bottomBannerUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  BannerMenuUtama({
    required this.id,
    required this.documentId,
    required this.title,
    this.topBannerUrl,
    this.bottomBannerUrl,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  String get resolvedTopBannerUrl => _absoluteUrl(topBannerUrl ?? '');
  String get resolvedBottomBannerUrl => _absoluteUrl(bottomBannerUrl ?? '');

  factory BannerMenuUtama.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] is Map
        ? (json['attributes'] as Map).cast<String, dynamic>()
        : json;

    DateTime? _parseDate(dynamic v) {
      if (v is String && v.isNotEmpty) {
        try {
          return DateTime.parse(v);
        } catch (_) {}
      }
      return null;
    }

    String? _extractBannerUrl(dynamic bannerData) {
      if (bannerData == null) return null;
      if (bannerData is String) return bannerData;
      if (bannerData is! Map) return null;

      final m = bannerData as Map<String, dynamic>;

      // Try direct url
      String? url = m['url'] as String?;
      if (url?.isNotEmpty == true) return url;

      // Try formats
      final formats = m['formats'] as Map<String, dynamic>?;
      if (formats != null) {
        url = formats['medium']?['url'] as String? ??
            formats['small']?['url'] as String? ??
            formats['large']?['url'] as String? ??
            formats['thumbnail']?['url'] as String?;
        if (url?.isNotEmpty == true) return url;
      }

      return null;
    }

    return BannerMenuUtama(
      id: (json['id'] ?? attrs['id'] ?? 0) as int,
      documentId: (json['documentId'] ?? attrs['documentId'] ?? '') as String,
      title: (attrs['title'] ?? '') as String,
      topBannerUrl: _extractBannerUrl(attrs['topBanner']),
      bottomBannerUrl: _extractBannerUrl(attrs['bottomBanner']),
      createdAt: _parseDate(attrs['createdAt']),
      updatedAt: _parseDate(attrs['updatedAt']),
      publishedAt: _parseDate(attrs['publishedAt']),
    );
  }

  static List<BannerMenuUtama> listFromStrapiEnvelope(
      Map<String, dynamic> body) {
    final data = (body['data'] as List?) ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(BannerMenuUtama.fromJson)
        .toList();
  }
}
