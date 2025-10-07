import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';
import '../widgets/banner_widget.dart';
import '../widgets/section_header.dart';
import '../models/banner_config.dart';
import '../models/profile_section.dart';
import '../core/config/markdown_config.dart';

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
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: BanneredContent(
          bannerConfig: bannerConfig,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add SectionHeader before the content
              const SizedBox(height: 16),
              SectionHeader(
                title: title
                    .split(' - ')
                    .last, // Extract "Profil" or "Program Kerja" from title
                fontSize: 20,
              ),
              const SizedBox(height: 16),

              // ListView for sections
              Expanded(
                child: ListView.builder(
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
                            // Only show title if it's not empty
                            if (section.title.isNotEmpty) ...[
                              Text(
                                section.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            // Render content as markdown if it contains markdown syntax
                            _renderSectionContent(section.content),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Render section content - detect if it's markdown and render appropriately
  Widget _renderSectionContent(String content) {
    // Check if content contains markdown syntax
    bool isMarkdown = content.contains('#') ||
        content.contains('**') ||
        content.contains('*') ||
        content.contains('[') ||
        content.contains('```');

    if (isMarkdown) {
      // Render as markdown with centralized configuration
      return MarkdownBlock(
        data: content,
        config: AppMarkdownConfig.defaultConfig,
      );
    } else {
      // Render as plain text
      return Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87,
        ),
      );
    }
  }
}
