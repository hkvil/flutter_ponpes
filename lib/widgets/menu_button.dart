import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Represents an icon button with text below, used in the home screen grid.
///
/// The [MenuButton] wraps the icon and label in a tappable area. It uses
/// [InkWell] for visual feedback and is styled to match the application's
/// design. An error icon appears if the provided image cannot be loaded.
class MenuButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const MenuButton({super.key, required this.title, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryGreen.withOpacity(.3)),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              iconPath,
              height: 36,
              width: 36,
              errorBuilder: (_, __, ___) => const Icon(Icons.apps),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}