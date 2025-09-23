// import 'package:flutter/material.dart';
// import 'detail_screen.dart';
// import '../widgets/top_bar.dart';
// import '../widgets/bottom_banner.dart';
// import '../widgets/reusable_list_tile.dart';
// import '../widgets/top_banner.dart';
// import '../core/constants/detail_lists.dart';
// import '../core/utils/auth_utils.dart';

// /// Class argumen tetap.
// class MenuScreenArgs {
//   final String title;
//   const MenuScreenArgs({required this.title});
// }

// class MenuScreen extends StatelessWidget {
//   final MenuScreenArgs args;
//   final dynamic menuData;

//   const MenuScreen({Key? key, required this.args, required this.menuData})
//       : super(key: key);

//   Widget _buildMapMenu(BuildContext context, Map<String, dynamic> menuData) {
//     final keys = menuData.keys.toList();
//     return ListView.builder(
//       itemCount: keys.length,
//       itemBuilder: (context, index) {
//         final key = keys[index];
//         return ReusableListTileWidget(
//           value: null,
//           titleText: key,
//           onTap: () {
//             print("menu screen title: $key");
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MenuScreen(
//                   args: MenuScreenArgs(title: key),
//                   menuData: menuData[key],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildListMenu(BuildContext context, List menuData) {
//     if (menuData.isEmpty) {
//       return const Center(child: Text('Belum ada data.'));
//     }

//     if (menuData.first is Map) {
//       return _buildColoredMenuItems(context, menuData);
//     } else if (menuData.first is String) {
//       return _buildStringMenuItems(context, menuData);
//     }

//     return const Center(child: Text('Belum ada data.'));
//   }

//   Widget _buildColoredMenuItems(BuildContext context, List menuData) {
//     return ListView.builder(
//       itemCount: menuData.length,
//       itemBuilder: (context, index) {
//         final item = menuData[index] as Map<String, dynamic>;
//         final title = item['title'] ?? '';
//         final indexBackgroundColor = item['indexBackgroundColor'] != null
//             ? Color(item['indexBackgroundColor'])
//             : null;
//         final titleTextBackgroundColor =
//             item['titleTextBackgroundColor'] != null
//                 ? Color(item['titleTextBackgroundColor'])
//                 : null;

//         return ReusableListTileWidget(
//           value: null,
//           titleText: title,
//           indexBackgroundColor: indexBackgroundColor,
//           titleTextBackgroundColor: titleTextBackgroundColor,
//           onTap: () {
//             print("menu screen title: $title");
//             final detailMenuItems = getDetailMenuItems(title);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(
//                   title: title,
//                   menuItems: detailMenuItems,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(args.title);
//     return Scaffold(
//       appBar: TopBar(title: args.title),
//       body: Column(
//         children: [
//           TopBanner(assetPath: 'assets/banners/top.png'),
//           SizedBox(height: 20),
//           Expanded(
//             child: Builder(
//               builder: (context) {
//                 if (menuData is Map<String, dynamic>) {
//                   return _buildMapMenu(context, menuData);
//                 } else if (menuData is List) {
//                   return _buildListMenu(context, menuData);
//                 } else {
//                   return const Center(child: Text('Belum ada data.'));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar:
//           const BottomBanner(assetPath: 'assets/banners/bottom.png'),
//     );
//   }

//   Widget _buildStringMenuItems(BuildContext context, List menuData) {
//     return ListView.builder(
//       itemCount: menuData.length,
//       itemBuilder: (context, index) {
//         final item = menuData[index];
//         return ReusableListTileWidget(
//           value: null,
//           titleText: item.toString(),
//           onTap: () {
//             if (item is List) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MenuScreen(
//                     args: MenuScreenArgs(title: item.toString()),
//                     menuData: item,
//                   ),
//                 ),
//               );
//             } else {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailScreen(
//                     title: item.toString(),
//                     menuItems: menuItemsJenis1,
//                   ),
//                 ),
//               );
//             }
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'detail_screen.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/reusable_list_tile.dart';
import '../widgets/top_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../core/constants/detail_lists.dart';

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
    print(args.title);
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: TopBar(title: args.title),
        body: Column(
          children: [
            TopBanner(assetPath: 'assets/banners/top.png'),
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
                              final isPenyelenggara = args.title ==
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
                    } else if (menuData.isNotEmpty &&
                        menuData.first is String) {
                      // Fallback jika masih List<String> atau List menu bercabang
                      return ListView.builder(
                        itemCount: menuData.length,
                        itemBuilder: (context, index) {
                          final item = menuData[index];
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
        bottomNavigationBar:
            const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}
// ...existing code...
