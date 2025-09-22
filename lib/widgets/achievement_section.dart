import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import 'achievement_item.dart';

class AchievementSection extends StatelessWidget {
  final List<String> achievementTitles;
  const AchievementSection({
    super.key,
    required this.achievementTitles,
  });

  @override
  Widget build(BuildContext context) {
    final dummyAchievements = [
      'Go Internasional Sejak 1997',
      'Pesantren Unggulan Nasional Sejak 1999',
      'Masuk 20 Pesantren Berpengaruh di Indonesia Sejak 2005',
      'Juara Lomba Santri Nasional 2010',
      'Penghargaan Pesantren Ramah Anak 2012',
      'Juara Umum MTQ Kabupaten 2015',
      'Pesantren Inovatif Sumatera Selatan 2017',
      'Santri Berprestasi Internasional 2018',
      'Pesantren Digital Award 2020',
      'Juara Pesantren Hijau 2022',
    ];
    final achievementsToShow =
        achievementTitles.isNotEmpty ? achievementTitles : dummyAchievements;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...achievementsToShow
            .map((title) => AchievementItem(title: title))
            .toList(),
        const SizedBox(height: 72),
      ],
    );
  }
}
