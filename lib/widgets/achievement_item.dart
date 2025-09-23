import 'package:flutter/material.dart';
import '../models/achievement_model.dart';

class AchievementItem extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementItem({
    required this.achievement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: achievement.thumbnailUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                achievement.thumbnailUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.military_tech,
                      color: Colors.amber,
                      size: 28,
                    ),
                  );
                },
              ),
            )
          : Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.military_tech,
                color: Colors.amber,
                size: 28,
              ),
            ),
      title: Text(
        achievement.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      dense: false,
      onTap: () {
        // TODO: Navigate ke detail achievement dengan documentId
        print('Tapped achievement: ${achievement.documentId}');
      },
    );
  }
}
