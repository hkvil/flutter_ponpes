import 'package:flutter/material.dart';
import 'achievement_item.dart';
import '../repository/achievement_repository.dart';
import '../models/achievement_model.dart';

class AchievementSection extends StatefulWidget {
  const AchievementSection({super.key});

  @override
  State<AchievementSection> createState() => _AchievementSectionState();
}

class _AchievementSectionState extends State<AchievementSection> {
  final AchievementRepository _repository = AchievementRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AchievementModel>>(
      future: _repository.fetchAchievements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat prestasi',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Periksa koneksi internet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final achievements = snapshot.data ?? [];

        if (achievements.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Belum ada prestasi yang tersedia',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...achievements
                .map((achievement) => AchievementItem(
                      achievement: achievement,
                    ))
                .toList(),
            const SizedBox(height: 72),
          ],
        );
      },
    );
  }
}
