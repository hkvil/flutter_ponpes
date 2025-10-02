import 'package:flutter/material.dart';
import 'package:pesantren_app/models/lembaga_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pesantren_app/screens/content_screen.dart';

class InformasiScreen extends StatefulWidget {
  final String title;
  final String? lembagaName;
  final Lembaga? lembaga;

  const InformasiScreen({
    super.key,
    required this.title,
    this.lembagaName,
    this.lembaga,
  });

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen>
    with TickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Berita'),
            Tab(text: 'Dokumen'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BeritaTab(lembaga: widget.lembaga),
          DokumenTab(lembaga: widget.lembaga),
        ],
      ),
    );
  }
}

class BeritaTab extends StatelessWidget {
  final Lembaga? lembaga;

  const BeritaTab({super.key, this.lembaga});

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada lembaga atau news kosong, tampilkan placeholder
    if (lembaga == null || lembaga!.news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Berita',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada berita tersedia',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    // Tampilkan list berita
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lembaga!.news.length,
      itemBuilder: (context, index) {
        final newsItem = lembaga!.news[index];
        return _NewsCard(
          newsItem: newsItem,
          onTap: () {
            // Navigate to detail screen dengan markdown content
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContentScreen(
                  title: newsItem.title,
                  type: ContentScreenType.minimal,
                  markdownContent: newsItem.content,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final VoidCallback onTap;

  const _NewsCard({
    required this.newsItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail di sebelah kiri
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    newsItem.thumbnail != null && newsItem.thumbnail!.isNotEmpty
                        ? Image.network(
                            newsItem.resolvedThumbnail,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.article,
                                  color: Colors.orange.shade700,
                                  size: 36,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.article,
                              color: Colors.orange.shade700,
                              size: 36,
                            ),
                          ),
              ),
              const SizedBox(width: 12),
              // Konten di sebelah kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Baca selengkapnya',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade700,
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
      ),
    );
  }
}

class DokumenTab extends StatelessWidget {
  final Lembaga? lembaga;

  const DokumenTab({super.key, this.lembaga});

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada lembaga atau files kosong, tampilkan placeholder
    if (lembaga == null || lembaga!.files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Dokumen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada dokumen tersedia',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    // Tampilkan list dokumen
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lembaga!.files.length,
      itemBuilder: (context, index) {
        final fileItem = lembaga!.files[index];
        return _FileCard(
          fileItem: fileItem,
          onTap: () async {
            // Launch URL untuk download/view file
            final url = Uri.parse(fileItem.resolvedUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tidak dapat membuka file: ${fileItem.nama}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}

class _FileCard extends StatelessWidget {
  final FileItem fileItem;
  final VoidCallback onTap;

  const _FileCard({
    required this.fileItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan icon berdasarkan ekstensi file
    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = Colors.blue.shade700;

    final url = fileItem.url.toLowerCase();
    if (url.endsWith('.pdf')) {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red.shade700;
    } else if (url.endsWith('.doc') || url.endsWith('.docx')) {
      fileIcon = Icons.description;
      iconColor = Colors.blue.shade900;
    } else if (url.endsWith('.xls') || url.endsWith('.xlsx')) {
      fileIcon = Icons.table_chart;
      iconColor = Colors.green.shade700;
    } else if (url.endsWith('.ppt') || url.endsWith('.pptx')) {
      fileIcon = Icons.slideshow;
      iconColor = Colors.orange.shade700;
    } else if (url.endsWith('.zip') || url.endsWith('.rar')) {
      fileIcon = Icons.folder_zip;
      iconColor = Colors.amber.shade700;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // File icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  fileIcon,
                  size: 32,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              // File name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileItem.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Klik untuk membuka',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Download icon
              Icon(
                Icons.download,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
