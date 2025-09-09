import 'package:flutter/material.dart';

import '../../widgets/top_bar.dart';
import '../../widgets/bottom_banner.dart';
import '../../widgets/option_tile.dart';

/// Arguments required by [MenuScreen].
class MenuScreenArgs {
  final String title;
  const MenuScreenArgs({required this.title});
}

/// Screen displayed after selecting a menu item from the home screen.
///
/// It retains the same top and bottom banners as the home screen and
/// lists a series of selectable options. Each [OptionTile] can be
/// configured to navigate further or perform actions when tapped.
class MenuScreen extends StatelessWidget {
  final MenuScreenArgs args;
  const MenuScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final options = [
      'Pusat',
      'Madrasah',
      'Lembaga',
      'Biro',
      'Bidang',
      'Ikappi',
      'Iwappi',
      'Perwappi',
      'NGO',
      'Pondok Cabang',
    ];

    return Scaffold(
      appBar: TopBar(title: args.title, subtitle: 'Daftar Kategori'),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return OptionTile(
            leftValue: (index + 1).toString(),
            title: options[index],
            onTap: () {
              // Navigate or handle taps here
            },
          );
        },
      ),
      bottomNavigationBar: const BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}