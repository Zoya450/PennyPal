import 'package:flutter/material.dart';

class GoalProgress extends StatelessWidget {
  final String title;
  final double current;
  final double target;

  const GoalProgress({super.key, required this.title, required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final percent = (current / target).clamp(0.0, 1.0);
    final percentLabel = '${(percent * 100).toStringAsFixed(0)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(percentLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(colorScheme.primary),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${current.toStringAsFixed(0)} / \$${target.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
      ],
    );
  }
}
