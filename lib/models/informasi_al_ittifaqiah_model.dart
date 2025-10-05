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

class InformasiAlIttifaqiah {
  final int id;
  final String? documentId;
  final String? profilMd;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final List<GaleriItem> galeriTamu;
  final List<GaleriItem> galeriLuarNegeri;
  final List<GaleriItem> bluePrintISCI;
  final List<NewsItem> news;
  final List<StatistikItem> santri;
  final List<StatistikItem> sdm;
  final List<StatistikItem> alumni;

  InformasiAlIttifaqiah({
    required this.id,
    this.documentId,
    this.profilMd,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.galeriTamu = const [],
    this.galeriLuarNegeri = const [],
    this.bluePrintISCI = const [],
    this.news = const [],
    this.santri = const [],
    this.sdm = const [],
    this.alumni = const [],
  });

  /// Parse dari JSON response API
  factory InformasiAlIttifaqiah.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDateTime(dynamic value) {
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing date: $value');
        }
      }
      return null;
    }

    List<T> _parseList<T>(
        dynamic value, T Function(Map<String, dynamic>) parser) {
      if (value is List) {
        return value.whereType<Map<String, dynamic>>().map(parser).toList();
      }
      return <T>[];
    }

    return InformasiAlIttifaqiah(
      id: (json['id'] ?? 0) as int,
      documentId: json['documentId'] as String?,
      profilMd: json['profilMd'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      publishedAt: _parseDateTime(json['publishedAt']),
      galeriTamu: _parseList(json['galeriTamu'], GaleriItem.fromJson),
      galeriLuarNegeri:
          _parseList(json['galeriLuarNegeri'], GaleriItem.fromJson),
      bluePrintISCI: _parseList(json['bluePrintISCI'], GaleriItem.fromJson),
      news: _parseList(json['news'], NewsItem.fromJson),
      santri: _parseList(json['santri'], StatistikItem.fromJson),
      sdm: _parseList(json['sdm'], StatistikItem.fromJson),
      alumni: _parseList(json['alumni'], StatistikItem.fromJson),
    );
  }

  // Helper methods
  bool hasProfilContent() => profilMd != null && profilMd!.isNotEmpty;
}

class GaleriItem {
  final int? id;
  final String title;
  final String? desc;
  final String? date;
  final int? order;
  final MediaItem? media;

  GaleriItem({
    this.id,
    required this.title,
    this.desc,
    this.date,
    this.order,
    this.media,
  });

  factory GaleriItem.fromJson(Map<String, dynamic> json) {
    return GaleriItem(
      id: json['id'] as int?,
      title: (json['title'] ?? '') as String,
      desc: json['desc'] as String?,
      date: json['date'] as String?,
      order: json['order'] as int?,
      media: json['media'] != null ? MediaItem.fromJson(json['media']) : null,
    );
  }

  String get imageUrl => media?.resolvedUrl ?? '';
}

class MediaItem {
  final int id;
  final String? documentId;
  final String name;
  final String? alternativeText;
  final String? caption;
  final int? width;
  final int? height;
  final Map<String, dynamic>? formats;
  final String url;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  MediaItem({
    required this.id,
    this.documentId,
    required this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    required this.url,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  String get resolvedUrl => _absoluteUrl(url);

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDateTime(dynamic value) {
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing date: $value');
        }
      }
      return null;
    }

    return MediaItem(
      id: (json['id'] ?? 0) as int,
      documentId: json['documentId'] as String?,
      name: (json['name'] ?? '') as String,
      alternativeText: json['alternativeText'] as String?,
      caption: json['caption'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      formats: json['formats'] as Map<String, dynamic>?,
      url: (json['url'] ?? '') as String,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      publishedAt: _parseDateTime(json['publishedAt']),
    );
  }

  // Get thumbnail URL from formats
  String get thumbnailUrl {
    if (formats != null) {
      final thumbnail = formats!['thumbnail'];
      if (thumbnail is Map && thumbnail['url'] is String) {
        return _absoluteUrl(thumbnail['url'] as String);
      }
      final small = formats!['small'];
      if (small is Map && small['url'] is String) {
        return _absoluteUrl(small['url'] as String);
      }
    }
    return resolvedUrl;
  }
}

class NewsItem {
  final int id;
  final String title;
  final String content;
  final MediaItem? thumbnail;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    this.thumbnail,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      // Handle typo in API: "thubmnail" instead of "thumbnail"
      thumbnail: json['thubmnail'] != null
          ? MediaItem.fromJson(json['thubmnail'])
          : (json['thumbnail'] != null
              ? MediaItem.fromJson(json['thumbnail'])
              : null),
    );
  }

  String get thumbnailUrl => thumbnail?.thumbnailUrl ?? '';
}

class StatistikItem {
  final int id;
  final String tahun;
  final String jumlah;

  StatistikItem({
    required this.id,
    required this.tahun,
    required this.jumlah,
  });

  factory StatistikItem.fromJson(Map<String, dynamic> json) {
    return StatistikItem(
      id: (json['id'] ?? 0) as int,
      tahun: (json['tahun'] ?? '') as String,
      jumlah: (json['jumlah'] ?? '') as String,
    );
  }

  int get jumlahInt {
    try {
      return int.parse(jumlah);
    } catch (e) {
      return 0;
    }
  }
}
