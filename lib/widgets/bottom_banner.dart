import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A bottom banner that can display an image or fallback text.
///
/// This widget is designed to be used as a [Scaffold.bottomNavigationBar]
/// so that it remains fixed at the bottom of the screen. If [assetPath]
/// is provided, the image will be displayed; otherwise [fallbackText]
/// appears centered.
class BottomBanner extends StatelessWidget {
  final String? assetPath;
  final String fallbackText;

  const BottomBanner({super.key, this.assetPath, this.fallbackText = 'Dirgahayu Indonesia – Banner Placeholder'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(color: AppColors.bannerBg),
      child: assetPath != null
          ? Center(
              child: Image.asset(
                assetPath!,
                fit: BoxFit.fitWidth,
                height: double.infinity,
                errorBuilder: (_, __, ___) => _FallbackText(fallbackText: fallbackText),
              ),
            )
          : _FallbackText(fallbackText: fallbackText),
    );
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