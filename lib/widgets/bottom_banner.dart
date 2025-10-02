import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/theme/app_colors.dart';

/// A bottom banner that can display an image or fallback text.
///
/// This widget is designed to be used as a [Scaffold.bottomNavigationBar]
/// so that it remains fixed at the bottom of the screen.
/// Priority: imageUrl (from API) > assetPath (local) > fallbackText.
class BottomBanner extends StatelessWidget {
  final String? assetPath;
  final String? imageUrl; // URL from API
  final String fallbackText;

  const BottomBanner({
    super.key,
    this.assetPath,
    this.imageUrl,
    this.fallbackText = 'Dirgahayu Indonesia – Banner Placeholder',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(color: AppColors.bannerBg),
      child: _buildBannerImage(),
    );
  }

  Widget _buildBannerImage() {
    // Priority: imageUrl (from API) > assetPath (local) > fallback
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) =>
              _FallbackText(fallbackText: fallbackText),
          errorWidget: (context, url, error) => _buildAssetFallback(),
        ),
      );
    } else if (assetPath != null) {
      return Center(
        child: Image.asset(
          assetPath!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) =>
              _FallbackText(fallbackText: fallbackText),
        ),
      );
    } else {
      return _FallbackText(fallbackText: fallbackText);
    }
  }

  Widget _buildAssetFallback() {
    if (assetPath != null) {
      return Center(
        child: Image.asset(
          assetPath!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) =>
              _FallbackText(fallbackText: fallbackText),
        ),
      );
    }
    return _FallbackText(fallbackText: fallbackText);
  }
}

/// Fallback text when banner image fails to load or is absent.
class _FallbackText extends StatelessWidget {
  final String fallbackText;
  const _FallbackText({required this.fallbackText});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        fallbackText,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
