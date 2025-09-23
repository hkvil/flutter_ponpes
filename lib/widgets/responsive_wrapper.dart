import 'package:flutter/material.dart';

/// Widget wrapper untuk membuat layout responsive
///
/// Untuk layar lebar > 600px (tablet/desktop): dibatasi maxWidth 600px dan di-center
/// Untuk layar ≤ 600px (mobile): menggunakan seluruh lebar layar
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika lebar layar > maxWidth (tablet/desktop), batasi dengan maxWidth
        if (constraints.maxWidth > maxWidth) {
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          );
        } else {
          // Untuk mobile/HP, gunakan child langsung tanpa pembatasan
          return child;
        }
      },
    );
  }
}
