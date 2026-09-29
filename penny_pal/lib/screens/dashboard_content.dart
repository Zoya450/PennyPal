import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/providers/transaction_provider.dart';
import 'package:penny_pal/providers/savings_provider.dart';
import 'package:penny_pal/widgets/stat_card.dart';
import 'package:penny_pal/widgets/spending_chart.dart';
import 'package:penny_pal/widgets/transaction_tile.dart';
import 'package:penny_pal/widgets/budget_donut.dart';
import 'package:penny_pal/widgets/goal_progress.dart';
import 'package:penny_pal/widgets/add_transaction_sheet.dart';
import 'package:penny_pal/widgets/onboarding_tutorial.dart';
import 'package:penny_pal/services/database_service.dart';
import 'package:penny_pal/providers/auth_provider.dart';
import 'package:penny_pal/screens/dashboard_screen.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
  }

  void _checkOnboarding() {
    if (!mounted) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUserData;
    
    if (user != null && !user.hasSeenTutorial && !auth.hasShownTutorialThisSession) {
      auth.markTutorialAsShownLocally();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => OnboardingTutorial(
          onFinish: () async {
            Navigator.pop(ctx);
            await DatabaseService().markTutorialAsSeen(user.userId);
            if (mounted) {
              Provider.of<AuthProvider>(context, listen: false).refreshUser();
            }
          },
        ),
      );
    }
  }

  void _showAddSheet(BuildContext context, {required bool isIncome}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(isIncome: isIncome),
    );
  }

  void _showReportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Report Period', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildReportOption(ctx, Icons.today, 'Daily Report'),
              _buildReportOption(ctx, Icons.view_week, 'Weekly Report'),
              _buildReportOption(ctx, Icons.calendar_month, 'Monthly Report'),
              _buildReportOption(ctx, Icons.calendar_today, 'Yearly Report'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportOption(BuildContext context, IconData icon, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generating $title...')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnboarding();
    });

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 1000;

    final txProvider = Provider.of<TransactionProvider>(context);
    final savingsProvider = Provider.of<SavingsProvider>(context);

    final balance = txProvider.availableBalance;
    final income = txProvider.totalIncome;
    final expenses = txProvider.totalExpense;
    final activeGoals = savingsProvider.goals.where((g) => g.status == 'Active').length;
    final totalSaved = savingsProvider.goals.fold(0.0, (sum, g) => sum + g.currentAmount);

    final recentTxs = txProvider.transactions.take(4).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: txProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back!',
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              "Here's how your money looks this month.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showAddSheet(context, isIncome: true),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Income'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colorScheme.outline),
                                foregroundColor: colorScheme.onSurface,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _showAddSheet(context, isIncome: false),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Expense'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stat cards
                    isWide
                        ? Row(
                            children: [
                              Expanded(child: StatCard(icon: Icons.account_balance_wallet_outlined, label: 'Available balance', value: '\$${balance.toStringAsFixed(2)}', subtitle: 'Live balance', isHero: true)),
                              const SizedBox(width: 16),
                              Expanded(child: StatCard(icon: Icons.arrow_upward, label: 'Income', value: '\$${income.toStringAsFixed(2)}', subtitle: 'This month')),
                              const SizedBox(width: 16),
                              Expanded(child: StatCard(icon: Icons.receipt_long_outlined, label: 'Expenses', value: '\$${expenses.toStringAsFixed(2)}', subtitle: income > 0 ? '${(expenses / income * 100).toStringAsFixed(0)}% of income' : 'This month')),
                              const SizedBox(width: 16),
                              Expanded(child: StatCard(icon: Icons.track_changes_outlined, label: 'Saved', value: '\$${totalSaved.toStringAsFixed(2)}', subtitle: '$activeGoals active goal${activeGoals != 1 ? 's' : ''}')),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: StatCard(icon: Icons.account_balance_wallet_outlined, label: 'Available balance', value: '\$${balance.toStringAsFixed(2)}', subtitle: 'Live balance', isHero: true)),
                                  const SizedBox(width: 16),
                                  Expanded(child: StatCard(icon: Icons.arrow_upward, label: 'Income', value: '\$${income.toStringAsFixed(2)}', subtitle: 'This month')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: StatCard(icon: Icons.receipt_long_outlined, label: 'Expenses', value: '\$${expenses.toStringAsFixed(2)}', subtitle: income > 0 ? '${(expenses / income * 100).toStringAsFixed(0)}% of income' : 'This month')),
                                  const SizedBox(width: 16),
                                  Expanded(child: StatCard(icon: Icons.track_changes_outlined, label: 'Saved', value: '\$${totalSaved.toStringAsFixed(2)}', subtitle: '$activeGoals active goal${activeGoals != 1 ? 's' : ''}')),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),

                    // Main two-column layout
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 16, child: _buildLeftColumn(context, recentTxs)),
                              const SizedBox(width: 18),
                              Expanded(flex: 10, child: _buildRightColumn(context)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildLeftColumn(context, recentTxs),
                              const SizedBox(height: 18),
                              _buildRightColumn(context),
                            ],
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, List<dynamic> recentTxs) {
    final colorScheme = Theme.of(context).colorScheme;
    final txProvider = Provider.of<TransactionProvider>(context, listen: false);

    IconData iconForCategory(String cat) {
      switch (cat) {
        case 'Food': return Icons.fastfood_outlined;
        case 'Transport': return Icons.directions_bus_outlined;
        case 'Education': return Icons.school_outlined;
        case 'Entertainment': return Icons.movie_outlined;
        case 'Health': return Icons.favorite_outline;
        case 'Shopping': return Icons.shopping_bag_outlined;
        case 'Part-time job': return Icons.work_outline;
        case 'Allowance': return Icons.card_giftcard_outlined;
        case 'Freelance': return Icons.laptop_outlined;
        default: return Icons.attach_money;
      }
    }

    return Column(
      children: [
        // Spending chart
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Spending trend',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                    onPressed: () => _showReportMenu(context),
                    child: Text('Full report',
                        style: TextStyle(color: colorScheme.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SpendingChart(transactions: txProvider.transactions),
            ],
          ),
        ),
        const SizedBox(height: 18),
        // Recent transactions
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent transactions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      try {
                        DashboardScreen.of(context).switchTab(1);
                      } catch (_) {}
                    },
                    child: Text('View all',
                        style: TextStyle(color: colorScheme.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              recentTxs.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('No transactions yet. Add your first one!',
                            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                      ),
                    )
                  : Column(
                      children: recentTxs.map((tx) => TransactionTile(
                        icon: iconForCategory(tx.categoryId),
                        title: tx.description.isEmpty ? tx.categoryId : tx.description,
                        subtitle: '${tx.categoryId} Â· ${_formatDate(tx.date)}',
                        amount: '${tx.type == 'Income' ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                        isPositive: tx.type == 'Income',
                      )).toList(),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}';
  }

  Widget _buildRightColumn(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final savingsProvider = Provider.of<SavingsProvider>(context);
    return Column(
      children: [
        // Budget donut
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
              const Text('Budget overview',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              const BudgetDonut(percent: 0, total: 0, label: 'No data'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        // Savings goals
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
              const Text('Savings goals',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              savingsProvider.goals.isEmpty
                  ? Text('No goals yet.',
                      style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)))
                  : Column(
                      children: savingsProvider.goals.take(3).map((goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GoalProgress(
                          title: goal.goalName,
                          current: goal.currentAmount,
                          target: goal.targetAmount,
                        ),
                      )).toList(),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

