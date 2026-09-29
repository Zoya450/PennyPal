import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:penny_pal/models/budget_model.dart';
import 'package:penny_pal/providers/budget_provider.dart';
import 'package:penny_pal/providers/transaction_provider.dart';
import 'package:penny_pal/widgets/add_transaction_sheet.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  static const _categoryIcons = {
    'Food': Icons.fastfood_outlined,
    'Transport': Icons.directions_bus_outlined,
    'Education': Icons.school_outlined,
    'Entertainment': Icons.movie_outlined,
    'Health': Icons.favorite_border,
    'Shopping': Icons.shopping_bag_outlined,
    'Other': Icons.attach_money,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final txProvider = Provider.of<TransactionProvider>(context);

    final now = DateTime.now();
    final monthLabel = '${_monthName(now.month)} ${now.year}';

    // Build a map of category -> total spent this month from transactions
    final Map<String, double> spentByCategory = {};
    for (final tx in txProvider.transactions) {
      if (tx.type == 'Expense' && tx.date.month == now.month && tx.date.year == now.year) {
        spentByCategory[tx.categoryId] = (spentByCategory[tx.categoryId] ?? 0) + tx.amount;
      }
    }

    final budgets = budgetProvider.budgets;
    final totalLimit = budgets.fold(0.0, (sum, b) => sum + b.limitAmount);
    final totalSpent = budgets.fold(0.0, (sum, b) => sum + (spentByCategory[b.categoryId] ?? 0));
    final totalRemaining = totalLimit - totalSpent;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budgets',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(monthLabel,
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 13)),
              const SizedBox(height: 20),

              // Summary card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: _summaryItem(context, 'Total Budget',
                            '\$${totalLimit.toStringAsFixed(0)}', colorScheme.onSurface)),
                    Container(width: 1, height: 40, color: colorScheme.outline),
                    Expanded(
                        child: _summaryItem(context, 'Spent',
                            '\$${totalSpent.toStringAsFixed(0)}', Colors.orange)),
                    Container(width: 1, height: 40, color: colorScheme.outline),
                    Expanded(
                        child: _summaryItem(context, 'Remaining',
                            '\$${totalRemaining.toStringAsFixed(0)}', colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Budget list
              Expanded(
                child: budgetProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : budgets.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pie_chart_outline,
                                    size: 52,
                                    color: colorScheme.onSurface.withValues(alpha: 0.25)),
                                const SizedBox(height: 16),
                                Text(
                                  'No budgets yet.\nTap "Create" to set your first monthly budget.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: colorScheme.onSurface.withValues(alpha: 0.5)),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: budgets.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 14),
                            itemBuilder: (_, i) => _buildBudgetCard(
                                context, budgets[i], spentByCategory, colorScheme),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(
      BuildContext context, String label, String value, Color valueColor) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: valueColor)),
        ),
        const SizedBox(height: 4),
        Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
      ],
    );
  }

  Widget _buildBudgetCard(BuildContext context, BudgetModel budget,
      Map<String, double> spentByCategory, ColorScheme colorScheme) {
    final spent = spentByCategory[budget.categoryId] ?? 0.0;
    final ratio = budget.limitAmount > 0
        ? (spent / budget.limitAmount).clamp(0.0, 1.0)
        : 0.0;
    final isWarning = ratio >= budget.alertThreshold;
    final icon = _categoryIcons[budget.categoryId] ?? Icons.attach_money;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isWarning ? Colors.orange.withValues(alpha: 0.5) : colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // â”€â”€ Top row: icon + text + warning chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.categoryId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      '\$${spent.toStringAsFixed(0)} of \$${budget.limitAmount.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
              if (isWarning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE9D5),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text('Near limit',
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF7A3A10),
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          // â”€â”€ Progress bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation(
                  isWarning ? Colors.orange : colorScheme.primary),
            ),
          ),
          // â”€â”€ Action buttons row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddTransactionSheet(isIncome: false, initialCategory: budget.categoryId),
                  );
                },
                icon: Icon(Icons.add, size: 14, color: colorScheme.primary),
                label: Text('Add', style: TextStyle(fontSize: 12, color: colorScheme.primary)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 4),
              TextButton.icon(
                onPressed: () => _showCreateDialog(context, existing: budget),
                icon: Icon(Icons.edit_outlined, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                label: Text('Edit', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5))),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 4),
              TextButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      icon: const Icon(Icons.delete_outline, size: 40, color: Colors.red),
                      title: const Text('Delete Budget?', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: Text('Remove the "${budget.categoryId}" budget? This cannot be undone.', textAlign: TextAlign.center),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    Provider.of<BudgetProvider>(context, listen: false).deleteBudget(budget.budgetId);
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 14, color: Colors.red),
                label: const Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, {BudgetModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BudgetEditSheet(existing: existing),
    );
  }

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month];
  }
}

// â”€â”€â”€ Create / Edit Sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _BudgetEditSheet extends StatefulWidget {
  final BudgetModel? existing;
  const _BudgetEditSheet({this.existing});

  @override
  State<_BudgetEditSheet> createState() => _BudgetEditSheetState();
}

class _BudgetEditSheetState extends State<_BudgetEditSheet> {
  final _ctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _cat = 'Food';
  String _customCat = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _cat = widget.existing!.categoryId;
      if (!['Food', 'Transport', 'Education', 'Entertainment', 'Health', 'Shopping'].contains(_cat)) {
        _customCat = _cat;
        _cat = 'Other';
      }
      _ctrl.text = widget.existing!.limitAmount.toStringAsFixed(0);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final effectiveCat = _cat == 'Other' ? _customCat.trim() : _cat;
      final budget = BudgetModel(
        budgetId: widget.existing?.budgetId ?? const Uuid().v4(),
        userId: userId,
        month: month,
        categoryId: effectiveCat,
        limitAmount: double.parse(_ctrl.text),
        alertThreshold: 0.8,
        createdAt: widget.existing?.createdAt ?? DateTime.now(),
      );
      await Provider.of<BudgetProvider>(context, listen: false)
          .addOrUpdateBudget(budget);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Theme.of(context).colorScheme.error));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: colorScheme.outline,
                        borderRadius: BorderRadius.circular(99)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(widget.existing != null ? 'Edit Budget' : 'Create Budget',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 20),
                const Text('Category',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _cat,
                  dropdownColor: theme.scaffoldBackgroundColor,
                  decoration: const InputDecoration(),
                  items: ['Food', 'Transport', 'Education', 'Entertainment', 'Health', 'Shopping', 'Other']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _cat = v!;
                  }),
                ),
                if (_cat == 'Other') ...[
                  const SizedBox(height: 16),
                  const Text('Custom Category Name',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: _customCat,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (v) => _customCat = v,
                    validator: (v) {
                      if (_cat == 'Other' && (v == null || v.trim().isEmpty)) {
                        return 'Enter a category name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'e.g. Subscriptions',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Text('Monthly limit',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _ctrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(prefixText: '\$  '),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a limit';
                    if (double.tryParse(v) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? () {} : _save,
                    child: _isSaving
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: theme.scaffoldBackgroundColor))
                        : Text(widget.existing != null ? 'Save changes' : 'Create budget'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

