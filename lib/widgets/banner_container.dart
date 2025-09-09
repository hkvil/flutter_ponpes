import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Container for displaying a banner with rounded corners.
///
/// The banner can optionally display an image specified via [assetPath]. If
/// no image is provided or if it fails to load, a fallback placeholder
/// text will be shown. Use this at the top of screens to display
/// promotional or informational images.
class BannerContainer extends StatelessWidget {
  final String? assetPath;
  final double height;

  const BannerContainer({super.key, this.assetPath, this.height = 148});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: assetPath != null
          ? Image.asset(
              assetPath!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _Fallback(),
            )
          : const _Fallback(),
    );
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