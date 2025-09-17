import 'package:flutter/material.dart';
import 'package:pesantren_app/screens/madrasah/detail_madrasah_screen.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/bottom_banner.dart';
import '../../widgets/reusable_list_tile.dart';
import '../../widgets/banner_container.dart';

/// Class argumen tetap.
class MenuScreenArgs {
  final String title;
  const MenuScreenArgs({required this.title});
}

class MenuScreen extends StatelessWidget {
  final MenuScreenArgs args;
  final dynamic menuData;

  const MenuScreen({Key? key, required this.args, required this.menuData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: args.title),
      body: Column(
        children: [
          BannerContainer(assetPath: 'assets/banners/top.png'),
          SizedBox(height: 20),
          Expanded(
            child: Builder(
              builder: (context) {
                if (menuData is Map<String, dynamic>) {
                  final keys = menuData.keys.toList();
                  return ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final key = keys[index];
                      return ReusableListTileWidget(
                        value: null,
                        titleText: key,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuScreen(
                                args: MenuScreenArgs(title: key),
                                menuData: menuData[key],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (menuData is List) {
                  // Cek apakah List berisi Map (menu dengan warna)
                  if (menuData.isNotEmpty && menuData.first is Map) {
                    return ListView.builder(
                      itemCount: menuData.length,
                      itemBuilder: (context, index) {
                        final item = menuData[index] as Map<String, dynamic>;
                        final title = item['title'] ?? '';
                        final indexBackgroundColor =
                            item['indexBackgroundColor'] != null
                                ? Color(item['indexBackgroundColor'])
                                : null;
                        final titleTextBackgroundColor =
                            item['titleTextBackgroundColor'] != null
                                ? Color(item['titleTextBackgroundColor'])
                                : null;
                        Widget tile = ReusableListTileWidget(
                          value: null,
                          titleText: title,
                          indexBackgroundColor: indexBackgroundColor,
                          titleTextBackgroundColor: titleTextBackgroundColor,
                          onTap: () {
                            // Jika item adalah label (Formal/Non Formal), tidak navigasi
                            if (title == 'Formal' || title == 'Non Formal')
                              return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailMadrasahScreen(
                                  madrasahName: title,
                                ),
                              ),
                            );
                          },
                        );
                        if (title != 'Formal' && title != 'Non Formal') {
                          tile = Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                            child: tile,
                          );
                        }
                        return tile;
                      },
                    );
                  } else if (menuData.isNotEmpty && menuData.first is String) {
                    // Fallback jika masih List<String>
                    return ListView.builder(
                      itemCount: menuData.length,
                      itemBuilder: (context, index) {
                        final item = menuData[index];
                        return ReusableListTileWidget(
                          value: null,
                          titleText: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailMadrasahScreen(
                                  madrasahName: item,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Tidak ada data.'));
                  }
                } else {
                  return const Center(child: Text('Tidak ada data.'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}
