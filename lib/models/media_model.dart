class MediaFormat {
  final String name;
  final String hash;
  final String ext;
  final String mime;
  final int width;
  final int height;
  final double size;
  final int sizeInBytes;
  final String url;

  MediaFormat({
    required this.name,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.width,
    required this.height,
    required this.size,
    required this.sizeInBytes,
    required this.url,
  });

  factory MediaFormat.fromJson(Map<String, dynamic> json) {
    return MediaFormat(
      name: json['name'] ?? '',
      hash: json['hash'] ?? '',
      ext: json['ext'] ?? '',
      mime: json['mime'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      size: (json['size'] ?? 0).toDouble(),
      sizeInBytes: json['sizeInBytes'] ?? 0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hash': hash,
      'ext': ext,
      'mime': mime,
      'width': width,
      'height': height,
      'size': size,
      'sizeInBytes': sizeInBytes,
      'url': url,
    };
  }
}

class MediaFormats {
  final MediaFormat? thumbnail;
  final MediaFormat? small;
  final MediaFormat? medium;
  final MediaFormat? large;

  MediaFormats({
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
  });

  factory MediaFormats.fromJson(Map<String, dynamic> json) {
    return MediaFormats(
      thumbnail: json['thumbnail'] != null
          ? MediaFormat.fromJson(json['thumbnail'])
          : null,
      small: json['small'] != null ? MediaFormat.fromJson(json['small']) : null,
      medium:
          json['medium'] != null ? MediaFormat.fromJson(json['medium']) : null,
      large: json['large'] != null ? MediaFormat.fromJson(json['large']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail?.toJson(),
      'small': small?.toJson(),
      'medium': medium?.toJson(),
      'large': large?.toJson(),
    };
  }
}

class MediaModel {
  final int id;
  final String documentId;
  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final MediaFormats formats;
  final String hash;
  final String ext;
  final String mime;
  final double size;
  final String url;
  final String? previewUrl;
  final String provider;
  final dynamic providerMetadata;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  MediaModel({
    required this.id,
    required this.documentId,
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    this.previewUrl,
    required this.provider,
    this.providerMetadata,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      name: json['name'] ?? '',
      alternativeText: json['alternativeText'],
      caption: json['caption'],
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      formats: MediaFormats.fromJson(json['formats'] ?? {}),
      hash: json['hash'] ?? '',
      ext: json['ext'] ?? '',
      mime: json['mime'] ?? '',
      size: (json['size'] ?? 0).toDouble(),
      url: json['url'] ?? '',
      previewUrl: json['previewUrl'],
      provider: json['provider'] ?? 'local',
      providerMetadata: json['provider_metadata'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'alternativeText': alternativeText,
      'caption': caption,
      'width': width,
      'height': height,
      'formats': formats.toJson(),
      'hash': hash,
      'ext': ext,
      'mime': mime,
      'size': size,
      'url': url,
      'previewUrl': previewUrl,
      'provider': provider,
      'provider_metadata': providerMetadata,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
    };
  }

  // Helper method untuk mendapatkan URL media yang sesuai
  String getImageUrl(String baseUrl, {String size = 'medium'}) {
    String imageUrl = '';

    switch (size) {
      case 'thumbnail':
        imageUrl = formats.thumbnail?.url ?? formats.small?.url ?? url;
        break;
      case 'small':
        imageUrl = formats.small?.url ?? formats.medium?.url ?? url;
        break;
      case 'medium':
        imageUrl = formats.medium?.url ?? formats.large?.url ?? url;
        break;
      case 'large':
        imageUrl = formats.large?.url ?? formats.medium?.url ?? url;
        break;
      default:
        imageUrl = formats.medium?.url ?? url;
    }

    return imageUrl.startsWith('http') ? imageUrl : '$baseUrl$imageUrl';
  }
}
