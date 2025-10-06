// lib/screens/account_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:pesantren_app/providers/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final isLoggedIn = authProvider.user != null;

          // Jika belum login, tampilkan UI untuk guest
          if (!isLoggedIn) {
            return _buildGuestView(context, authProvider);
          }

          // Jika sudah login, tampilkan UI normal
          final username = authProvider.user!.username;
          final email = authProvider.user!.email;
          final joinDate =
              DateFormat('d MMMM yyyy').format(authProvider.user!.createdAt);

          return _buildLoggedInView(
              context, authProvider, username, email, joinDate);
        },
      ),
    );
  }

  // Widget untuk tampilan guest (belum login)
  Widget _buildGuestView(BuildContext context, AuthProvider authProvider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green.shade800,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              Text(
                'Belum Masuk',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan masuk untuk mengakses fitur akun Anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Masuk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to login screen
                  Navigator.of(context).pushNamed('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk tampilan user yang sudah login
  Widget _buildLoggedInView(BuildContext context, AuthProvider authProvider,
      String username, String email, String joinDate) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green.shade800,
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
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
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
