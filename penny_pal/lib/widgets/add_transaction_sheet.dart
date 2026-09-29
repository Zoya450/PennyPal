import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:penny_pal/models/transaction_model.dart';
import 'package:penny_pal/providers/transaction_provider.dart';

class AddTransactionSheet extends StatefulWidget {
  final bool isIncome;
  final TransactionModel? existing;
  final String? initialCategory;
  const AddTransactionSheet({super.key, required this.isIncome, this.existing, this.initialCategory});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  late bool _isIncome;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  final _customCategoryController = TextEditingController();

  final _categories = ['Food', 'Transport', 'Education', 'Entertainment', 'Health', 'Shopping', 'Other'];
  final _incomeCategories = ['Part-time job', 'Allowance', 'Freelance', 'Other'];

  @override
  void initState() {
    super.initState();
    final ex = widget.existing;
    if (ex != null) {
      _isIncome = ex.type == 'Income';
      _selectedCategory = ex.categoryId;
      if (!_categories.contains(_selectedCategory) && !_incomeCategories.contains(_selectedCategory)) {
        _customCategoryController.text = _selectedCategory;
        _selectedCategory = 'Other';
      }
      _amountController.text = ex.amount.toStringAsFixed(2);
      _noteController.text = ex.description;
      _selectedDate = ex.date;
    } else {
      _isIncome = widget.isIncome;
      if (widget.initialCategory != null) {
        _selectedCategory = widget.initialCategory!;
        if (!_categories.contains(_selectedCategory) && !_incomeCategories.contains(_selectedCategory)) {
          _customCategoryController.text = _selectedCategory;
          _selectedCategory = 'Other';
        }
      } else {
        _selectedCategory = widget.isIncome ? 'Part-time job' : 'Food';
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() => _isSaving = true);
    try {
      final effectiveCategory = _selectedCategory == 'Other'
          ? (_customCategoryController.text.trim().isEmpty ? 'Other' : _customCategoryController.text.trim())
          : _selectedCategory;

      final existing = widget.existing;
      final tx = TransactionModel(
        transactionId: existing?.transactionId ?? const Uuid().v4(),
        userId: userId,
        type: _isIncome ? 'Income' : 'Expense',
        amount: double.parse(_amountController.text),
        categoryId: effectiveCategory,
        description: _noteController.text.trim(),
        date: _selectedDate,
        paymentMode: 'Cash',
        createdAt: existing?.createdAt ?? DateTime.now(),
      );
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      if (existing != null) {
        await provider.updateTransaction(tx);
      } else {
        await provider.addTransaction(tx);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = _isIncome ? _incomeCategories : _categories;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final hPad = screenWidth < 360 ? 14.0 : 24.0;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(hPad, 20, hPad, hPad),
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
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Toggle Income/Expense
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Expanded(child: _toggleBtn('Income', isSelected: _isIncome, onTap: () {
                      setState(() { _isIncome = true; _selectedCategory = 'Part-time job'; });
                    }, colorScheme: colorScheme, theme: theme)),
                    Expanded(child: _toggleBtn('Expense', isSelected: !_isIncome, onTap: () {
                      setState(() { _isIncome = false; _selectedCategory = 'Food'; });
                    }, colorScheme: colorScheme, theme: theme)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Amount
              const Text('Amount', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
                decoration: const InputDecoration(prefixText: '\$  ', hintText: '0.00'),
              ),
              const SizedBox(height: 16),
              // Category
              const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                dropdownColor: theme.scaffoldBackgroundColor,
                decoration: const InputDecoration(),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() {
                  _selectedCategory = v!;
                  if (v != 'Other') _customCategoryController.clear();
                }),
              ),
              // Custom category field when 'Other' is selected
              if (_selectedCategory == 'Other') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customCategoryController,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (_selectedCategory == 'Other' && (v == null || v.trim().isEmpty)) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'e.g. Rent, Subscriptionsâ€¦',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Date
              const Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline, width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 18,
                          color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Note
              const Text('Note (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(hintText: 'e.g. Campus lunch'),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? () {} : _submit,
                  child: _isSaving
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: theme.scaffoldBackgroundColor),
                        )
                      : Text(widget.existing != null
                            ? (_isIncome ? 'Save Income' : 'Save Expense')
                            : (_isIncome ? 'Add Income' : 'Add Expense')),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _toggleBtn(String label, {required bool isSelected, required VoidCallback onTap, required ColorScheme colorScheme, required ThemeData theme}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? theme.scaffoldBackgroundColor : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }
}

