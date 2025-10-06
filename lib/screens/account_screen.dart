// lib/screens/account_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data statis untuk contoh
    const username = "pengguna1";
    const email = "pengguna1@email.com";
    final joinDate = DateFormat('d MMMM yyyy').format(DateTime.now());

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Akun Saya'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.green.shade800, // Diubah ke hijau tua
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildProfileHeader(context, username, email),
            const SizedBox(height: 24),
            _buildInfoCard(context, [
              _buildInfoTile(
                icon: Icons.person_outline,
                title: 'Username',
                subtitle: username,
              ),
              _buildInfoTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: email,
              ),
              _buildInfoTile(
                icon: Icons.calendar_today_outlined,
                title: 'Bergabung Sejak',
                subtitle: joinDate,
              ),
            ]),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700, // Diubah ke hijau
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Aksi logout dinonaktifkan sementara di versi statis
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fungsi Logout belum aktif.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk header profil
  Widget _buildProfileHeader(
      BuildContext context, String username, String email) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green.shade50, // Diubah ke hijau muda
          child: Text(
            username.isNotEmpty ? username[0].toUpperCase() : 'U',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800, // Diubah ke hijau tua
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          username,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Widget untuk kartu informasi
  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  // Widget untuk setiap baris informasi
  Widget _buildInfoTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade600), // Diubah ke hijau
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
