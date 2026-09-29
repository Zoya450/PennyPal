import 'package:flutter/material.dart';
import 'package:penny_pal/core/theme.dart';

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final penny = Theme.of(context).extension<PennyColors>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Icon tile: periwinkle tinted in dark, subtle neutral in light
    final iconBg = isDark
        ? (penny?.periwinkle ?? colorScheme.secondary).withValues(alpha: 0.15)
        : colorScheme.outline.withValues(alpha: 0.25);
    final iconColor = isDark
        ? const Color(0xFFB7C3FF) // light periwinkle
        : colorScheme.onSurface.withValues(alpha: 0.7);

    // Income: mint in dark, green in light
    final positiveColor = penny?.incomeMint ?? Colors.green;
    final negativeColor = colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isPositive ? positiveColor : negativeColor,
            ),
          ),
        ],
      ),
    );
  }
}
