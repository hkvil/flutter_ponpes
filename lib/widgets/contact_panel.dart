import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/lembaga_model.dart';

class ContactPanel extends StatelessWidget {
  final List<KontakItem>? kontakData;

  const ContactPanel({super.key, this.kontakData});

  @override
  Widget build(BuildContext context) {
    // Separate phone numbers and social media
    final phoneNumbers =
        kontakData?.where((k) => k.jenis == 'telp').toList() ?? [];
    final socialMedia =
        kontakData?.where((k) => k.jenis != 'telp').toList() ?? [];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.phone_in_talk_rounded,
              size: 28, color: Colors.black87),
          const SizedBox(height: 10),

          // Display phone numbers from API or fallback to static
          if (phoneNumbers.isNotEmpty) ...[
            ...phoneNumbers
                .map((phone) => _PhoneNumber(text: phone.value ?? 'N/A')),
          ] else ...[
            // Fallback static phone numbers
            const _PhoneNumber(text: '0821-8888-8888'),
            const _PhoneNumber(text: '0821-8888-8888'),
            const _PhoneNumber(text: '0821-8888-8888'),
          ],

          const SizedBox(height: 18),

          // Display social media from API or fallback to static
          if (socialMedia.isNotEmpty) ...[
            ...socialMedia.map((social) => _buildSocialButton(social)),
          ] else ...[
            // Fallback static social buttons
            ..._buildStaticSocialButtons(),
          ],

          const SizedBox(height: 14),
        ],
      ),
    );
  }

  /// Build social button from API data
  Widget _buildSocialButton(KontakItem social) {
    final socialConfig = _getSocialConfig(social.jenis ?? '');

    return Column(
      children: [
        SocialButtonTile(
          label: social.value ?? 'N/A', // Use the actual value from API
          icon: socialConfig['icon']!,
          iconBg: socialConfig['iconBg']!,
          barDecoration: socialConfig['decoration']!,
          onTap: () {
            // TODO: Implement actual social media links
            print('Opening ${social.jenis}: ${social.value}');
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// Get social media configuration
  Map<String, dynamic> _getSocialConfig(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'youtube':
        return {
          'label': 'YouTube',
          'icon': const FaIcon(FontAwesomeIcons.youtube, color: Colors.white),
          'iconBg': const Color(0xFFE53935),
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFF4444),
                Color(0xFFCC1414)
              ], // Red gradient for better contrast
            ),
          ),
        };
      case 'facebook':
        return {
          'label': 'Facebook',
          'icon': const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
          'iconBg': const Color(0xFF1877F2),
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFF3B5998), Color(0xFF1C3E7C)],
            ),
          ),
        };
      case 'twitter':
      case 'x':
        return {
          'label': 'Twitter',
          'icon': const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
          'iconBg': const Color(0xFF1DA1F2),
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFF8ED0F9), Color(0xFF2E95D3)],
            ),
          ),
        };
      case 'line':
        return {
          'label': 'LINE',
          'icon': const FaIcon(FontAwesomeIcons.line, color: Colors.white),
          'iconBg': const Color(0xFF06C755),
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF2CD10C),
          ),
        };
      case 'whatsapp':
        return {
          'label': 'WhatsApp',
          'icon': const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
          'iconBg': const Color(0xFF25D366),
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFF1EBE5F), Color(0xFF12A753)],
            ),
          ),
        };
      case 'instagram':
        return {
          'label': 'Instagram',
          'icon': const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
          'iconBg': const Color(0xFFFCAF45),
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFC347), // yellow
                Color(0xFFFF6A43), // orange
                Color(0xFFFF2F73), // pink
                Color(0xFF6C47FF), // purple
              ],
            ),
          ),
        };
      default:
        return {
          'label': jenis.toUpperCase(),
          'icon': const Icon(Icons.link, color: Colors.white),
          'iconBg': Colors.grey,
          'decoration': BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade400,
          ),
        };
    }
  }

  /// Build static social buttons (fallback)
  List<Widget> _buildStaticSocialButtons() {
    return [
      SocialButtonTile(
        label: 'YouTube',
        icon: const FaIcon(FontAwesomeIcons.youtube, color: Colors.white),
        iconBg: const Color(0xFFE53935),
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFF4444),
              Color(0xFFCC1414)
            ], // Red gradient for better contrast
          ),
        ),
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SocialButtonTile(
        label: 'Facebook',
        icon: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
        iconBg: const Color(0xFF1877F2),
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B5998), Color(0xFF1C3E7C)],
          ),
        ),
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SocialButtonTile(
        label: 'Twitter',
        icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
        iconBg: const Color(0xFF1DA1F2),
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF8ED0F9), Color(0xFF2E95D3)],
          ),
        ),
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SocialButtonTile(
        label: 'LINE',
        icon: const FaIcon(FontAwesomeIcons.line, color: Colors.white),
        iconBg: const Color(0xFF06C755),
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF2CD10C),
        ),
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SocialButtonTile(
        label: 'WhatsApp',
        icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
        iconBg: const Color(0xFF25D366),
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF1EBE5F), Color(0xFF12A753)],
          ),
        ),
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SocialButtonTile(
        label: 'Instagram',
        icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
        iconBg: const Color(0xFFFCAF45),
        barDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFC347), // yellow
              Color(0xFFFF6A43), // orange
              Color(0xFFFF2F73), // pink
              Color(0xFF6C47FF), // purple
            ],
          ),
        ),
        onTap: () {},
      ),
    ];
  }
}

class _PhoneNumber extends StatelessWidget {
  final String text;
  const _PhoneNumber({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        letterSpacing: 0.3,
        color: Colors.black87,
      ),
    );
  }
}

class SocialButtonTile extends StatelessWidget {
  final String label;
  final Widget icon;
  final Color iconBg;
  final BoxDecoration barDecoration;
  final VoidCallback? onTap;

  const SocialButtonTile({
    super.key,
    required this.label,
    required this.icon,
    required this.iconBg,
    required this.barDecoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 40;
    const double iconSize = 36;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: barHeight,
            decoration: barDecoration,
            margin: const EdgeInsets.only(left: 22),
            child: Row(
              children: [
                const SizedBox(width: 36),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: (barHeight - iconSize) / 2 - 2,
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                    color: Colors.black.withOpacity(0.12),
                  )
                ],
              ),
              child: Center(child: icon),
            ),
          ),
        ],
      ),
    );
  }
}
