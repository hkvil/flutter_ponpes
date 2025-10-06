import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../widgets/section_header.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/menu_button.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/achievement_section.dart';
import '../core/router/app_router.dart';
import 'menu_screen.dart';
import '../providers/slider_provider.dart';

/// The home screen shows the main menu grid and achievements.
///
/// It consists of a carousel slider with autoplay, a grid of ten menu buttons,
/// a list of achievements, and a fixed bottom banner. Navigation to other
/// screens is handled via named routes defined in [AppRouter].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// List of menu items: each entry holds a title and the path to its icon.
  static const List<({String title, String? iconPath, IconData? iconData})>
      _menuItems = [
    (title: 'PPI', iconPath: 'assets/icons/ppi.png', iconData: null),
    (title: 'YALQI', iconPath: 'assets/icons/yalqi.png', iconData: null),
    (title: 'IAIQI', iconPath: 'assets/icons/iaiqi.png', iconData: null),
    (title: 'PANTI', iconPath: 'assets/icons/panti.png', iconData: null),
    (title: 'BMT', iconPath: 'assets/icons/bmt.png', iconData: null),
    (title: 'BUMY', iconPath: 'assets/icons/bumy.png', iconData: null),
    (title: 'KOPERASI', iconPath: 'assets/icons/koperasi.png', iconData: null),
    (title: 'PPDB', iconPath: 'assets/icons/ppdb.png', iconData: null),
    (title: 'DONASI', iconPath: 'assets/icons/donasi.png', iconData: null),
    (
      title: 'INFORMASI',
      iconPath: 'assets/icons/informasi.png',
      iconData: null
    ),
    (title: 'AKUN', iconPath: null, iconData: Icons.account_circle_outlined),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SliderProvider>().fetchSliderImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sliderProvider = context.watch<SliderProvider>();
    final sliderState = sliderProvider.sliderState;
    final images = sliderProvider.imageUrls;

    Widget _buildSlider() {
      if (sliderState.isLoading && !sliderState.hasLoaded) {
        return Container(
          height: 200.0,
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (sliderState.errorMessage != null && images.isEmpty) {
        return Container(
          height: 200.0,
          color: Colors.red.shade100,
          child: Center(
            child: Text('Error: ${sliderState.errorMessage}'),
          ),
        );
      }

      if (images.isEmpty) {
        return Container(
          height: 200.0,
          color: Colors.grey.shade100,
          child: const Center(child: Text('No images available')),
        );
      }

      return CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        items: images.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              );
            },
          );
        }).toList(),
      );
    }

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(
          title: 'PONDOK PESANTREN\nAl-ITTIFAQIAH INDRALAYA',
          subtitle: 'ORGAN ILIR SUMATERA SELATAN INDONESIA',
          automaticallyImplyLeading: false,
          isHomeScreen: true,
        ),
        body: ListView(
          children: [
            // Carousel dengan Provider
            _buildSlider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MenuRow(
                        items: [HomeScreen._menuItems[0]],
                        buttonSize: 48,
                        onTap: (title) {
                          Navigator.pushNamed(
                            context,
                            AppRouter.menu,
                            arguments: MenuScreenArgs(title: title),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      MenuRow(
                        items: HomeScreen._menuItems.sublist(1, 4),
                        buttonSize: 48,
                        onTap: (title) {
                          Navigator.pushNamed(
                            context,
                            AppRouter.menu,
                            arguments: MenuScreenArgs(title: title),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      MenuRow(
                        items: HomeScreen._menuItems.sublist(4, 7),
                        buttonSize: 48,
                        onTap: (title) {
                          Navigator.pushNamed(
                            context,
                            AppRouter.menu,
                            arguments: MenuScreenArgs(title: title),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      MenuRow(
                        items: HomeScreen._menuItems.sublist(7, 10),
                        buttonSize: 48,
                        onTap: (title) {
                          if (title == 'DONASI') {
                            Navigator.pushNamed(context, AppRouter.donasi);
                          } else if (title == 'INFORMASI') {
                            Navigator.pushNamed(context, AppRouter.informasi);
                          } else {
                            Navigator.pushNamed(
                              context,
                              AppRouter.menu,
                              arguments: MenuScreenArgs(title: title),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      MenuRow(
                        items: [HomeScreen._menuItems[10]],
                        buttonSize: 48,
                        alignment: MainAxisAlignment.center,
                        onTap: (title) {
                          if (title == 'AKUN') {
                            Navigator.pushNamed(context, AppRouter.account);
                          } else {
                            Navigator.pushNamed(
                              context,
                              AppRouter.menu,
                              arguments: MenuScreenArgs(title: title),
                            );
                          }
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
            // Achievement section dengan API call
            const AchievementSection(),
          ],
        ),
        bottomNavigationBar:
            const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}

class MenuRow extends StatelessWidget {
  final List<({String title, String? iconPath, IconData? iconData})> items;
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
            title: item.title,
            iconPath: item.iconPath,
            iconData: item.iconData,
            buttonSize: buttonSize,
            onTap: () => onTap(item.title),
          ),
      ],
    );
  }
}
