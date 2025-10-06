import 'package:flutter/material.dart';
import '../widgets/top_banner.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/top_bar.dart';
import '../widgets/section_header.dart';
import '../models/informasi_al_ittifaqiah_model.dart';

class BlueprintIsciScreen extends StatelessWidget {
  final List<GaleriItem> blueprintItems;

  const BlueprintIsciScreen({
    super.key,
    required this.blueprintItems,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: const TopBar(title: 'BluePrint ISCI'),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: blueprintItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.architecture_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada data BluePrint ISCI',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            title: 'BluePrint ISCI Al-Ittifaqiah',
                          ),
                          const Text(
                            'Rencana Pembangunan Masa Depan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: blueprintItems.length,
                            itemBuilder: (context, index) {
                              final item = blueprintItems[index];
                              return _buildBlueprintCard(context, item);
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        bottomNavigationBar:
            const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }

  Widget _buildBlueprintCard(BuildContext context, GaleriItem item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: item.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.architecture_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.architecture_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
