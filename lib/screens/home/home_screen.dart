import 'package:flutter/material.dart';

import '../../widgets/top_bar.dart';
import '../../widgets/bottom_banner.dart';
import '../../widgets/banner_container.dart';
import '../../widgets/menu_button.dart';
import '../../core/router/app_router.dart';
import '../menu/menu_screen.dart';

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
                    child: _ResponsiveGrid(
                      children: [
                        for (final (title, icon) in _menuItems)
                          MenuButton(
                            title: title,
                            iconPath: icon,
                            onTap: () {
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

/// Builds a responsive grid that adapts the number of columns based on screen width.
class _ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const _ResponsiveGrid({required this.children});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        final w = constraints.maxWidth;
        if (w < 340) {
          crossAxisCount = 3;
        } else if (w < 520) {
          crossAxisCount = 4;
        }
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: .82,
          children: children,
        );
      },
    );
  }
}
