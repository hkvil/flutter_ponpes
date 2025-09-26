import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import '../widgets/contact_panel.dart';
import '../widgets/banner_widget.dart';
import '../models/lembaga_model.dart';
import '../models/banner_config.dart';

class ContactScreen extends StatelessWidget {
  final String title;
  final Lembaga? lembaga;

  const ContactScreen({
    super.key,
    required this.title,
    this.lembaga,
  });

  @override
  Widget build(BuildContext context) {
    final bannerConfig = lembaga != null
        ? BannerConfig.fromLembaga(lembaga!.topBanner, lembaga!.botBanner)
        : null;

    final kontakData = lembaga?.kontak;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(children: [
          // Use API banner if available, otherwise use default banner
          if (bannerConfig != null && bannerConfig.hasTopBanner)
            BannerWidget(bannerConfig: bannerConfig)
          else
            const TopBanner(assetPath: 'assets/banners/top.png'),

          const SizedBox(height: 20),

          // Pass contact data from API to ContactPanel
          ContactPanel(kontakData: kontakData)
        ]),
      ),
    );
  }
}
