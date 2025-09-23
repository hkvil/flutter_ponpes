import 'package:flutter/material.dart';

import '../widgets/section_header.dart';
import '../repository/slider_repository.dart';
import '../widgets/achievement_section.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/image_carousel.dart';
import '../widgets/menu_button.dart';
import '../core/router/app_router.dart';
import 'menu_screen.dart';
import '../core/constants/menu_lists.dart';

/// The home screen shows the main menu grid and achievements.
///
/// It consists of a carousel slider with autoplay, a grid of ten menu buttons,
/// a list of achievements, and a fixed bottom banner. Navigation to other
/// screens is handled via named routes defined in [AppRouter].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// List of menu items: each entry holds a title and the path to its icon.
  static const List<(String, String)> _menuItems = [
    ('PPI', 'assets/icons/ppi.png'),
    ('YALQI', 'assets/icons/yalqi.png'),
    ('IAIQI', 'assets/icons/iaiqi.png'),
    ('PANTI', 'assets/icons/panti.png'),
    ('BMT', 'assets/icons/bmt.png'),
    ('BUMY', 'assets/icons/bumy.png'),
    ('KOPERASI', 'assets/icons/koperasi.png'),
    ('PPDB', 'assets/icons/ppdb.png'),
    ('DONASI', 'assets/icons/donasi.png'),
    ('INFORMASI', 'assets/icons/informasi.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: 'PONDOK PESANTREN\nAl-ITTIFAQIAH INDRALAYA',
        subtitle: 'ORGAN ILIR SUMATERA SELATAN INDONESIA',
        automaticallyImplyLeading: false,
        isHomeScreen: true,
      ),
      body: FutureBuilder<List<String>>(
        future: SliderRepository().fetchSliderImageUrls(),
        builder: (context, snapshot) {
          final images = snapshot.data;
          return Column(
            children: [
              ImageCarousel(
                imageUrls: images,
                height: 200.0,
                autoPlayInterval: const Duration(seconds: 5),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 1),
                      child: Material(
                        elevation: 12,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MenuRow(
                                items: [_menuItems[0]],
                                buttonSize: 48,
                                onTap: (title) {
                                  final menuData = menuTree[title];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuScreen(
                                        args: MenuScreenArgs(title: title),
                                        menuData: menuData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                              MenuRow(
                                items: _menuItems.sublist(1, 4),
                                buttonSize: 48,
                                onTap: (title) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.menu,
                                    arguments: MenuScreenArgs(title: title),
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                              MenuRow(
                                items: _menuItems.sublist(4, 7),
                                buttonSize: 48,
                                onTap: (title) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.menu,
                                    arguments: MenuScreenArgs(title: title),
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                              MenuRow(
                                items: _menuItems.sublist(7, 10),
                                buttonSize: 48,
                                onTap: (title) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.menu,
                                    arguments: MenuScreenArgs(title: title),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SectionHeader(
                          title: 'Prestasi dan Penghargaan',
                          backgroundColor: Colors.green.shade700,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AchievementSection(
                          achievementTitles: const [],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar:
          const BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}

class AchievementItem extends StatelessWidget {
  final String title;
  const AchievementItem({required this.title});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.military_tech, color: Colors.amber),
      title: Text(title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      dense: true,
    );
  }
}

class MenuRow extends StatelessWidget {
  final List<(String, String)> items;
  final void Function(String title) onTap;
  final double buttonSize;
  final MainAxisAlignment alignment;
  const MenuRow(
      {super.key,
      required this.items,
      required this.onTap,
      this.buttonSize = 48,
      this.alignment = MainAxisAlignment.spaceEvenly});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (final item in items)
          MenuButton(
            title: item.$1,
            iconPath: item.$2,
            buttonSize: buttonSize,
            onTap: () => onTap(item.$1),
          ),
      ],
    );
  }
}
