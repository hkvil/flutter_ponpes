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
  final List<FrontImageItem> frontImages; // Foto untuk halaman depan
  final ImageItem? topBanner; // Banner atas untuk semua menu lembaga
  final ImageItem? botBanner; // Banner bawah untuk semua menu lembaga

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
    this.frontImages = const [],
    this.topBanner,
    this.botBanner,
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
      frontImages: _list(attrs['frontImages'], FrontImageItem.fromAny),
      topBanner: attrs['topBanner'] != null
          ? ImageItem.fromAny(attrs['topBanner'])
          : null,
      botBanner: attrs['botBanner'] != null
          ? ImageItem.fromAny(attrs['botBanner'])
          : null,
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
  final String? desc;
  final String? date;
  final int? id;
  final int? order;

  /// Diambil dari `media.url` atau `media.data.attributes.url`.
  final String? url;

  ImageItem({
    this.title,
    this.desc,
    this.date,
    this.id,
    this.order,
    this.url,
  });

  String get resolvedUrl => _absoluteUrl(url ?? '');

  /// Menerima:
  /// - { id, title, desc, date, order, media: { url, formats: {...} } } (Strapi v5)
  /// - { id, title, desc, date, order } (dari API galeri tanpa media)
  /// - { title, media: { url } }
  /// - { title, media: { data: { attributes: { url } } } }
  /// - { title, url } (fallback)
  /// - string (url langsung)
  static ImageItem fromAny(dynamic any) {
    if (any is String) return ImageItem(url: any);

    if (any is Map) {
      final m = any.cast<String, dynamic>();

      // Handle galeri structure dengan media yang ter-populate (Strapi v5)
      String? finalUrl;

      // Untuk struktur galeri images dengan field media
      if (m['media'] != null && m['media'] is Map) {
        final media = m['media'] as Map<String, dynamic>;
        finalUrl = media['url'] as String?;

        // Fallback ke format yang lebih kecil jika url utama kosong
        if (finalUrl == null || finalUrl.isEmpty) {
          final formats = media['formats'] as Map<String, dynamic>?;
          if (formats != null) {
            // Prioritas: small > medium > thumbnail
            finalUrl = formats['small']?['url'] as String? ??
                formats['medium']?['url'] as String? ??
                formats['thumbnail']?['url'] as String?;
          }
        }
      } else {
        // Fallback untuk struktur lama
        finalUrl = m['url'] as String? ?? m['imageUrl'] as String?;
      }

      print(
          '🔧 [IMAGE_ITEM] Parsing - ID: ${m['id']}, Title: ${m['title']}, URL: $finalUrl');

      return ImageItem(
        id: m['id'] as int?,
        title: m['title'] as String?,
        desc: m['desc'] as String?,
        date: m['date'] as String?,
        order: m['order'] as int?,
        url: finalUrl,
      );
    }
    return ImageItem();
  }
}

class VideoItem {
  final String? title;
  final String? desc;
  final String? date;
  final int? id;
  final int? order;
  final String? videoUrl;

  VideoItem({
    this.title,
    this.desc,
    this.date,
    this.id,
    this.order,
    this.videoUrl,
  });

  /// Menerima:
  /// - { id, title, videoUrl, desc, date, order } (dari API galeri)
  /// - { title, videoUrl }
  /// - string (url langsung)
  static VideoItem fromAny(dynamic any) {
    if (any is String) return VideoItem(videoUrl: any);

    if (any is Map) {
      final m = any.cast<String, dynamic>();

      // Handle API galeri structure (new format)
      if (m['id'] is int && m['title'] is String) {
        return VideoItem(
          id: m['id'] as int?,
          title: m['title'] as String?,
          desc: m['desc'] as String?,
          date: m['date'] as String?,
          order: m['order'] as int?,
          videoUrl: m['videoUrl'] as String?,
        );
      }

      // Handle existing structure
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

class FrontImageItem {
  final String? url;

  FrontImageItem({this.url});

  String get resolvedUrl => _absoluteUrl(url ?? '');

  /// Parse Strapi media object untuk ambil URL saja
  static FrontImageItem fromAny(dynamic any) {
    if (any is String) return FrontImageItem(url: any);

    if (any is Map) {
      final m = any.cast<String, dynamic>();

      // Ambil URL langsung dari field 'url'
      if (m['url'] is String) {
        return FrontImageItem(url: m['url'] as String);
      }

      // Fallback: coba ambil dari formats jika ada (medium/small/large)
      final formats = m['formats'];
      if (formats is Map) {
        // Prioritas: medium > small > large > thumbnail
        for (final size in ['medium', 'small', 'large', 'thumbnail']) {
          final format = formats[size];
          if (format is Map && format['url'] is String) {
            return FrontImageItem(url: format['url'] as String);
          }
        }
      }
    }

    return FrontImageItem();
  }
}
