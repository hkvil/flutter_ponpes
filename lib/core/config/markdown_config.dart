import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

/// Centralized Markdown configuration for consistent styling across the app
class AppMarkdownConfig {
  /// Default markdown configuration used throughout the application
  static MarkdownConfig get defaultConfig => MarkdownConfig(configs: [
        // Heading 1 configuration
        H1Config(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        // Heading 2 configuration
        H2Config(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        // Heading 3 configuration
        H3Config(
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        // Paragraph configuration
        PConfig(
          textStyle: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),

        // Link configuration
        LinkConfig(
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            decoration: TextDecoration.underline,
          ),
        ),
      ]);

  /// Compact markdown configuration for smaller spaces
  static MarkdownConfig get compactConfig => MarkdownConfig(configs: [
        H1Config(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        H2Config(
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        H3Config(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        PConfig(
          textStyle: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
      ]);
}
