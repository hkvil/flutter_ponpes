import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';

/// Splash screen shown when the app starts.
///
/// This screen displays a logo and title against a white background and
/// automatically navigates to the home screen after a short delay. It
/// ensures that the splash appears only briefly and uses the system's
/// Navigator to push the next route when ready.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Logo(),
            SizedBox(height: 16),
            Text(
              'SISTEM INFORMASI - DATABASE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'PONDOK PESANTREN AL-ITTIFAQIAH INDRALAYA',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'ORGAN ILIR SUMATERA SELATAN INDONESIA',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Private widget to display the splash logo with fallback.
class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: 96,
      errorBuilder: (_, __, ___) => const FlutterLogo(size: 96),
    );
  }
}
