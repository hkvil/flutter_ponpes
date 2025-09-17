import 'package:flutter/material.dart';
import '../models/profile_section.dart';

class ProfileList extends StatelessWidget {
  final List<ProfileSection> sections;
  const ProfileList({required this.sections, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in sections)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  section.content,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
