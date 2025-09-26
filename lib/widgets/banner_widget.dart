import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/banner_config.dart';

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

    Widget bannerImage = Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: bannerUrl,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: height,
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
            height: height,
            color: Colors.grey.shade300,
            child: Icon(
              Icons.image_not_supported,
              size: 32,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );

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
          ),
      ],
    );
  }
}
