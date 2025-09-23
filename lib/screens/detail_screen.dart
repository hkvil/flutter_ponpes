import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/detail_layout.dart';
import '../widgets/responsive_wrapper.dart';
import '../core/utils/menu_slug_mapper.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final List<String> menuItems;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: [
            TopBanner(
              assetPath: 'assets/banners/top.png',
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DetailLayout(
                title: title,
                menuItems: menuItems,
                lembagaSlug: MenuSlugMapper.getSlugByMenuTitle(
                    title), // Add slug mapping
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}
