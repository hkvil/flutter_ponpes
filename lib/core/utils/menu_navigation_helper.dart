import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/galeri_screen.dart';
import '../../screens/contact_screen.dart';
import '../../screens/bannered_detail_screen.dart';
import '../../screens/santri_screen.dart';
import '../../screens/staff_screen.dart';
import '../../screens/informasi_screen.dart';
import '../../screens/alumni_screen.dart';
import '../../screens/prestasi_screen.dart';
import '../../screens/pelanggaran_screen.dart';
import '../../models/profile_section.dart';
import '../../models/lembaga_model.dart';
import '../../providers/lembaga_provider.dart';
import 'banner_manager.dart';
import '../constants/profil.dart';
import '../../providers/auth_provider.dart';

class MenuNavigationHelper {
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
      final provider = Provider.of<LembagaProvider>(context, listen: false);
      final lembaga = await provider.fetchBySlug(slug);
      final errorMessage = provider.lembagaState(slug).errorMessage;

      // Dismiss loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (lembaga == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? 'Data lembaga tidak ditemukan'),
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
      BuildContext context, String menuItem, Lembaga lembaga) async {
    print('🚀 [CACHED_NAV] Navigating to: $menuItem for ${lembaga.nama}');
    print('🚀 [CACHED_NAV] Using banner from lembaga: ${lembaga.slug}');

    // Gatekeep untuk menu yang butuh login
    final lowerMenu = menuItem.toLowerCase();
    if ({
      'santri',
      'sdm',
      'guru',
      'prestasi',
      'pelanggaran',
      'alumni',
    }.contains(lowerMenu)) {
      if (!await _requireLogin(context)) return;
    }

    switch (lowerMenu) {
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

      case 'kontak':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactScreen(
              title: '${lembaga.nama} - Kontak',
              lembaga: lembaga, // Pass API data with contact info
            ),
          ),
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

      case 'santri':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SantriScreen(
              title: '${lembaga.nama} - Daftar Santri',
              lembagaName: lembaga.nama,
            ),
          ),
        );
        break;

      case 'sdm':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffScreen(
              title: '${lembaga.nama} - Data Staff',
              lembagaName: lembaga.nama,
            ),
          ),
        );
        break;

      case 'guru':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffScreen(
              title: '${lembaga.nama} - Data Guru',
              lembagaName: lembaga.nama,
            ),
          ),
        );
        break;

      case 'informasi':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformasiScreen(
              title: '${lembaga.nama} - Informasi',
              lembagaName: lembaga.nama,
              lembaga: lembaga,
            ),
          ),
        );
        break;

      case 'alumni':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlumniScreen(
              title: '${lembaga.nama} - Data Alumni',
              lembagaName: lembaga.nama,
            ),
          ),
        );
        break;

      case 'prestasi':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrestasiScreen(
              title: '${lembaga.nama} - Prestasi',
              lembagaName: lembaga.nama,
            ),
          ),
        );
        break;

      case 'pelanggaran':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PelanggaranScreen(
              title: '${lembaga.nama} - Pelanggaran',
              lembagaName: lembaga.nama,
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
      BuildContext context, String menuItem, String categoryTitle) async {
    // Gatekeep untuk menu yang butuh login
    final lowerMenu = menuItem.toLowerCase();
    if ({
      'santri',
      'sdm',
      'guru',
      'prestasi',
      'pelanggaran',
      'alumni',
    }.contains(lowerMenu)) {
      if (!await _requireLogin(context)) return;
    }
    _navigateWithBanner(context, menuItem, categoryTitle, null);
  }

  /// Navigate dengan support banner
  static void _navigateWithBanner(BuildContext context, String menuItem,
      String categoryTitle, String? lembagaSlug) async {
    // Gatekeep untuk menu yang butuh login
    final lowerMenu = menuItem.toLowerCase();
    if ({
      'santri',
      'sdm',
      'guru',
      'prestasi',
      'pelanggaran',
      'alumni',
    }.contains(lowerMenu)) {
      if (!await _requireLogin(context)) return;
    }
    // Get banner config
    final bannerConfig = await _bannerManager.getBannerConfig(
      context,
      menuItem,
      lembagaSlug: lembagaSlug,
    );

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrestasiScreen(
              title: '$categoryTitle - Prestasi',
              lembagaName: categoryTitle,
            ),
          ),
        );
        break;
      case 'prestasi sdm':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrestasiScreen(
              title: '$categoryTitle - Prestasi SDM',
              lembagaName: categoryTitle,
              showOnlyStaff: true,
            ),
          ),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformasiScreen(
              title: '$categoryTitle - Informasi',
              lembagaName: categoryTitle,
            ),
          ),
        );
        break;

      case 'santri':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SantriScreen(
              title: '$categoryTitle - Daftar Santri',
              lembagaName: categoryTitle,
            ),
          ),
        );
        break;

      case 'sdm':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffScreen(
              title: '$categoryTitle - Data Staff',
              lembagaName: categoryTitle,
            ),
          ),
        );
        break;

      case 'guru':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffScreen(
              title: '$categoryTitle - Data Guru',
              lembagaName: categoryTitle,
            ),
          ),
        );
        break;

      case 'alumni':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlumniScreen(
              title: '$categoryTitle - Data Alumni',
              lembagaName: categoryTitle,
            ),
          ),
        );
        break;

      case 'pelanggaran':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PelanggaranScreen(
              title: '$categoryTitle - Pelanggaran',
              lembagaName: categoryTitle,
            ),
          ),
        );
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
    final bannerConfig = await _bannerManager.getBannerConfig(
      context,
      menuItem,
      lembagaSlug: lembaga.slug,
    );

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

  // Helper untuk cek login dan tampilkan snackbar jika belum login
  static Future<bool> _requireLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan login terlebih dahulu.'),
          backgroundColor: Colors.orange.shade700,
        ),
      );
      return false;
    }
    return true;
  }
}
