import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/banner_container.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/detail_layout.dart';

class DetailMadrasahScreen extends StatelessWidget {
  final String madrasahName;

  const DetailMadrasahScreen({
    Key? key,
    required this.madrasahName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Madrasah'),
      ),
      body: Column(
        children: [
          BannerContainer(
            assetPath: 'assets/banners/top.png',
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DetailLayout(
              title: madrasahName,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}
