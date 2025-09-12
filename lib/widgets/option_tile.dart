import 'package:flutter/material.dart';
import 'package:pesantren_app/screens/madrasah/detail_madrasah_screen.dart';
import '../core/theme/app_colors.dart';

/// Data model untuk setiap menu, dengan opsi sub-item (children).
class Node {
  final String title;
  final List<String>? children;
  const Node(this.title, [this.children]);
}

/// Tile yang bisa diekspand jika `children` tidak kosong.
class OptionTile extends StatefulWidget {
  final int index;
  final Node node;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.index,
    required this.node,
    this.onTap,
  });

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren =
        widget.node.children != null && widget.node.children!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() => _expanded = !_expanded);
              } else {
                widget.onTap?.call();
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                // kotak putih dengan nomor
                Container(
                  height: 44,
                  width: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${widget.index}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                // panel hijau dengan judul dan ikon panah
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.node.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          hasChildren
                              ? (_expanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right)
                              : Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // daftar sub-item jika expanded
          if (_expanded && hasChildren)
            Column(
              children: [
                for (final child in widget.node.children!)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 62,
                      top: 4,
                      right: 12,
                      bottom: 4,
                    ),
                    child: InkWell(
                      onTap: () {
                        // tindakan saat sub-item ditekan
                        SnackBar snackBar = SnackBar(
                          content: Text('Anda memilih: $child'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailMadrasahScreen(
                              madrasahName:
                                  child, // atau data lain sesuai kebutuhan
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          child,
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
