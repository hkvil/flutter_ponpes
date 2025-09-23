import 'package:flutter/material.dart';
import '../models/profile_section.dart';
import 'content_screen.dart';

class DetailContentScreen extends StatelessWidget {
  final String title;
  final List<ProfileSection> sections;
  const DetailContentScreen({required this.title, required this.sections, super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapper untuk DetailContentScreen menggunakan ContentScreen dengan type full
    return ContentScreen(
      title: title,
      sections: sections,
      type: ContentScreenType.full,
    );
  }
}
