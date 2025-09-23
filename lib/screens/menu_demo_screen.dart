import 'package:flutter/material.dart';
import '../core/constants/detail_lists.dart';
import '../core/utils/menu_navigation_helper.dart';

class MenuDemoScreen extends StatelessWidget {
  const MenuDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Menu Navigation'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Navigasi Menu untuk DetailContentScreen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Menu Jenis 1 (SDM/Lembaga):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...menuItemsJenis1.map((item) => _buildMenuTile(
                  context,
                  item,
                  'Lembaga XYZ',
                  Colors.green.shade50,
                )),
            const SizedBox(height: 20),
            const Text(
              'Menu Jenis 2 (Pesantren):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            ...menuItemsJenis2.map((item) => _buildMenuTile(
                  context,
                  item,
                  'Pesantren Al-Hikam',
                  Colors.blue.shade50,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    String item,
    String categoryTitle,
    Color backgroundColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            MenuNavigationHelper.navigateToMenuItem(
              context,
              item,
              categoryTitle,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  _getIconForMenuItem(item),
                  size: 20,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForMenuItem(String item) {
    switch (item.toLowerCase()) {
      case 'profil':
        return Icons.account_circle_outlined;
      case 'program kerja':
        return Icons.work_outline;
      case 'sdm':
      case 'santri':
      case 'guru':
        return Icons.people_outline;
      case 'prestasi':
      case 'prestasi sdm':
        return Icons.military_tech_outlined;
      case 'alumni':
        return Icons.school_outlined;
      case 'galeri':
        return Icons.photo_library_outlined;
      case 'informasi':
        return Icons.info_outline;
      case 'kontak':
        return Icons.contact_phone_outlined;
      case 'peraturan sdm':
        return Icons.gavel_outlined;
      default:
        return Icons.menu_outlined;
    }
  }
}
