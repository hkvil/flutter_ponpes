import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/lembaga_model.dart';

class GaleriScreen extends StatefulWidget {
  final String title;
  final Lembaga? lembaga; // Optional API data

  const GaleriScreen({
    super.key,
    required this.title,
    this.lembaga,
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
            _FotoTab(lembaga: widget.lembaga),
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

  const _FotoTab({this.lembaga});

  // Data foto static untuk demo jika tidak ada dari API
  static const List<Map<String, String>> demoFotos = [
    {
      'title': 'Kegiatan Pembelajaran',
      'image': 'https://picsum.photos/400/300?random=1',
      'description': 'Suasana pembelajaran di kelas',
      'date': '15 September 2024'
    },
    {
      'title': 'Sholat Berjamaah',
      'image': 'https://picsum.photos/400/300?random=2',
      'description': 'Sholat berjamaah di masjid pesantren',
      'date': '14 September 2024'
    },
    {
      'title': 'Kajian Kitab Kuning',
      'image': 'https://picsum.photos/400/300?random=3',
      'description': 'Santri mengkaji kitab kuning bersama ustadz',
      'date': '13 September 2024'
    },
    {
      'title': 'Kegiatan Olahraga',
      'image': 'https://picsum.photos/400/300?random=4',
      'description': 'Olahraga rutin santri di lapangan',
      'date': '12 September 2024'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Gunakan data dari API jika ada, jika tidak gunakan demo data
    final fotos = _getFotoData();

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
                  '${fotos.length} Foto',
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

        // Grid foto
        Expanded(
          child: fotos.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: fotos.length,
                  itemBuilder: (context, index) {
                    final foto = fotos[index];
                    return _buildFotoCard(context, foto, index, fotos);
                  },
                ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getFotoData() {
    if (lembaga != null && lembaga!.images.isNotEmpty) {
      // Convert API data ke format yang dibutuhkan
      return lembaga!.images
          .map((imageItem) => {
                'title': imageItem.title ?? 'Foto ${lembaga!.nama}',
                'image': imageItem.resolvedUrl,
                'description': 'Dokumentasi kegiatan ${lembaga!.nama}',
                'date': lembaga!.updatedAt?.toString().split(' ').first ??
                    'Unknown date',
              })
          .toList();
    }
    // Fallback ke demo data
    return demoFotos;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada foto',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Foto akan ditampilkan di sini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoCard(BuildContext context, Map<String, String> foto,
      int index, List<Map<String, String>> allFotos) {
    return GestureDetector(
      onTap: () => _showFotoDetail(context, foto, index, allFotos),
      child: Card(
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
                    image: NetworkImage(foto['image']!),
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
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 20,
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
                    foto['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                          foto['date']!,
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
      ),
    );
  }

  void _showFotoDetail(BuildContext context, Map<String, String> foto,
      int index, List<Map<String, String>> allFotos) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FotoDetailScreen(
          fotos: allFotos,
          initialIndex: index,
        ),
      ),
    );
  }
}

// Tab Video
class _VideoTab extends StatelessWidget {
  final Lembaga? lembaga;

  const _VideoTab({this.lembaga});

  // Data video static untuk demo jika tidak ada dari API
  static const List<Map<String, String>> demoVideos = [
    {
      'title': 'Profil Pondok Pesantren',
      'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'duration': '5:24',
      'description': 'Video profil lengkap pondok pesantren',
      'date': '20 September 2024',
      'youtube_id': 'dQw4w9WgXcQ',
    },
    {
      'title': 'Kegiatan Pembelajaran Santri',
      'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'duration': '3:45',
      'description': 'Dokumentasi kegiatan pembelajaran sehari-hari santri',
      'date': '18 September 2024',
      'youtube_id': 'dQw4w9WgXcQ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Gunakan data dari API jika ada, jika tidak gunakan demo data
    final videos = _getVideoData();

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
                  '${videos.length} Video',
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

        // List video
        Expanded(
          child: videos.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return _buildVideoCard(context, video);
                  },
                ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getVideoData() {
    if (lembaga != null && lembaga!.videos.isNotEmpty) {
      // Convert API data ke format yang dibutuhkan
      return lembaga!.videos.map((videoItem) {
        final youtubeId = _extractYouTubeId(videoItem.videoUrl ?? '');
        return {
          'title': videoItem.title ?? 'Video ${lembaga!.nama}',
          'thumbnail':
              'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg',
          'duration': '0:00', // Duration tidak ada di API, set default
          'description': 'Video dokumentasi ${lembaga!.nama}',
          'date':
              lembaga!.updatedAt?.toString().split(' ').first ?? 'Unknown date',
          'youtube_id': youtubeId,
        };
      }).toList();
    }
    // Fallback ke demo data
    return demoVideos;
  }

  String _extractYouTubeId(String url) {
    // Extract YouTube ID dari URL
    final regex = RegExp(
        r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})');
    final match = regex.firstMatch(url);
    return match?.group(1) ?? 'dQw4w9WgXcQ'; // Fallback ID
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada video',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Video akan ditampilkan di sini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, String> video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _playYouTubeVideo(video['youtube_id']!),
        borderRadius: BorderRadius.circular(12),
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
                  image: NetworkImage(video['thumbnail']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Play button overlay
                  Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  // Duration badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video['duration']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Video info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video['description']!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
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
                        video['date']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tonton',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.bold,
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

  Future<void> _playYouTubeVideo(String videoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Handle error - could show a snackbar
      print('Could not launch YouTube video');
    }
  }
}

// Screen detail foto dengan gallery viewer
class _FotoDetailScreen extends StatefulWidget {
  final List<Map<String, String>> fotos;
  final int initialIndex;

  const _FotoDetailScreen({
    required this.fotos,
    required this.initialIndex,
  });

  @override
  State<_FotoDetailScreen> createState() => _FotoDetailScreenState();
}

class _FotoDetailScreenState extends State<_FotoDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFoto = widget.fotos[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} dari ${widget.fotos.length}'),
      ),
      body: Column(
        children: [
          // Image viewer
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemCount: widget.fotos.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Center(
                    child: Image.network(
                      widget.fotos[index]['image']!,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Info panel
          Container(
            color: Colors.black.withOpacity(0.8),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentFoto['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentFoto['description']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentFoto['date']!,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
