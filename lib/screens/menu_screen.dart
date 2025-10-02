import 'package:flutter/material.dart';
import 'detail_screen.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/reusable_list_tile.dart';
import '../widgets/top_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../core/constants/detail_lists.dart';
import '../models/banner_menu_utama_model.dart';
import '../repository/banner_menu_utama_repository.dart';

/// Class argumen tetap.
class MenuScreenArgs {
  final String title;
  const MenuScreenArgs({required this.title});
}

class MenuScreen extends StatefulWidget {
  final MenuScreenArgs args;
  final dynamic menuData;

  const MenuScreen({Key? key, required this.args, required this.menuData})
      : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final BannerMenuUtamaRepository _bannerRepository =
      BannerMenuUtamaRepository();
  BannerMenuUtama? _banner;
  bool _isLoadingBanner = true;

  @override
  void initState() {
    super.initState();
    _fetchBanner();
  }

  Future<void> _fetchBanner() async {
    try {
      final banner =
          await _bannerRepository.getBannerByTitle(widget.args.title);
      if (mounted) {
        setState(() {
          _banner = banner;
          _isLoadingBanner = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching banner: $e');
      if (mounted) {
        setState(() {
          _isLoadingBanner = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.args.title);
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: TopBar(title: widget.args.title),
        body: Column(
          children: [
            // Use banner from API if available, fallback to assets
            _isLoadingBanner
                ? Container(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : TopBanner(
                    imageUrl: _banner?.resolvedTopBannerUrl,
                    assetPath: 'assets/banners/top.png', // Fallback
                  ),
            SizedBox(height: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (widget.menuData is Map<String, dynamic>) {
                    final keys = widget.menuData.keys.toList();
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
                                  menuData: widget.menuData[key],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (widget.menuData is List) {
                    // Cek apakah List berisi Map (menu dengan warna)
                    if (widget.menuData.isNotEmpty &&
                        widget.menuData.first is Map) {
                      return ListView.builder(
                        itemCount: widget.menuData.length,
                        itemBuilder: (context, index) {
                          final item =
                              widget.menuData[index] as Map<String, dynamic>;
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
                              final isPenyelenggara = widget.args.title ==
                                  'Organ Penyelenggara Pendidikan Formal';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    title: title,
                                    menuItems: isPenyelenggara
                                        ? menuItemsJenis2
                                        : menuItemsJenis1,
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
                    } else if (widget.menuData.isNotEmpty &&
                        widget.menuData.first is String) {
                      // Fallback jika masih List<String> atau List menu bercabang
                      return ListView.builder(
                        itemCount: widget.menuData.length,
                        itemBuilder: (context, index) {
                          final item = widget.menuData[index];
                          return ReusableListTileWidget(
                            value: null,
                            titleText: item.toString(),
                            onTap: () {
                              if (item is List) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuScreen(
                                      args: MenuScreenArgs(
                                          title: item.toString()),
                                      menuData: item,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      title: item.toString(),
                                      menuItems: menuItemsJenis1,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('Belum ada data.'));
                    }
                  } else {
                    return const Center(child: Text('Belum ada data.'));
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBanner(
          imageUrl: _banner?.resolvedBottomBannerUrl,
          assetPath: 'assets/banners/bottom.png', // Fallback
        ),
      ),
    );
  }
}
// ...existing code...
