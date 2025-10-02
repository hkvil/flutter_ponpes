import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/theme/app_colors.dart';

/// Container for displaying a banner with rounded corners.
///
/// The banner can display an image from URL (imageUrl) or local asset (assetPath).
/// Priority: imageUrl > assetPath > fallback placeholder.
/// Use this at the top of screens to display promotional or informational images.
class TopBanner extends StatelessWidget {
  final String? assetPath;
  final String? imageUrl; // URL from API
  final double height;

  const TopBanner({
    super.key,
    this.assetPath,
    this.imageUrl,
    this.height = 148,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: Container(
        height: height,
        width: double.infinity,
        // margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: BoxDecoration(
          color: AppColors.bannerBg,
          // borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildBannerImage(),
      ),
    );
  }

  Widget _buildBannerImage() {
    // Priority: imageUrl (from API) > assetPath (local) > fallback
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.fill,
        placeholder: (context, url) => const _Fallback(),
        errorWidget: (context, url, error) => _buildAssetFallback(),
      );
    } else if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => const _Fallback(),
      );
    } else {
      return const _Fallback();
    }
  }

  Widget _buildAssetFallback() {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => const _Fallback(),
      );
    }
    return const _Fallback();
  }
}

/// Placeholder when banner image cannot be displayed.
class _Fallback extends StatelessWidget {
  const _Fallback();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Banner Placeholder'),
    );
  }
}
