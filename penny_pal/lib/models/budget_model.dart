class BudgetModel {
  final String budgetId;
  final String userId;
  final String month; // e.g., '2026-09'
  final String categoryId;
  final double limitAmount;
  final double alertThreshold;
  final DateTime createdAt;

  BudgetModel({
    required this.budgetId,
    required this.userId,
    required this.month,
    required this.categoryId,
    required this.limitAmount,
    required this.alertThreshold,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'month': month,
      'categoryId': categoryId,
      'limitAmount': limitAmount,
      'alertThreshold': alertThreshold,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BudgetModel(
      budgetId: documentId,
      userId: map['userId'] ?? '',
      month: map['month'] ?? '',
      categoryId: map['categoryId'] ?? '',
      limitAmount: (map['limitAmount'] ?? 0).toDouble(),
      alertThreshold: (map['alertThreshold'] ?? 0.8).toDouble(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
