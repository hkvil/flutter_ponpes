import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/profile_section.dart';

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
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.green.shade700,
        ),
        body: type == ContentScreenType.minimal
            ? _buildMinimalLayout()
            : _buildFullLayout(),
        bottomNavigationBar: type == ContentScreenType.full
            ? BottomBanner(assetPath: 'assets/banners/bottom.png')
            : null,
      ),
    );
  }

  Widget _buildFullLayout() {
    return Column(
      children: [
        // Hapus banner dulu untuk test
        Container(
          height: 100,
          color: Colors.green.shade100,
          child: const Center(
            child: Text('Header Area', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 20),

        // Gunakan Expanded sederhana
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),

                // Hanya tampilkan content sederhana
                _buildMarkdownWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hanya render markdown content
          if (markdownContent != null && markdownContent!.isNotEmpty)
            _buildMarkdownWidget()
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

  Widget _buildMarkdownWidget() {
    // Completely remove markdown widget - use simple Text only
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: MarkdownBlock(data: markdownContent ?? ''),
    );
  }
}
