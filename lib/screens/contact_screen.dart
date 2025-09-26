import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import '../widgets/contact_panel.dart';

class ContactScreen extends StatelessWidget {
  final String title;

  const ContactScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(children: [
          TopBanner(assetPath: 'assets/banners/top.png'),
          SizedBox(height: 20),
          ContactPanel()
        ]),
      ),
    );
  }
}
