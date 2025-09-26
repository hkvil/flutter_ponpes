import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPanel extends StatelessWidget {
  const ContactPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.phone_in_talk_rounded,
              size: 28, color: Colors.black87),
          const SizedBox(height: 10),
          const _PhoneNumber(text: '0821-8888-8888'),
          const _PhoneNumber(text: '0821-8888-8888'),
          const _PhoneNumber(text: '0821-8888-8888'),
          const SizedBox(height: 18),

          // === Social Buttons ===
          SocialButtonTile(
            label: 'YouTube',
            icon: const FaIcon(FontAwesomeIcons.youtube, color: Colors.white),
            iconBg: const Color(0xFFE53935),
            barDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFF5F7FA), Color(0xFFE6ECF3)],
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
          const SizedBox(height: 14),
        ],
      ),
    );
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
                    color: Colors.black.withValues(alpha: 0.12),
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
