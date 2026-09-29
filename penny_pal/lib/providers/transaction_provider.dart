import 'dart:async';
import 'package:flutter/material.dart';
import 'package:penny_pal/models/transaction_model.dart';
import 'package:penny_pal/services/database_service.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  StreamSubscription? _subscription;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _lastUserId;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == 'Income')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == 'Expense')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get availableBalance => totalIncome - totalExpense;

  void initialize(String? userId) {
    // Skip re-initialization if userId hasn't changed
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    _subscription?.cancel();
    if (userId == null) {
      _transactions = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _subscription = _dbService.getTransactions(userId).listen((data) {
      _transactions = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error loading transactions: $error');
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await _dbService.addTransaction(tx);
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await _dbService.updateTransaction(tx);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _dbService.deleteTransaction(transactionId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
