import 'package:flutter/material.dart';
import '../widgets/detail_layout.dart';
import '../core/constants/detail_lists.dart';
import '../core/constants/lembaga_slugs.dart';
import 'lembaga_slug_list_screen.dart';

class ApiDemoScreen extends StatelessWidget {
  const ApiDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo API Lembaga'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => _showAllSlugs(context),
            tooltip: 'Lihat semua slug',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Integrasi API Lembaga',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Klik menu "Profil" atau "Program Kerja" untuk testing API:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Demo dengan slug Taman Kanak-Kanak
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DetailLayout(
                  title:
                      LembagaSlugs.getNamaBySlug(LembagaSlugs.tamanKanakKanak)!,
                  lembagaSlug: LembagaSlugs.tamanKanakKanak,
                  menuItems: menuItemsJenis2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Demo dengan slug Madrasah Ibtidaiyah
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DetailLayout(
                  title: LembagaSlugs.getNamaBySlug(
                      LembagaSlugs.madrasahIbtidaiyah)!,
                  lembagaSlug: LembagaSlugs.madrasahIbtidaiyah,
                  menuItems: menuItemsJenis2,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Demo tanpa slug (static content)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: DetailLayout(
                  title: 'Contoh Static Content',
                  // Tidak ada lembagaSlug = gunakan static content
                  menuItems: menuItemsJenis1,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔍 Testing Guide:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Klik "Profil" pada Taman Kanak-Kanak → Akan hit API dengan slug "taman-kanak-kanak"',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '2. Klik "Program Kerja" → Akan hit API dan render markdown jika ada',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '3. Jika profilMd/programKerjaMd kosong → Akan show "belum tersedia"',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '4. Menu lain (Prestasi, Kontak, dll) → Fallback ke static content',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllSlugs(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LembagaSlugListScreen(),
      ),
    );
  }
}
