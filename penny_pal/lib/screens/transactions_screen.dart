import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/core/theme.dart';
import 'package:penny_pal/widgets/add_transaction_sheet.dart';
import 'package:penny_pal/providers/transaction_provider.dart';
import 'package:penny_pal/models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final _filters = ['All', 'Income', 'Expense', 'Food', 'Transport', 'Education'];

  IconData _iconForCategory(String cat) {
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  List<TransactionModel> _applyFilters(List<TransactionModel> transactions) {
    return transactions.where((tx) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          tx.description.toLowerCase().contains(q) ||
          tx.categoryId.toLowerCase().contains(q);
      final matchesFilter = _selectedFilter == 'All' ||
          tx.type == _selectedFilter ||
          tx.categoryId == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _editTransaction(BuildContext context, TransactionModel tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(isIncome: tx.type == 'Income', existing: tx),
    );
  }

  Future<void> _deleteTransaction(BuildContext context, TransactionModel tx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.delete_outline, size: 40, color: Colors.red),
        title: const Text('Delete Transaction', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Remove "${tx.description.isEmpty ? tx.categoryId : tx.description}"? This cannot be undone.', textAlign: TextAlign.center),
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
      await Provider.of<TransactionProvider>(context, listen: false).deleteTransaction(tx.transactionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final txProvider = Provider.of<TransactionProvider>(context);
    final filtered = _applyFilters(txProvider.transactions);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transactions',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const AddTransactionSheet(isIncome: false),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final active = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // List
              Expanded(
                child: txProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: filtered.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.receipt_long_outlined,
                                        size: 48, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                                    const SizedBox(height: 12),
                                    Text(
                                      txProvider.transactions.isEmpty
                                          ? 'No transactions yet.\nAdd your first one!'
                                          : 'No transactions match your search.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (context, index) =>
                                    Divider(color: colorScheme.outline.withValues(alpha: 0.5), height: 1, indent: 16, endIndent: 16),
                                itemBuilder: (context, i) {
                                  final tx = filtered[i];
                                  final isIncome = tx.type == 'Income';
                                  final penny = Theme.of(context).extension<PennyColors>();
                                  final incomeColor = penny?.incomeMint ?? Colors.green;
                                  final errorColor = penny?.errorRed ?? colorScheme.error;
                                  
                                  return Dismissible(
                                    key: Key(tx.transactionId),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        color: errorColor.withValues(alpha: 0.85),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      child: const Icon(Icons.delete_outline, color: Colors.white),
                                    ),
                                    confirmDismiss: (_) => _confirmDelete(context),
                                    onDismissed: (_) => Provider.of<TransactionProvider>(context, listen: false)
                                        .deleteTransaction(tx.transactionId),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      leading: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isIncome
                                              ? incomeColor.withValues(alpha: 0.12)
                                              : colorScheme.outline.withValues(alpha: 0.18),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(_iconForCategory(tx.categoryId), size: 20,
                                            color: isIncome ? incomeColor : colorScheme.onSurface),
                                      ),
                                      title: Text(
                                        tx.description.isEmpty ? tx.categoryId : tx.description,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        '${tx.categoryId} · ${_formatDate(tx.date)}',
                                        style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                          '${isIncome ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isIncome ? incomeColor : errorColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          PopupMenuButton<String>(
                                            icon: Icon(Icons.more_vert, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                                            onSelected: (val) {
                                              if (val == 'edit') _editTransaction(context, tx);
                                              if (val == 'delete') _deleteTransaction(context, tx);
                                            },
                                            itemBuilder: (_) => [
                                              const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Edit')])),
                                              PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 16, color: errorColor), const SizedBox(width: 8), Text('Delete', style: TextStyle(color: errorColor))])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This transaction will be permanently removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).extension<PennyColors>()?.errorRed ?? Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
