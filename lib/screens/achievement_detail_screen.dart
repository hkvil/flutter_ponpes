import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import 'content_screen.dart';

class AchievementDetailScreen extends StatelessWidget {
  final AchievementModel achievement;
  final bool showFullLayout;

  const AchievementDetailScreen({
    required this.achievement,
    this.showFullLayout = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ContentScreen(
      title: achievement.title,
      markdownContent: achievement.content,
      type: showFullLayout ? ContentScreenType.full : ContentScreenType.minimal,
    );
  }
}

// Factory constructors untuk kemudahan penggunaan
extension AchievementDetailScreenFactory on AchievementDetailScreen {
  /// Create detail screen dengan layout penuh (banner, header, dll)
  static Widget withFullLayout(AchievementModel achievement) {
    return AchievementDetailScreen(
      achievement: achievement,
      showFullLayout: true,
    );
  }

  /// Create detail screen dengan layout minimal (hanya markdown content)
  static Widget withMinimalLayout(AchievementModel achievement) {
    return AchievementDetailScreen(
      achievement: achievement,
      showFullLayout: false,
    );
  }
}
