import 'package:flutter/material.dart';
import '../../screens/galeri_screen.dart';
import '../../screens/contact_screen.dart';
import '../../screens/bannered_detail_screen.dart';
import '../../models/profile_section.dart';
import '../../models/lembaga_model.dart';
import '../../repository/lembaga_repository.dart';
import 'banner_manager.dart';
import '../constants/profil.dart';

class MenuNavigationHelper {
  static final LembagaRepository _lembagaRepository = LembagaRepository();
  static final BannerManager _bannerManager = BannerManager();

  /// Navigate to appropriate screen based on menu item and lembaga slug
  static void navigateToMenuItem(
      BuildContext context, String menuItem, String categoryTitle,
      {String? lembagaSlug, dynamic cachedLembaga}) {
    // Jika ada cached data, gunakan itu (instant navigation)
    if (cachedLembaga != null) {
      _navigateWithCachedData(context, menuItem, cachedLembaga);
    } else if (lembagaSlug != null) {
      // Fallback ke API call (seperti sekarang)
      _navigateWithApiContent(context, menuItem, categoryTitle, lembagaSlug);
    } else {
      // Static content fallback
      _navigateWithStaticContent(context, menuItem, categoryTitle);
    }
  }

  /// Navigate menggunakan API content berdasarkan slug
  static void _navigateWithApiContent(BuildContext context, String menuItem,
      String categoryTitle, String slug) async {
    print('🌐 [API_NAV] Starting API navigation for: $menuItem (slug: $slug)');

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final lembaga = await _lembagaRepository.fetchBySlug(slug);

      // Dismiss loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (lembaga == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data lembaga tidak ditemukan'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (!context.mounted) return;

      switch (menuItem.toLowerCase()) {
        case 'profil':
          _navigateWithContentAndBanner(
            context,
            menuItem,
            lembaga,
            lembaga.hasProfilContent() ? lembaga.profilMd! : null,
          );
          break;

        case 'program kerja':
          _navigateWithContentAndBanner(
            context,
            menuItem,
            lembaga,
            lembaga.hasProgramKerjaContent() ? lembaga.programKerjaMd! : null,
          );
          break;

        default:
          // Untuk menu lain, gunakan static content
          _navigateWithStaticContent(context, menuItem, lembaga.nama);
      }
    } catch (e) {
      // Dismiss loading if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate menggunakan cached data (INSTANT NAVIGATION - no loading!)
  static void _navigateWithCachedData(
      BuildContext context, String menuItem, Lembaga lembaga) {
    print('🚀 [CACHED_NAV] Navigating to: $menuItem for ${lembaga.nama}');
    print('🚀 [CACHED_NAV] Using banner from lembaga: ${lembaga.slug}');

    switch (menuItem.toLowerCase()) {
      case 'profil':
        _navigateWithContentAndBanner(
          context,
          menuItem,
          lembaga,
          lembaga.hasProfilContent() ? lembaga.profilMd! : null,
        );
        break;

      case 'program kerja':
        _navigateWithContentAndBanner(
          context,
          menuItem,
          lembaga,
          lembaga.hasProgramKerjaContent() ? lembaga.programKerjaMd! : null,
        );
        break;

      case 'galeri':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GaleriScreen(
              title: '${lembaga.nama} - Galeri',
              lembaga: lembaga, // Pass API data
            ),
          ),
        );
        break;

      default:
        // Untuk menu lain, gunakan static content dengan banner dari API
        _navigateWithBanner(context, menuItem, lembaga.nama, lembaga.slug);
    }
  }

  /// Navigate menggunakan static content (fallback)
  static void _navigateWithStaticContent(
      BuildContext context, String menuItem, String categoryTitle) {
    _navigateWithBanner(context, menuItem, categoryTitle, null);
  }

  /// Navigate dengan support banner
  static void _navigateWithBanner(BuildContext context, String menuItem,
      String categoryTitle, String? lembagaSlug) async {
    // Get banner config
    final bannerConfig = await _bannerManager.getBannerConfig(menuItem,
        lembagaSlug: lembagaSlug);

    if (!context.mounted) return;

    switch (menuItem.toLowerCase()) {
      case 'profil':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BanneredDetailScreen(
              title: '$categoryTitle - Profil',
              sections: profilPKP, // Dari constants/profil.dart
              bannerConfig: bannerConfig,
            ),
          ),
        );
        break;

      case 'program kerja':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BanneredDetailScreen(
              title: '$categoryTitle - Program Kerja',
              sections: _getProgramKerjaSections(),
              bannerConfig: bannerConfig,
            ),
          ),
        );
        break;

      case 'kontak':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactScreen(
              title: '$categoryTitle - Kontak',
            ),
          ),
        );
        break;

      case 'prestasi':
        _showComingSoon(context, 'Prestasi');
        break;
      case 'prestasi sdm':
        _showComingSoon(context, 'Prestasi SDM');
        break;

      case 'galeri':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GaleriScreen(
              title: '$categoryTitle - Galeri',
              // No lembaga data, will use static demo data
            ),
          ),
        );
        break;

      case 'informasi':
        _showComingSoon(context, 'Informasi');
        break;

      case 'sdm':
      case 'santri':
      case 'guru':
      case 'alumni':
        _showComingSoon(context, menuItem);
        break;

      case 'peraturan sdm':
        _showComingSoon(context, 'Peraturan SDM');
        break;

      default:
        _showComingSoon(context, menuItem);
    }
  }

  static void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  static List<ProfileSection> _getProgramKerjaSections() {
    return [
      const ProfileSection(
        title: 'Program Pendidikan',
        content: '''
• Pendidikan Formal (SD, SMP, SMA)
• Pendidikan Diniyah
• Tahfidz Al-Quran  
• Bahasa Arab & Inggris
        ''',
      ),
      const ProfileSection(
        title: 'Program Pengembangan',
        content: '''
• Keterampilan Teknologi
• Entrepreneurship
• Leadership Training
• Public Speaking
        ''',
      ),
      const ProfileSection(
        title: 'Program Sosial',
        content: '''
• Bakti Sosial
• Pengabdian Masyarakat
• Dakwah Komunitas
• Pemberdayaan Ekonomi
        ''',
      ),
    ];
  }

  /// Navigate dengan content API dan banner system
  static void _navigateWithContentAndBanner(
    BuildContext context,
    String menuItem,
    Lembaga lembaga,
    String? markdownContent,
  ) async {
    print('🎯 [CONTENT_BANNER] Loading banner for: ${lembaga.slug}');
    print(
        '🎯 [CONTENT_BANNER] Menu: $menuItem, hasContent: ${markdownContent != null}');

    // Get banner config from lembaga
    final bannerConfig = await _bannerManager.getBannerConfig(menuItem,
        lembagaSlug: lembaga.slug);

    print(
        '🎯 [CONTENT_BANNER] Banner config loaded - hasTopBanner: ${bannerConfig.hasTopBanner}, hasBottomBanner: ${bannerConfig.hasBottomBanner}');

    if (!context.mounted) return;

    final title = '${lembaga.nama} - ${_capitalizeFirst(menuItem)}';

    if (markdownContent != null && markdownContent.isNotEmpty) {
      // Convert markdown content to sections (simple approach)
      // Don't add title here since BanneredDetailScreen already has SectionHeader
      final sections = [
        ProfileSection(
          title: '', // Empty title to avoid duplication with SectionHeader
          content: markdownContent,
        ),
      ];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BanneredDetailScreen(
            title: title,
            sections: sections,
            bannerConfig: bannerConfig,
          ),
        ),
      );
    } else {
      // No content available
      _showContentNotAvailable(context, title);
    }
  }

  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static void _showContentNotAvailable(
      BuildContext context, String contentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$contentName belum tersedia'),
        backgroundColor: Colors.orange.shade700,
      ),
    );
  }
}
