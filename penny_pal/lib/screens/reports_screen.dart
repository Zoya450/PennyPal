import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/providers/transaction_provider.dart';
import 'package:penny_pal/widgets/spending_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final txProvider = Provider.of<TransactionProvider>(context);
    final transactions = txProvider.transactions;
    
    // Calculate actual totals
    double totalIncome = 0;
    double totalExpense = 0;
    
    // Calculate category spending
    final Map<String, double> categoryTotals = {};
    
    for (final tx in transactions) {
      if (tx.type.toLowerCase() == 'income') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
        final cat = tx.categoryId;
        categoryTotals[cat] = (categoryTotals[cat] ?? 0) + tx.amount;
      }
    }
    
    final netSavings = totalIncome - totalExpense;
    
    // Prepare categories list sorted by amount
    final List<Map<String, dynamic>> categories = [];
    if (totalExpense > 0) {
      categoryTotals.forEach((key, value) {
        categories.add({
          'label': key,
          'amount': value,
          'percent': value / totalExpense,
        });
      });
      categories.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final childAspectRatio = screenWidth < 360 ? 1.8 : 2.2;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reports', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('All Time Summary', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 13)),
              const SizedBox(height: 24),
              // Summary
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: childAspectRatio,
                children: [
                  _ReportCard(label: 'Total income', value: '\$${totalIncome.toStringAsFixed(0)}', color: colorScheme.primary),
                  _ReportCard(label: 'Total expenses', value: '\$${totalExpense.toStringAsFixed(0)}', color: Colors.orange),
                  _ReportCard(label: 'Net savings', value: '\$${netSavings.toStringAsFixed(0)}', color: netSavings >= 0 ? Colors.green : Colors.red),
                  _ReportCard(label: 'Tx Count', value: '${transactions.length}', color: colorScheme.onSurface),
                ],
              ),
              const SizedBox(height: 24),
              // Spending trend chart
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weekly spending trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 20),
                    const SpendingChart(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Category breakdown
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Spending by category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 18),
                    if (categories.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text('No expense data yet.', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                        ),
                      )
                    else
                      ...categories.map((cat) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(cat['label'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('\$${(cat['amount'] as double).toStringAsFixed(0)} (${((cat['percent'] as double) * 100).toStringAsFixed(0)}%)',
                                    style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.6))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: cat['percent'] as double,
                                minHeight: 8,
                                backgroundColor: colorScheme.outline.withValues(alpha: 0.25),
                                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ReportCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.55))),
          ],
        ),
      ),
    );
  }
}

