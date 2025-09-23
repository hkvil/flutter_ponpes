import 'package:flutter/material.dart';
import '../core/utils/menu_navigation_helper.dart';

class DetailLayout extends StatelessWidget {
  final String title;
  final List<String> imagePaths;
  final List<String> menuItems;
  final String? lembagaSlug;

  const DetailLayout({
    Key? key,
    required this.title,
    this.imagePaths = const [],
    this.menuItems = const [],
    this.lembagaSlug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Images
          Container(
            width: 100,
            child: _buildImagesList(),
          ),
          const SizedBox(width: 16),
          // Right side - Menu items
          Flexible(
            child: _buildMenuList(),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesList() {
    if (imagePaths.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          6,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: const Placeholder(
              fallbackHeight: 65,
              fallbackWidth: 80,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: imagePaths
          .map((img) => Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset(img, width: 80, height: 80),
              ))
          .toList(),
    );
  }

  Widget _buildMenuList() {
    if (menuItems.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          9,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: const Text('Menu'),
              trailing: const Icon(Icons.arrow_right),
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: menuItems.map((item) => _buildMenuItem(item)).toList(),
    );
  }

  Widget _buildMenuItem(String item) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        child: Material(
          color: Colors.green.shade50,
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleMenuTap(context, item),
            child: Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 16,
                  ),
                  Container(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 44,
                    width: 52,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.arrow_right, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String item) {
    MenuNavigationHelper.navigateToMenuItem(
      context,
      item,
      title,
      lembagaSlug: lembagaSlug,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lembagaSlug != null
            ? 'Mengambil data "$item" dari API...'
            : 'Menampilkan "$title - $item"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
