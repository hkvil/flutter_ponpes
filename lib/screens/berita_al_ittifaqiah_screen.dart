import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/top_banner.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/top_bar.dart';
import '../models/informasi_al_ittifaqiah_model.dart';
import '../providers/informasi_al_ittifaqiah_provider.dart';
import 'content_screen.dart';

class BeritaAlIttifaqiahScreen extends StatefulWidget {
  const BeritaAlIttifaqiahScreen({super.key});

  @override
  State<BeritaAlIttifaqiahScreen> createState() =>
      _BeritaAlIttifaqiahScreenState();
}

class _BeritaAlIttifaqiahScreenState extends State<BeritaAlIttifaqiahScreen> {
  List<NewsItem>? _newsData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNewsData();
  }

  Future<void> _loadNewsData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final provider = context.read<InformasiAlIttifaqiahProvider>();
      final informasiData = await provider.fetchInformasi(forceRefresh: true);

      setState(() {
        _newsData = informasiData?.news ?? [];
        _isLoading = false;
        _errorMessage = provider.informasiState.errorMessage;
      });

      print('DEBUG: News data loaded: ${_newsData?.length ?? 0} items');
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data berita: $e';
        _isLoading = false;
      });
      print('ERROR: Failed to load news data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(title: 'Berita Al-Ittifaqiah'),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
        bottomNavigationBar:
            const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Memuat berita...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNewsData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_newsData == null || _newsData!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada berita tersedia',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _newsData!.length,
      itemBuilder: (context, index) {
        final newsItem = _newsData![index];
        return _BeritaCard(
          title: newsItem.title,
          thumbnail: newsItem.thumbnailUrl,
          content: newsItem.content,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContentScreen(
                  title: newsItem.title,
                  markdownContent: newsItem.content,
                  type: ContentScreenType.minimal,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BeritaCard extends StatelessWidget {
  final String title;
  final String thumbnail;
  final String content;
  final VoidCallback? onTap;

  const _BeritaCard({
    required this.title,
    required this.thumbnail,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail di atas
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                thumbnail,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            // Judul dan tombol baca selengkapnya
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
