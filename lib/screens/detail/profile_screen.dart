import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/banner_container.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/section_header.dart';
import '../../widgets/profile_list.dart';
import '../../models/profile_section.dart';

class ProfileScreen extends StatelessWidget {
  final String title;
  final List<ProfileSection> sections;
  const ProfileScreen({required this.title, required this.sections, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerContainer(assetPath: 'assets/banners/top.png'),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionHeader(
                title: title,
                width: 200,
              ),
              ProfileList(sections: sections),
            ]),
          )
        ],
      ),
      bottomNavigationBar: BottomBanner(assetPath: 'assets/banners/bottom.png'),
    );
  }
}
