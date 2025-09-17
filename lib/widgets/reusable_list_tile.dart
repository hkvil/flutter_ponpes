import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ReusableListTileWidget extends StatelessWidget {
  final int? value;
  final String titleText;
  final Color? indexColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const ReusableListTileWidget({
    Key? key,
    this.value,
    required this.titleText,
    this.indexColor,
    this.titleColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black.withOpacity(1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // kotak putih dengan value
              Container(
                height: 44,
                width: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: indexColor ?? Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  value != null ? '$value' : '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              // panel hijau dengan judul
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    titleText,
                    style: TextStyle(
                      color: titleColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
