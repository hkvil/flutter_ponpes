import 'package:flutter/material.dart';

import '../../widgets/top_bar.dart';
import '../../widgets/bottom_banner.dart';
import '../../widgets/banner_container.dart';
import '../../widgets/menu_button.dart';
import '../../core/router/app_router.dart';
import '../menu/menu_screen.dart';
import '../../core/constants/menu_lists.dart';

/// The home screen shows the main menu grid and achievements.
///
/// It consists of a top banner, a grid of ten menu buttons, a list of
/// achievements, and a fixed bottom banner. Navigation to other
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
        subtitle: 'Ogan Ilir, Sumatera Selatan',
      ),
      body: Column(
        children: [
          const BannerContainer(assetPath: 'assets/banners/top.png'),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          // 1 di atas tengah
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: MenuButton(
                                  title: _menuItems[0].$1,
                                  iconPath: _menuItems[0].$2,
                                  onTap: () {
                                    final menuData = menuTree[_menuItems[0].$1];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuScreen(
                                          args: MenuScreenArgs(
                                              title: _menuItems[0].$1),
                                          menuData: menuData,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // 3 di baris kedua
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 1; i <= 3; i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                  ),
                                  child: MenuButton(
                                    title: _menuItems[i].$1,
                                    iconPath: _menuItems[i].$2,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRouter.menu,
                                        arguments: MenuScreenArgs(
                                            title: _menuItems[i].$1),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // 3 di baris ketiga
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 4; i <= 6; i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                  ),
                                  child: MenuButton(
                                    title: _menuItems[i].$1,
                                    iconPath: _menuItems[i].$2,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRouter.menu,
                                        arguments: MenuScreenArgs(
                                            title: _menuItems[i].$1),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // 3 di bawah tengah
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 7; i <= 9; i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                  ),
                                  child: MenuButton(
                                    title: _menuItems[i].$1,
                                    iconPath: _menuItems[i].$2,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRouter.menu,
                                        arguments: MenuScreenArgs(
                                            title: _menuItems[i].$1),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 2,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IntrinsicWidth(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.green.shade700,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                'Prestasi & Penghargaan',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const _AchievementItem(title: 'Go Internasional Sejak 1997'),
                const _AchievementItem(
                    title: 'Pesantren Unggulan Nasional Sejak 1999'),
                const _AchievementItem(
                    title:
                        'Masuk 20 Pesantren Berpengaruh di Indonesia Sejak 2005'),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}

/// Single line achievement entry with icon.
class _AchievementItem extends StatelessWidget {
  final String title;
  const _AchievementItem({required this.title});
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
