import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

/// Centralized Markdown configuration for consistent styling across the app
class AppMarkdownConfig {
  static MarkdownConfig get defaultConfig => _buildConfig(compact: false);

  static MarkdownConfig get compactConfig => _buildConfig(compact: true);

  /// Returns a markdown configuration adapted to the current screen size.
  ///
  /// Small devices (shortest side under 360dp) or devices with a large
  /// text scale factor automatically use the compact configuration to keep
  /// text — especially inside tables — readable without overflowing.
  static MarkdownConfig responsiveConfig(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final shortestSide = mediaQuery.size.shortestSide;
    final isTextScaledUp = mediaQuery.textScaleFactor > 1.1;
    final bool useCompact = shortestSide < 360 || isTextScaledUp;
    return useCompact ? compactConfig : defaultConfig;
  }

  static MarkdownConfig _buildConfig({required bool compact}) {
    final double h1Size = compact ? 20 : 22;
    final double h2Size = compact ? 18 : 20;
    final double h3Size = compact ? 16 : 18;
    final double paragraphSize = compact ? 13 : 15;

    return MarkdownConfig(configs: [
      H1Config(
        style: TextStyle(
          fontSize: h1Size,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      H2Config(
        style: TextStyle(
          fontSize: h2Size,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      H3Config(
        style: TextStyle(
          fontSize: h3Size,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      PConfig(
        textStyle: TextStyle(
          fontSize: paragraphSize,
          height: 1.45,
          color: Colors.black87,
        ),
      ),
      LinkConfig(
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          decoration: TextDecoration.underline,
        ),
      ),
      TableConfig(
        wrapper: (table) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: table,
        ),
      ),
    ]);
  }
}
