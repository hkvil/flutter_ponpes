import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/banner_config.dart';
import '../core/theme/app_colors.dart';

class BannerWidget extends StatelessWidget {
  final BannerConfig bannerConfig;
  final bool isTopBanner;
  final EdgeInsetsGeometry? margin;
  final double? height;

  const BannerWidget({
    super.key,
    required this.bannerConfig,
    this.isTopBanner = true,
    this.margin,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    final bannerUrl =
        isTopBanner ? bannerConfig.topBannerUrl : bannerConfig.bottomBannerUrl;
    final redirectUrl = isTopBanner
        ? bannerConfig.topBannerRedirectUrl
        : bannerConfig.bottomBannerRedirectUrl;

    if (bannerUrl == null || bannerUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    // Style yang sesuai dengan TopBanner dan BottomBanner original
    Widget bannerImage;

    if (isTopBanner) {
      // Style untuk TopBanner: elevation, height=148, no border radius
      bannerImage = Material(
        elevation: 8,
        child: Container(
          height: height ?? 148,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.bannerBg,
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: bannerUrl,
            fit: BoxFit.fill, // sama seperti TopBanner original
            placeholder: (context, url) => Container(
              width: double.infinity,
              height: height ?? 148,
              color: Colors.grey.shade200,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: height ?? 148,
              color: Colors.grey.shade300,
              child: const Center(
                child: Text('Banner Placeholder'),
              ),
            ),
          ),
        ),
      );
    } else {
      // Style untuk BottomBanner: no elevation, height=100, no border radius
      bannerImage = Container(
        height: height ?? 100,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.bannerBg,
        ),
        child: CachedNetworkImage(
          imageUrl: bannerUrl,
          fit: BoxFit.cover, // sama seperti BottomBanner original
          width: double.infinity,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: height ?? 100,
            color: Colors.grey.shade200,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: height ?? 100,
            color: Colors.grey.shade300,
            child: const Center(
              child: Text(
                'Dirgahayu Indonesia – Banner Placeholder',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      );
    }

    // Jika ada redirect URL, buat clickable
    if (redirectUrl != null && redirectUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _launchUrl(redirectUrl),
        child: bannerImage,
      );
    }

    return bannerImage;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

/// Widget untuk menampilkan banner pada screen dengan content
class BanneredContent extends StatelessWidget {
  final Widget content;
  final BannerConfig bannerConfig;
  final EdgeInsetsGeometry? contentPadding;

  const BanneredContent({
    super.key,
    required this.content,
    required this.bannerConfig,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Banner
        if (bannerConfig.hasTopBanner)
          BannerWidget(
            bannerConfig: bannerConfig,
            isTopBanner: true,
            height: 148, // sama dengan TopBanner original
          ),

        // Main Content
        Expanded(
          child: Padding(
            padding: contentPadding ?? EdgeInsets.zero,
            child: content,
          ),
        ),

        // Bottom Banner
        if (bannerConfig.hasBottomBanner)
          BannerWidget(
            bannerConfig: bannerConfig,
            isTopBanner: false,
            height: 100, // sama dengan BottomBanner original
          ),
      ],
    );
  }
}
