import '../config.dart';

class Lembaga {
  final int id;
  final String? documentId;
  final String nama;
  final String slug;
  final String? profilMd;
  final String? programKerjaMd;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final List<ImageItem> images;
  final List<VideoItem> videos;
  final List<KontakItem> kontak;

  Lembaga({
    required this.id,
    required this.documentId,
    required this.nama,
    required this.slug,
    this.profilMd,
    this.programKerjaMd,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.images = const [],
    this.videos = const [],
    this.kontak = const [],
  });

  /// Menerima JSON **flat** (seperti contohmu) atau **envelope Strapi** ({id, attributes:{...}}).
  factory Lembaga.fromJson(Map<String, dynamic> json) {
    final attrs = (json['attributes'] is Map)
        ? (json['attributes'] as Map).cast<String, dynamic>()
        : json;

    int _id() {
      if (json['id'] is int) return json['id'] as int;
      if (attrs['id'] is int) return attrs['id'] as int;
      return 0;
    }

    DateTime? _dt(dynamic v) {
      if (v is String && v.isNotEmpty) {
        try {
          return DateTime.parse(v);
        } catch (_) {}
      }
      return null;
    }

    List<T> _list<T>(dynamic v, T Function(dynamic) mapFn) {
      if (v is List) return v.map(mapFn).toList();
      // Bentuk media standar Strapi: { data: [ ... ] }
      if (v is Map && v['data'] is List) {
        return (v['data'] as List).map(mapFn).toList();
      }
      return const [];
    }

    return Lembaga(
      id: _id(),
      documentId: (json['documentId'] ?? attrs['documentId']) as String?,
      nama: (attrs['nama'] ?? '') as String,
      slug: (attrs['slug'] ?? '') as String,
      profilMd: attrs['profilMd'] as String?,
      programKerjaMd: attrs['programKerjaMd'] as String?,
      createdAt: _dt(attrs['createdAt']),
      updatedAt: _dt(attrs['updatedAt']),
      publishedAt: _dt(attrs['publishedAt']),
      images: _list(attrs['images'], ImageItem.fromAny),
      videos: _list(attrs['videos'], VideoItem.fromAny),
      kontak: _list(attrs['kontak'], KontakItem.fromAny),
    );
  }

  // Helper methods untuk cek konten markdown
  bool hasProfilContent() => profilMd != null && profilMd!.isNotEmpty;
  bool hasProgramKerjaContent() =>
      programKerjaMd != null && programKerjaMd!.isNotEmpty;

  /// Helper untuk response standar Strapi: { data: [ {id, attributes:{...}}, ... ] }
  static List<Lembaga> listFromStrapiEnvelope(Map<String, dynamic> body) {
    final data = (body['data'] as List?) ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Lembaga.fromJson)
        .toList();
  }
}

class ImageItem {
  final String? title;

  /// Diambil dari `media.url` atau `media.data.attributes.url`.
  final String? url;

  ImageItem({this.title, this.url});

  String get resolvedUrl => AppConfig.absoluteUrl(url ?? '');

  /// Menerima:
  /// - { title, media: { url } }
  /// - { title, media: { data: { attributes: { url } } } }
  /// - { title, url } (fallback)
  /// - string (url langsung)
  static ImageItem fromAny(dynamic any) {
    if (any is String) return ImageItem(url: any);

    if (any is Map) {
      final m = any.cast<String, dynamic>();

      String? extractUrl(dynamic media) {
        if (media is Map) {
          if (media['url'] is String) return media['url'] as String;
          final d = media['data'];
          if (d is Map && d['attributes'] is Map) {
            final a = (d['attributes'] as Map).cast<String, dynamic>();
            if (a['url'] is String) return a['url'] as String;
          }
        }
        return null;
      }

      return ImageItem(
        title: m['title'] as String?,
        url: extractUrl(m['media']) ?? m['url'] as String?,
      );
    }
    return ImageItem();
  }
}

class VideoItem {
  final String? title;
  final String? videoUrl;

  VideoItem({this.title, this.videoUrl});

  /// Menerima:
  /// - { title, videoUrl }
  /// - string (url langsung)
  static VideoItem fromAny(dynamic any) {
    if (any is String) return VideoItem(videoUrl: any);
    if (any is Map) {
      final m = any.cast<String, dynamic>();
      return VideoItem(
        title: m['title'] as String?,
        videoUrl: m['videoUrl'] as String?,
      );
    }
    return VideoItem();
  }
}

class KontakItem {
  /// telp / whatsapp / email / instagram / youtube / facebook / tiktok / website / ...
  final String? jenis;
  final String? value;

  KontakItem({this.jenis, this.value});

  /// Menerima:
  /// - { jenis, value }
  /// - string (fallback -> value)
  static KontakItem fromAny(dynamic any) {
    if (any is String) return KontakItem(value: any);
    if (any is Map) {
      final m = any.cast<String, dynamic>();
      return KontakItem(
        jenis: m['jenis'] as String?,
        value: m['value'] as String?,
      );
    }
    return KontakItem();
  }
}
