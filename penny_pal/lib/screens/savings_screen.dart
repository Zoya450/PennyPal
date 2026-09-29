import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:penny_pal/models/savings_goal_model.dart';
import 'package:penny_pal/providers/savings_provider.dart';
import 'package:penny_pal/models/transaction_model.dart';
import 'package:penny_pal/providers/transaction_provider.dart';
import 'package:penny_pal/widgets/goal_progress.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  void _showEditGoal(BuildContext context, SavingsGoalModel goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateGoalSheet(existing: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final savingsProvider = Provider.of<SavingsProvider>(context);

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
                  Text('Savings Goals',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateGoal(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Goal'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: savingsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : savingsProvider.goals.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.savings_outlined,
                                    size: 52,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.25)),
                                const SizedBox(height: 16),
                                Text(
                                  'No goals yet.\nTap "New goal" to start saving towards something.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.5)),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: savingsProvider.goals.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (_, i) => _buildGoalCard(
                                context,
                                savingsProvider.goals[i],
                                colorScheme,
                                savingsProvider),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, SavingsGoalModel goal,
      ColorScheme colorScheme, SavingsProvider savingsProvider) {
    final progress = goal.targetAmount > 0
        ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final isComplete = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: isComplete
                ? Colors.green.withValues(alpha: 0.5)
                : colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                    isComplete ? Icons.check_circle : Icons.track_changes_outlined,
                    size: 22,
                    color: isComplete ? Colors.green : colorScheme.onSurface),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.goalName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                        'Target: ${goal.targetDate.day}/${goal.targetDate.month}/${goal.targetDate.year}',
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              if (isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text('Complete!',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GoalProgress(
              title: '',
              current: goal.currentAmount,
              target: goal.targetAmount),
          if (!isComplete) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showContributeDialog(context, goal, savingsProvider),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Savings'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  tooltip: 'More',
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  icon: Icon(Icons.more_vert, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      _showEditGoal(context, goal);
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          icon: const Icon(Icons.delete_outline, size: 40, color: Colors.red),
                          title: const Text('Delete Goal?', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('Remove "${goal.goalName}"? This cannot be undone.', textAlign: TextAlign.center),
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
                        savingsProvider.deleteGoal(goal.goalId);
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 10), Text('Edit goal')])),
                    const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 10), Text('Delete', style: TextStyle(color: Colors.red))])),
                  ],
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditGoal(context, goal),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: colorScheme.outline)),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        icon: const Icon(Icons.delete_outline, size: 40, color: Colors.red),
                        title: const Text('Delete Goal?', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('Remove "${goal.goalName}"? This cannot be undone.', textAlign: TextAlign.center),
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
                      savingsProvider.deleteGoal(goal.goalId);
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showContributeDialog(BuildContext context, SavingsGoalModel goal,
      SavingsProvider savingsProvider) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Contribute to "${goal.goalName}"'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '\$  ', hintText: '0.00'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(ctrl.text);
              if (amount != null && amount > 0) {
                await savingsProvider.addContribution(goal.goalId, amount);
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null && ctx.mounted) {
                  final txProvider = Provider.of<TransactionProvider>(ctx, listen: false);
                  final tx = TransactionModel(
                    transactionId: const Uuid().v4(),
                    userId: userId,
                    type: 'Expense',
                    amount: amount,
                    categoryId: 'Savings',
                    description: 'Contribution to ${goal.goalName}',
                    date: DateTime.now(),
                    paymentMode: 'Cash',
                    createdAt: DateTime.now(),
                  );
                  await txProvider.addTransaction(tx);
                }
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCreateGoal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateGoalSheet(),
    );
  }
}

// â”€â”€â”€ Create Goal Sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CreateGoalSheet extends StatefulWidget {
  final SavingsGoalModel? existing;
  const _CreateGoalSheet({this.existing});

  @override
  State<_CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends State<_CreateGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  DateTime _targetDate = DateTime.now().add(const Duration(days: 90));
  @override
  void initState() {
    super.initState();
    final ex = widget.existing;
    if (ex != null) {
      _nameCtrl.text = ex.goalName;
      _targetCtrl.text = ex.targetAmount.toStringAsFixed(0);
      _targetDate = ex.targetDate;
    }
  }

  bool _isSaving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() => _isSaving = true);
    try {
      final existing = widget.existing;
      final goal = SavingsGoalModel(
        goalId: existing?.goalId ?? const Uuid().v4(),
        userId: userId,
        goalName: _nameCtrl.text.trim(),
        targetAmount: double.parse(_targetCtrl.text),
        currentAmount: existing?.currentAmount ?? 0.0,
        targetDate: _targetDate,
        monthlyContribution: existing?.monthlyContribution ?? 0.0,
        status: existing?.status ?? 'Active',
      );
      final provider = Provider.of<SavingsProvider>(context, listen: false);
      if (existing != null) {
        await provider.updateGoal(goal);
      } else {
        await provider.addGoal(goal);
      }
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
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
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
                Text(widget.existing != null ? 'Edit savings goal' : 'New savings goal',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 20),
                const Text('Goal name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(hintText: 'e.g. New laptop'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a goal name' : null,
                ),
                const SizedBox(height: 16),
                const Text('Target amount',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _targetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(prefixText: '\$  '),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a target amount';
                    if (double.tryParse(v) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Target date',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _targetDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2040),
                    );
                    if (picked != null) setState(() => _targetDate = picked);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline, width: 1.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 18,
                            color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(width: 12),
                        Text(
                            '${_targetDate.day}/${_targetDate.month}/${_targetDate.year}'),
                      ],
                    ),
                  ),
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
                                strokeWidth: 2,
                                color: theme.scaffoldBackgroundColor))
                        : Text(widget.existing != null ? 'Save changes' : 'Create goal'),
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
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }
}

