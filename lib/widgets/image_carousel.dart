import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// A carousel slider widget with autoplay functionality for displaying images.
/// Supports both local assets and network images from API.
class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    super.key,
    this.imageUrls,
    this.height = 200.0,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.viewportFraction = 1.0,
  });

  /// List of image URLs (can be assets or network URLs)
  final List<String>? imageUrls;

  /// Height of the carousel
  final double height;

  /// Interval between auto-play transitions
  final Duration autoPlayInterval;

  /// Duration of the auto-play animation
  final Duration autoPlayAnimationDuration;

  /// Fraction of the viewport that each page should occupy
  final double viewportFraction;

  /// Default images if no URLs provided
  static const List<String> _defaultImages = [
    'assets/banners/top.png',
    'assets/banners/bottom.png',
  ];

  @override
  Widget build(BuildContext context) {
    final images = imageUrls ?? _defaultImages;

    if (images.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('No images available'),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        autoPlayInterval: autoPlayInterval,
        autoPlayAnimationDuration: autoPlayAnimationDuration,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: viewportFraction,
      ),
      items: images.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _buildImage(imageUrl),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildImage(String imageUrl) {
    // Check if it's a network URL or local asset
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      // Local asset
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}
