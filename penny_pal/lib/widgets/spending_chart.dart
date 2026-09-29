import 'package:flutter/material.dart';
import 'package:penny_pal/core/theme.dart';
import 'package:penny_pal/models/transaction_model.dart';

class SpendingChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  const SpendingChart({super.key, this.transactions = const []});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final penny = Theme.of(context).extension<PennyColors>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bars = _buildWeeklyBars();
    final maxVal = bars.map((b) => b.value).fold(0.0, (a, b) => a > b ? a : b);

    // Muted bar: periwinkle 30% in dark, outline in light
    final mutedBarColor = isDark
        ? (penny?.periwinkleMuted ?? AppTheme.darkPeriwinkle.withValues(alpha: 0.3))
        : colorScheme.outline.withValues(alpha: 0.4);

    return SizedBox(
      height: 150,
      child: bars.isEmpty
          ? Center(
              child: Text(
                'No data yet',
                style: TextStyle(
                  color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars.map((bar) {
                final relativeHeight = maxVal > 0 ? bar.value / maxVal : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          height: 110 * relativeHeight,
                          decoration: BoxDecoration(
                            // Highlighted bar: gold gradient in dark, primary in light
                            gradient: bar.isHighlight && isDark
                                ? penny?.goldGradient
                                : null,
                            color: bar.isHighlight
                                ? (isDark ? null : colorScheme.primary)
                                : mutedBarColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                              bottom: Radius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            bar.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: penny?.mutedText ??
                                  colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  List<_Bar> _buildWeeklyBars() {
    if (transactions.isEmpty) return [];

    final now = DateTime.now();
    final Map<int, double> dailyTotals = {};
    for (int i = 6; i >= 0; i--) {
      dailyTotals[i] = 0.0;
    }

    for (final tx in transactions) {
      if (tx.type != 'Expense') continue;
      final diff = now.difference(tx.date).inDays;
      if (diff >= 0 && diff < 7) {
        dailyTotals[diff] = (dailyTotals[diff] ?? 0) + tx.amount;
      }
    }

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final result = <_Bar>[];
    for (int i = 6; i >= 0; i--) {
      final dayIndex = (now.weekday - 1 - i) % 7;
      final label = dayLabels[dayIndex.clamp(0, 6)];
      final val = dailyTotals[i] ?? 0.0;
      result.add(_Bar(label, val, i == 0));
    }

    return result;
  }
}

class _Bar {
  final String label;
  final double value;
  final bool isHighlight;
  const _Bar(this.label, this.value, this.isHighlight);
}
