import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_banner.dart';
import '../../widgets/option_tile.dart';

/// Class argumen tetap.
class MenuScreenArgs {
  final String title;
  const MenuScreenArgs({required this.title});
}

class MenuScreen extends StatelessWidget {
  final MenuScreenArgs args;
  const MenuScreen({super.key, required this.args});

  /// Daftar menu beserta sub-itemnya.
  static const List<Node> menu = [
    Node('Pusat', ['Struktur', 'Program', 'Kontak']),
    Node('Madrasah', ['Taman Kanak-Kanak','Taman Pendidikan Al-Qur\'an', 'Madrasah Diniyah','Madrasah Ibtidaiyah', 'Madrasah Tsanawiyah 1', 'Madrasah Tsanawiyah 2', 'Madrasah Aliyah1','Madrasah Aliyah 2','Madrasah Tahfidz Lil Ath Fal','Mujahadah & Pembibitan','Haromain','Al-Ittifaqiah Language Center']),
    Node('Lembaga', ['Litbang', 'Dakwah']),
    Node('Biro', ['Keuangan', 'SDM', 'Humas']),
    Node('Bidang', ['Tarbiyah', 'Sosial']),
    Node('Ikappi'),
    Node('Iwappi'),
    Node('Perwappi'),
    Node('NGO'),
    Node('Pondok Cabang'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: args.title, subtitle: 'Daftar Kategori'),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final node = menu[index];
          return OptionTile(
            index: index + 1,
            node: node,
            onTap: () {
              // tindakan khusus untuk item tanpa sub-item, jika diperlukan
            },
          );
        },
      ),
      bottomNavigationBar:
      const BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}
