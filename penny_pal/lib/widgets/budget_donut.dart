import 'dart:math';
import 'package:flutter/material.dart';
import 'package:penny_pal/core/theme.dart';

class BudgetDonut extends StatelessWidget {
  final int percent;
  final double total;
  final String label;

  const BudgetDonut({super.key, required this.percent, required this.total, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final penny = Theme.of(context).extension<PennyColors>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // In dark: gold fill + periwinkle secondary / white 9% track
    // In light: primary fill / outline 30% track
    final fillColor = colorScheme.primary;
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : colorScheme.outline.withValues(alpha: 0.3);

    final used = total * percent / 100;
    final remaining = total - used;

    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _DonutPainter(
              percent: percent / 100,
              fillColor: fillColor,
              secondaryColor: penny?.periwinkle ?? colorScheme.secondary,
              trackColor: trackColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${remaining.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'left',
              style: TextStyle(
                fontSize: 13,
                color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '14 days to go',
              style: TextStyle(
                fontSize: 12,
                color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percent;
  final Color fillColor;
  final Color secondaryColor;
  final Color trackColor;

  _DonutPainter({
    required this.percent,
    required this.fillColor,
    required this.secondaryColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 16.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Track (remainder)
    paint.color = trackColor;
    canvas.drawCircle(center, radius, paint);

    // Fill arc (gold / primary)
    paint.color = fillColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percent,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.fillColor != fillColor;
}
