import 'models/lembaga_model.dart';
import 'models/banner_config.dart';

void testBannerParsing() {
  // Sample data from your API response
  final topBannerJson = {
    "id": 9,
    "documentId": "t69zpxsqkdz7sy6w3ig7zt69",
    "name": "what-s-inside-a-black-hole",
    "alternativeText":
        "An image uploaded to Strapi called what-s-inside-a-black-hole",
    "caption": "what-s-inside-a-black-hole",
    "width": 800,
    "height": 466,
    "url": "/uploads/what_s_inside_a_black_hole_377c0047fe.jpeg"
  };

  final botBannerJson = {
    "id": 8,
    "documentId": "p9ugyarx9xap9lbar6dsggut",
    "name": "beautiful-picture",
    "url": "/uploads/beautiful_picture_69d0581d2e.jpeg"
  };

  print('Testing banner parsing...');

  // Test ImageItem.fromAny parsing
  final topBanner = ImageItem.fromAny(topBannerJson);
  final botBanner = ImageItem.fromAny(botBannerJson);

  print('Top Banner URL: ${topBanner.url}');
  print('Top Banner Resolved URL: ${topBanner.resolvedUrl}');
  print('Bot Banner URL: ${botBanner.url}');
  print('Bot Banner Resolved URL: ${botBanner.resolvedUrl}');

  // Test BannerConfig creation
  final bannerConfig = BannerConfig.fromLembaga(topBanner, botBanner);

  print('BannerConfig Top URL: ${bannerConfig.topBannerUrl}');
  print('BannerConfig Bottom URL: ${bannerConfig.bottomBannerUrl}');
  print('Has Top Banner: ${bannerConfig.hasTopBanner}');
  print('Has Bottom Banner: ${bannerConfig.hasBottomBanner}');
}
