import 'package:flutter/material.dart';
import '../core/utils/menu_navigation_helper.dart';
import '../models/lembaga_model.dart';

class DetailLayout extends StatelessWidget {
  // 🎨 Konstanta ukuran gambar - Edit di sini untuk mengubah semua ukuran
  // Rasio 16:9 - Width 96px, Height 54px
  static const double imageWidth = 96.0 * 2;
  static const double imageHeight = 54.0 * 2;
  static const double borderRadius = 8.0;
  static const double imageSpacing = 8.0; // Jarak antar gambar
  static const int maxImages = 6; // Maksimal gambar yang ditampilkan

  final String title;
  final List<String> imagePaths;
  final List<String> menuItems;
  final String? lembagaSlug;
  final Lembaga? cachedLembaga; // Data yang sudah di-preload

  const DetailLayout({
    Key? key,
    required this.title,
    this.imagePaths = const [],
    this.menuItems = const [],
    this.lembagaSlug,
    this.cachedLembaga,
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
            width: imageWidth + 20, // Tambah padding 20px untuk margin
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
    // Gunakan frontImages dari cached lembaga jika ada
    if (cachedLembaga != null && cachedLembaga!.frontImages.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: cachedLembaga!.frontImages.take(maxImages).map((frontImage) {
          return Container(
            margin: EdgeInsets.only(bottom: imageSpacing),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                height: imageHeight,
                width: imageWidth,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Image.network(
                  frontImage.resolvedUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: imageHeight,
                      width: imageWidth,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: imageHeight,
                      width: imageWidth,
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey.shade500,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    // Fallback ke imagePaths jika ada
    if (imagePaths.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: imagePaths.take(maxImages).map((path) {
          return Container(
            margin: EdgeInsets.only(bottom: imageSpacing),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                height: imageHeight,
                width: imageWidth,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Placeholder(
                      fallbackHeight: imageHeight,
                      fallbackWidth: imageWidth,
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    // Default placeholders jika tidak ada gambar sama sekali
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxImages,
        (index) => Container(
          margin:
              EdgeInsets.only(bottom: index < maxImages - 1 ? imageSpacing : 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              height: imageHeight,
              width: imageWidth,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image,
                color: Colors.grey.shade500,
                size: 30,
              ),
            ),
          ),
        ),
      ),
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
      cachedLembaga: cachedLembaga, // Pass cached data
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cachedLembaga != null
            ? 'Buka "$item" (data sudah siap)'
            : lembagaSlug != null
                ? 'Mengambil data "$item" dari API...'
                : 'Menampilkan "$title - $item"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
