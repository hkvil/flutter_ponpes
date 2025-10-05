import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/lembaga_model.dart';

class GaleriScreen extends StatefulWidget {
  final String title;
  final Lembaga? lembaga; // Optional API data
  final int crossAxisCount; // Number of columns in grid (1 or 2)

  const GaleriScreen({
    super.key,
    required this.title,
    this.lembaga,
    this.crossAxisCount = 2, // Default 2 columns
  });

  @override
  State<GaleriScreen> createState() => _GaleriScreenState();
}

class _GaleriScreenState extends State<GaleriScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if we have any data
    final hasApiImages = widget.lembaga?.images.isNotEmpty == true;
    final hasApiVideos = widget.lembaga?.videos.isNotEmpty == true;
    final hasAnyData = hasApiImages || hasApiVideos;

    if (!hasAnyData) {
      return ResponsiveWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Belum ada Data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Galeri foto dan video akan ditampilkan di sini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                icon: Icon(Icons.photo_library),
                text: 'Foto',
              ),
              Tab(
                icon: Icon(Icons.video_library),
                text: 'Video',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _FotoTab(
                lembaga: widget.lembaga, crossAxisCount: widget.crossAxisCount),
            _VideoTab(lembaga: widget.lembaga),
          ],
        ),
      ),
    );
  }
}

// Tab Foto
class _FotoTab extends StatelessWidget {
  final Lembaga? lembaga;
  final int crossAxisCount;

  const _FotoTab({this.lembaga, this.crossAxisCount = 2});

  @override
  Widget build(BuildContext context) {
    // Check if we have API data
    final hasApiImages = lembaga?.images.isNotEmpty == true;

    if (!hasApiImages) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada Foto',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Foto kegiatan akan ditampilkan di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header info
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Icon(Icons.photo_library, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                lembaga != null
                    ? 'Galeri ${lembaga!.nama}'
                    : 'Dokumentasi Kegiatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${lembaga!.images.length} Foto',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Grid foto dari API
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.8,
            ),
            itemCount: lembaga!.images.length,
            itemBuilder: (context, index) {
              final imageItem = lembaga!.images[index];
              return _buildFotoCard(context, imageItem, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFotoCard(BuildContext context, ImageItem imageItem, int index) {
    // Use image URL from API, fallback to placeholder if not available
    final imageUrl = imageItem.resolvedUrl.isNotEmpty
        ? imageItem.resolvedUrl
        : 'https://picsum.photos/400/300?random=${imageItem.id ?? index + 1}';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        final allImageUrls = lembaga!.images
                            .map((img) => img.resolvedUrl.isNotEmpty
                                ? img.resolvedUrl
                                : 'https://picsum.photos/400/300?random=${img.id ?? (lembaga!.images.indexOf(img) + 1)}')
                            .toList();
                        _openPhotoViewer(
                            context, imageUrl, allImageUrls, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  imageItem.title ?? 'Foto ${lembaga?.nama}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (imageItem.desc != null)
                  Text(
                    imageItem.desc!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        imageItem.date ?? 'Tanggal tidak tersedia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openPhotoViewer(BuildContext context, String imageUrl,
      List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewer(
          imageUrl: imageUrl,
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class PhotoViewer extends StatelessWidget {
  final String imageUrl;
  final List<String> images;
  final int initialIndex;

  const PhotoViewer({
    Key? key,
    required this.imageUrl,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Foto ${initialIndex + 1} dari ${images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 3.0,
        initialScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(
          tag: 'photo_$initialIndex',
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}

// Tab Video
class _VideoTab extends StatelessWidget {
  final Lembaga? lembaga;

  const _VideoTab({this.lembaga});

  @override
  Widget build(BuildContext context) {
    // Check if we have API data
    final hasApiVideos = lembaga?.videos.isNotEmpty == true;

    if (!hasApiVideos) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada Video',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Video dokumentasi akan ditampilkan di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header info
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Icon(Icons.video_library, color: Colors.red.shade600),
              const SizedBox(width: 8),
              Text(
                lembaga != null
                    ? 'Video ${lembaga!.nama}'
                    : 'Video Dokumentasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${lembaga!.videos.length} Video',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List video dari API
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lembaga!.videos.length,
            itemBuilder: (context, index) {
              final videoItem = lembaga!.videos[index];
              return _buildVideoCard(context, videoItem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoItem videoItem) {
    final youtubeId = _extractYouTubeId(videoItem.videoUrl ?? '');
    final thumbnailUrl =
        'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchVideo(videoItem.videoUrl ?? ''),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoItem.title ?? 'Video ${lembaga?.nama}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (videoItem.desc != null)
                    Text(
                      videoItem.desc!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        videoItem.date ?? 'Tanggal tidak tersedia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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

  String _extractYouTubeId(String url) {
    // Extract YouTube ID dari URL
    final regex = RegExp(
        r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})');
    final match = regex.firstMatch(url);
    return match?.group(1) ?? 'dQw4w9WgXcQ'; // Fallback ID
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
