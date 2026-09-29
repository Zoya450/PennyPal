import 'dart:async';
import 'package:flutter/material.dart';
import 'package:penny_pal/models/savings_goal_model.dart';
import 'package:penny_pal/services/database_service.dart';

class SavingsProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  StreamSubscription? _subscription;

  List<SavingsGoalModel> _goals = [];
  bool _isLoading = false;
  String? _lastUserId;

  List<SavingsGoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  void initialize(String? userId) {
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    _subscription?.cancel();
    if (userId == null) {
      _goals = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _subscription = _dbService.getSavingsGoals(userId).listen((data) {
      _goals = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error loading savings goals: $error');
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addGoal(SavingsGoalModel goal) async {
    await _dbService.addSavingsGoal(goal);
  }

  Future<void> updateGoal(SavingsGoalModel goal) async {
    await _dbService.updateSavingsGoal(goal);
  }

  Future<void> deleteGoal(String goalId) async {
    await _dbService.deleteSavingsGoal(goalId);
  }

  Future<void> addContribution(String goalId, double amount) async {
    await _dbService.updateSavingsGoalProgress(goalId, amount);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
