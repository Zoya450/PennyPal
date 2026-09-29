class SavingsGoalModel {
  final String goalId;
  final String userId;
  final String goalName;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final double monthlyContribution;
  final String status; // 'Active', 'Completed'

  SavingsGoalModel({
    required this.goalId,
    required this.userId,
    required this.goalName,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.monthlyContribution,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'goalName': goalName,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'monthlyContribution': monthlyContribution,
      'status': status,
    };
  }

  factory SavingsGoalModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SavingsGoalModel(
      goalId: documentId,
      userId: map['userId'] ?? '',
      goalName: map['goalName'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      targetDate: map['targetDate'] != null ? DateTime.parse(map['targetDate']) : DateTime.now(),
      monthlyContribution: (map['monthlyContribution'] ?? 0).toDouble(),
      status: map['status'] ?? 'Active',
    );
  }
}
