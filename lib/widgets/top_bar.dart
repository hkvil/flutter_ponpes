import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_text.dart';

/// A reusable app bar component that displays a logo, title, optional
/// subtitle, and the current date/time.
///
/// The [TopBar] implements [PreferredSizeWidget] so it can be used as
/// an app bar in a [Scaffold]. The date/time is formatted using
/// [DateText.nowId].
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;

  const TopBar({super.key, required this.title, this.subtitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          const _Logo(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateText.currentTime(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
              Text(
                DateText.currentDay(),
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.right,
              ),
            ],
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Private widget to load the logo asset with fallback.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: 32,
      width: 32,
      errorBuilder: (_, __, ___) => const CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: Icon(Icons.image_not_supported, size: 16, color: Colors.black45),
      ),
    );
  }
}