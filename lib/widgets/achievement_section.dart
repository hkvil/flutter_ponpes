import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'achievement_item.dart';
import '../models/achievement_model.dart';
import '../providers/achievement_provider.dart';

class AchievementSection extends StatefulWidget {
  const AchievementSection({super.key});

  @override
  State<AchievementSection> createState() => _AchievementSectionState();
}

class _AchievementSectionState extends State<AchievementSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementProvider>().fetchAchievements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AchievementProvider>();
    final state = provider.achievementsState;
    final List<AchievementModel> achievements = state.data ?? const [];

    if (state.isLoading && !state.hasLoaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.errorMessage != null && achievements.isEmpty) {
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: achievements.length + 1,
      itemBuilder: (context, index) {
        if (index == achievements.length) {
          return const SizedBox(height: 72);
        }

        final achievement = achievements[index];
        return AchievementItem(
          achievement: achievement,
        );
      },
    );
  }
}
