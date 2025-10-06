import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Represents an icon button with text below, used in the home screen grid.
///
/// The [MenuButton] wraps the icon and label in a tappable area. It uses
/// [InkWell] for visual feedback and is styled to match the application's
/// design. An error icon appears if the provided image cannot be loaded.
class MenuButton extends StatelessWidget {
  final String title;
  final String? iconPath;
  final IconData? iconData;
  final VoidCallback onTap;
  final double buttonSize;

  const MenuButton({
    super.key,
    required this.title,
    this.iconPath,
    this.iconData,
    required this.onTap,
    this.buttonSize = 48,
  })  : assert(iconPath != null || iconData != null,
            'Either iconPath or iconData must be provided.'),
        assert(iconPath == null || iconData == null,
            'Cannot provide both iconPath and iconData.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: buttonSize,
              width: buttonSize,
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.primaryGreen.withOpacity(.3)),
              ),
              alignment: Alignment.center,
              child: iconPath != null
                  ? Image.asset(
                      iconPath!,
                      height: buttonSize * 0.75,
                      width: buttonSize * 0.75,
                      errorBuilder: (_, __, ___) => const Icon(Icons.apps),
                    )
                  : Icon(
                      iconData,
                      size: buttonSize * 0.75,
                      color: AppColors.primaryGreen,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
