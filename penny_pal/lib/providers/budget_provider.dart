import 'dart:async';
import 'package:flutter/material.dart';
import 'package:penny_pal/models/budget_model.dart';
import 'package:penny_pal/services/database_service.dart';

class BudgetProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  StreamSubscription? _subscription;

  List<BudgetModel> _budgets = [];
  bool _isLoading = false;
  String? _lastUserId;

  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;

  void initialize(String? userId) {
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    _subscription?.cancel();
    if (userId == null) {
      _budgets = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final now = DateTime.now();
    final monthStr = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    _subscription = _dbService.getBudgets(userId, monthStr).listen((data) {
      _budgets = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error loading budgets: $error');
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addOrUpdateBudget(BudgetModel budget) async {
    await _dbService.addOrUpdateBudget(budget);
  }

  Future<void> deleteBudget(String budgetId) async {
    await _dbService.deleteBudget(budgetId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
