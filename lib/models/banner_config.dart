import 'lembaga_model.dart';

class BannerConfig {
  final String? topBannerUrl;
  final String? bottomBannerUrl;
  final String? topBannerRedirectUrl;
  final String? bottomBannerRedirectUrl;

  const BannerConfig({
    this.topBannerUrl,
    this.bottomBannerUrl,
    this.topBannerRedirectUrl,
    this.bottomBannerRedirectUrl,
  });

  /// Factory constructor untuk membuat dari Lembaga dengan topBanner dan botBanner
  factory BannerConfig.fromLembaga(
    ImageItem? topBanner,
    ImageItem? botBanner, {
    String? topRedirectUrl,
    String? bottomRedirectUrl,
  }) {
    return BannerConfig(
      topBannerUrl: topBanner?.resolvedUrl,
      bottomBannerUrl: botBanner?.resolvedUrl,
      topBannerRedirectUrl: topRedirectUrl,
      bottomBannerRedirectUrl: bottomRedirectUrl,
    );
  }

  factory BannerConfig.fromJson(Map<String, dynamic> json) {
    return BannerConfig(
      topBannerUrl: json['topBannerUrl'],
      bottomBannerUrl: json['bottomBannerUrl'],
      topBannerRedirectUrl: json['topBannerRedirectUrl'],
      bottomBannerRedirectUrl: json['bottomBannerRedirectUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topBannerUrl': topBannerUrl,
      'bottomBannerUrl': bottomBannerUrl,
      'topBannerRedirectUrl': topBannerRedirectUrl,
      'bottomBannerRedirectUrl': bottomBannerRedirectUrl,
    };
  }

  bool get hasTopBanner => topBannerUrl != null && topBannerUrl!.isNotEmpty;
  bool get hasBottomBanner =>
      bottomBannerUrl != null && bottomBannerUrl!.isNotEmpty;
  bool get hasBanners => hasTopBanner || hasBottomBanner;
}

class MenuBannerConfig {
  final String menuKey;
  final BannerConfig bannerConfig;

  const MenuBannerConfig({
    required this.menuKey,
    required this.bannerConfig,
  });

  factory MenuBannerConfig.fromJson(Map<String, dynamic> json) {
    return MenuBannerConfig(
      menuKey: json['menuKey'] ?? '',
      bannerConfig: BannerConfig.fromJson(json['bannerConfig'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuKey': menuKey,
      'bannerConfig': bannerConfig.toJson(),
    };
  }
}
