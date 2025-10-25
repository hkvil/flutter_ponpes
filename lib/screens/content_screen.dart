import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/section_header.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/profile_section.dart';
import '../core/config/markdown_config.dart';

enum ContentScreenType {
  full, // dengan top banner, section header, bottom banner + markdown
  minimal, // hanya markdown tanpa banner dan header
}

class ContentScreen extends StatelessWidget {
  final String title;
  final String? markdownContent;
  final List<ProfileSection>? sections;
  final ContentScreenType type;

  const ContentScreen({
    required this.title,
    this.markdownContent,
    this.sections,
    this.type = ContentScreenType.full,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final padding = isMobile ? 12.0 : 20.0;
    final innerPadding = isMobile ? 8.0 : 16.0;

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.green.shade700,
        ),
        body: type == ContentScreenType.minimal
            ? _buildMinimalLayout(context, padding)
            : _buildFullLayout(context, padding, innerPadding),
        bottomNavigationBar: type == ContentScreenType.full
            ? BottomBanner(assetPath: 'assets/banners/bottom.png')
            : null,
      ),
    );
  }

  Widget _buildFullLayout(
      BuildContext context, double padding, double innerPadding) {
    return Column(
      children: [
        TopBanner(
          assetPath: 'assets/banners/top.png',
          height: 150,
        ),
        SizedBox(height: padding),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: title,
                  fontSize: 20,
                ),
                SizedBox(height: innerPadding),
                _buildMarkdownWidget(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalLayout(BuildContext context, double padding) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (markdownContent != null && markdownContent!.isNotEmpty)
            _buildMarkdownWidget(context)
          else
            const Center(
              child: Text(
                'Tidak ada konten untuk ditampilkan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMarkdownWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: MarkdownBlock(
        data: markdownContent ?? '',
        config: AppMarkdownConfig.responsiveConfig(context),
      ),
    );
  }
}
