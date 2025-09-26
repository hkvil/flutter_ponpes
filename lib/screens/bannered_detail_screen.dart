import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../models/banner_config.dart';
import '../models/profile_section.dart';

class BanneredDetailScreen extends StatelessWidget {
  final String title;
  final List<ProfileSection> sections;
  final BannerConfig bannerConfig;

  const BanneredDetailScreen({
    super.key,
    required this.title,
    required this.sections,
    required this.bannerConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: BanneredContent(
        bannerConfig: bannerConfig,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        content: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      section.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
