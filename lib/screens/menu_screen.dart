import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_screen.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/reusable_list_tile.dart';
import '../widgets/top_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../core/constants/detail_lists.dart';
import '../models/banner_menu_utama_model.dart';
import '../providers/banner_menu_utama_provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerMenuUtamaProvider>().fetchBanner(widget.args.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.args.title);
    final bannerProvider = context.watch<BannerMenuUtamaProvider>();
    final bannerState = bannerProvider.bannerState(widget.args.title);
    final BannerMenuUtama? banner = bannerState.data;
    final bool isLoadingBanner =
        bannerState.isLoading && !bannerState.hasLoaded;

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: TopBar(title: widget.args.title),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Use banner from API if available, fallback to assets
                    isLoadingBanner
                        ? SizedBox(
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : TopBanner(
                            imageUrl: banner?.resolvedTopBannerUrl,
                            assetPath: 'assets/banners/top.png', // Fallback
                          ),
                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        if (widget.menuData is Map<String, dynamic>) {
                          final keys = widget.menuData.keys.toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.menuData.length,
                              itemBuilder: (context, index) {
                                final item = widget.menuData[index]
                                    as Map<String, dynamic>;
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
                                  titleTextBackgroundColor:
                                      titleTextBackgroundColor,
                                  onTap: () {
                                    // Jika item adalah label (Formal/Non Formal), tidak navigasi
                                    if (title == 'Formal' ||
                                        title == 'Non Formal') {
                                      return;
                                    }
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
                                if (title != 'Formal' &&
                                    title != 'Non Formal') {
                                  tile = Padding(
                                    padding:
                                        const EdgeInsets.only(left: 60.0),
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
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomBanner(
          imageUrl: banner?.resolvedBottomBannerUrl,
          assetPath: 'assets/banners/bottom.png', // Fallback
        ),
      ),
    );
  }
}
// ...existing code...
