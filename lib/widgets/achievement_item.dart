import 'package:flutter/material.dart';

class AchievementItem extends StatelessWidget {
  final String title;
  const AchievementItem({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.military_tech, color: Colors.amber),
      title: Text(title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      dense: true,
    );
  }
}
