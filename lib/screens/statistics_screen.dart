import 'package:flutter/material.dart';
import '../widgets/top_banner.dart';
import '../widgets/bottom_banner.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/top_bar.dart';

enum StatisticsType { santri, sdm, alumni }

class StatisticsScreen extends StatelessWidget {
  final StatisticsType type;
  final String title;
  final List<Map<String, dynamic>> data;
  final int total;

  const StatisticsScreen({
    super.key,
    required this.type,
    required this.title,
    required this.data,
    required this.total,
  });

  // Factory constructors untuk kemudahan
  factory StatisticsScreen.santri() {
    return StatisticsScreen(
      type: StatisticsType.santri,
      title: 'Jumlah Santri Al-Ittifaqiah',
      total: 5120,
      data: const [
        {'lembaga': 'Taman Kanak-Kanak', 'jumlah': 430},
        {'lembaga': 'Taman Pendidikan Al-Quran', 'jumlah': 120},
        {'lembaga': 'Madrasah Tahfidz Lil Ath Fal', 'jumlah': 110},
        {'lembaga': 'Madrasah Diniyah', 'jumlah': 130},
        {'lembaga': 'Madrasah Ibtidaiyah', 'jumlah': 700},
        {'lembaga': 'Madrasah Tsanawiyah Putra', 'jumlah': 430},
        {'lembaga': 'Madrasah Tsanawiyah Putri', 'jumlah': 560},
        {'lembaga': 'Madrasah Aliyah Putra', 'jumlah': 429},
        {'lembaga': 'Madrasah Aliyah Putri', 'jumlah': 580},
        {'lembaga': 'IAIQI Indralaya', 'jumlah': 590},
      ],
    );
  }

  factory StatisticsScreen.sdm() {
    return StatisticsScreen(
      type: StatisticsType.sdm,
      title: 'Jumlah SDM Al-Ittifaqiah',
      total: 195,
      data: const [
        {'lembaga': 'Taman Kanak-Kanak', 'jumlah': 12},
        {'lembaga': 'Taman Pendidikan Al-Quran', 'jumlah': 8},
        {'lembaga': 'Madrasah Tahfidz Lil Ath Fal', 'jumlah': 6},
        {'lembaga': 'Madrasah Diniyah', 'jumlah': 10},
        {'lembaga': 'Madrasah Ibtidaiyah', 'jumlah': 25},
        {'lembaga': 'Madrasah Tsanawiyah Putra', 'jumlah': 18},
        {'lembaga': 'Madrasah Tsanawiyah Putri', 'jumlah': 20},
        {'lembaga': 'Madrasah Aliyah Putra', 'jumlah': 22},
        {'lembaga': 'Madrasah Aliyah Putri', 'jumlah': 24},
        {'lembaga': 'IAIQI Indralaya', 'jumlah': 35},
        {'lembaga': 'Administrasi Pusat', 'jumlah': 15},
      ],
    );
  }

  factory StatisticsScreen.alumni() {
    return StatisticsScreen(
      type: StatisticsType.alumni,
      title: 'Jumlah Alumni Al-Ittifaqiah',
      total: 10000,
      data: const [
        {'lembaga': 'Madrasah Ibtidaiyah', 'jumlah': 2500},
        {'lembaga': 'Madrasah Tsanawiyah Putra', 'jumlah': 1800},
        {'lembaga': 'Madrasah Tsanawiyah Putri', 'jumlah': 1900},
        {'lembaga': 'Madrasah Aliyah Putra', 'jumlah': 1600},
        {'lembaga': 'Madrasah Aliyah Putri', 'jumlah': 1700},
        {'lembaga': 'IAIQI Indralaya', 'jumlah': 500},
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: TopBar(title: title),
        body: Column(
          children: [
            const TopBanner(assetPath: 'assets/banners/top.png'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Total Card
                  _CustomListTile(
                    title: title,
                    value: total.toString(),
                    isTotal: true,
                  ),
                  const SizedBox(height: 16),
                  // List per lembaga
                  ...data
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
          ],
        ),
        bottomNavigationBar:
            const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}

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
