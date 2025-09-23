import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_text.dart';

/// A reusable app bar component that displays a logo, title, optional
/// subtitle, and the current date/time.
///
/// The [TopBar] implements [PreferredSizeWidget] so it can be used as
/// an app bar in a [Scaffold]. The date/time is formatted using
/// [DateText.nowId].
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: 42,
      width: 42,
      errorBuilder: (_, __, ___) => const CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: Icon(Icons.image_not_supported, size: 16, color: Colors.black45),
      ),
    );
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool automaticallyImplyLeading;
  final bool isHomeScreen;

  const TopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.automaticallyImplyLeading = true,
    this.isHomeScreen = false,
  });

  @override
  Size get preferredSize =>
      isHomeScreen ? const Size.fromHeight(90) : const Size.fromHeight(56);

  @override
  @override
  Widget build(BuildContext context) {
    if (isHomeScreen) {
      // HomeScreen: container putih, logo, jam, subtitle
      return AppBar(
        backgroundColor: AppColors.primaryGreen,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: null,
        flexibleSpace: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 32),
                const _Logo(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                          height: 1.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const _Clock(),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      );
    } else {
      // Selain HomeScreen: AppBar hijau, tombol back, hanya title putih
      return AppBar(
        backgroundColor: AppColors.primaryGreen,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      );
    }
  }
}

class _Clock extends StatelessWidget {
  const _Clock();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream:
          Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateText.currentTime(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
              textAlign: TextAlign.right,
            ),
            Text(DateText.currentDay(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                )),
          ],
        );
      },
    );
  }
}
