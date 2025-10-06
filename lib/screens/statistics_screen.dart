import 'package:flutter/material.dart';
import '../widgets/top_banner.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/top_bar.dart';
import '../models/informasi_al_ittifaqiah_model.dart';

enum StatisticsType { santri, sdm, alumni }

class StatisticsScreen extends StatelessWidget {
  final StatisticsType type;
  final String title;
  final List<StatistikItem> data;

  const StatisticsScreen({
    super.key,
    required this.type,
    required this.title,
    required this.data,
  });

  // Factory constructors untuk kemudahan
  factory StatisticsScreen.santri(List<StatistikItem> santriData) {
    return StatisticsScreen(
      type: StatisticsType.santri,
      title: 'Jumlah Santri Al-Ittifaqiah',
      data: santriData,
    );
  }

  factory StatisticsScreen.sdm(List<StatistikItem> sdmData) {
    return StatisticsScreen(
      type: StatisticsType.sdm,
      title: 'Jumlah SDM Al-Ittifaqiah',
      data: sdmData,
    );
  }

  factory StatisticsScreen.alumni(List<StatistikItem> alumniData) {
    return StatisticsScreen(
      type: StatisticsType.alumni,
      title: 'Jumlah Alumni Al-Ittifaqiah',
      data: alumniData,
    );
  }

  // Hitung total dari data API
  int get total {
    return data.fold(0, (sum, item) => sum + int.parse(item.jumlah.toString()));
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: TopBar(title: title),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Tidak ada data statistik tersedia',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              const BottomBanner(assetPath: 'assets/banners/bottom.png'),
        ),
      );
    }

    // Convert StatistikItem to Map format yang digunakan desain asli
    final List<Map<String, dynamic>> convertedData = data
        .map((item) => {
              'lembaga': 'Tahun ${item.tahun}',
              'jumlah': item.jumlah,
            })
        .toList();

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: TopBar(title: title),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Header dengan total - menggunakan desain asli
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: _CustomListTile(
                        title: 'TOTAL',
                        value: total.toString(),
                        isTotal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // List per tahun - menggunakan desain asli
                    ...convertedData
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _CustomListTile(
                                title: item['lembaga'],
                                value: item['jumlah'].toString(),
                                isTotal: false,
                              ),
                            ))
                        .toList(),
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
}

// Widget yang sama dengan StatisticsScreen asli
class _CustomListTile extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _CustomListTile({
    required this.title,
    required this.value,
    required this.isTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Title section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isTotal ? 16 : 14,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Separator line
          Container(
            width: 1,
            height: 40,
            color: Colors.green.shade300,
          ),
          // Value section
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTotal ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
