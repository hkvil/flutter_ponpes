import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/lembaga_slugs.dart';
import '../widgets/detail_layout.dart';
import '../core/constants/detail_lists.dart';

class LembagaSlugListScreen extends StatelessWidget {
  const LembagaSlugListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Slug Lembaga'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCategorySection(
              context,
              'Organ Struktural',
              LembagaSlugs.organStruktural,
              Colors.blue,
            ),
            _buildCategorySection(
              context,
              'Pendidikan Formal',
              LembagaSlugs.pendidikanFormal,
              Colors.green,
            ),
            _buildCategorySection(
              context,
              'Pendidikan Informal',
              LembagaSlugs.pendidikanInformal,
              Colors.orange,
            ),
            _buildCategorySection(
              context,
              'Pengasuhan & Pengkaderan',
              LembagaSlugs.pengasuhanDanPengkaderan,
              Colors.purple,
            ),
            _buildCategorySection(
              context,
              'Organ Umum',
              LembagaSlugs.organUmum,
              Colors.teal,
            ),
            _buildCategorySection(
              context,
              'Organ Struktural Otonom',
              LembagaSlugs.organStruturalOtonom,
              Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Daftar Lengkap Slug Lembaga',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${LembagaSlugs.allSlugs.length} lembaga',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap pada slug untuk copy, tap pada nama untuk testing API.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title,
      List<String> slugs, MaterialColor color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.shade700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${slugs.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...slugs.map((slug) => _buildSlugTile(context, slug, color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlugTile(
      BuildContext context, String slug, MaterialColor color) {
    final nama = LembagaSlugs.getNamaBySlug(slug);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () =>
              LembagaSlugListScreenActions.testLembagaApi(context, slug, nama!),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nama ?? slug,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () =>
                          LembagaSlugListScreenActions.copySlug(context, slug),
                      tooltip: 'Copy slug',
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.link, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        slug,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Slug'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Slug adalah identifier unik untuk setiap lembaga'),
            SizedBox(height: 8),
            Text('• Digunakan untuk API call ke Strapi backend'),
            SizedBox(height: 8),
            Text('• Format: kebab-case (lowercase dengan dash)'),
            SizedBox(height: 8),
            Text('• Tap nama lembaga untuk testing API'),
            SizedBox(height: 8),
            Text('• Tap icon copy untuk menyalin slug'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Extension untuk menambah functionality
extension LembagaSlugListScreenActions on LembagaSlugListScreen {
  static void copySlug(BuildContext context, String slug) {
    Clipboard.setData(ClipboardData(text: slug));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Slug "$slug" disalin ke clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void testLembagaApi(BuildContext context, String slug, String nama) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Test API: $nama'),
            backgroundColor: Colors.green.shade700,
          ),
          body: DetailLayout(
            title: nama,
            lembagaSlug: slug,
            menuItems: menuItemsJenis2, // Default menu items
          ),
        ),
      ),
    );
  }
}
