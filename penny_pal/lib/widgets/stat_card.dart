import 'package:flutter/material.dart';
import 'package:penny_pal/core/theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final bool isHero;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final penny = Theme.of(context).extension<PennyColors>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Hero balance card: gold-to-periwinkle tinted gradient in dark
    final heroBorderColor = isDark ? AppTheme.darkGold : colorScheme.primary;
    final heroValueColor = isDark ? AppTheme.darkGold : colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // Hero card gets subtle gold/periwinkle gradient in dark mode
        gradient: isHero && isDark
            ? LinearGradient(
                colors: [
                  AppTheme.darkGold.withValues(alpha: 0.20),
                  AppTheme.darkPeriwinkle.withValues(alpha: 0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isHero && isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHero ? heroBorderColor : colorScheme.outline,
          width: isHero ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isHero
                    ? heroValueColor
                    : (penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isHero ? heroValueColor : colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
