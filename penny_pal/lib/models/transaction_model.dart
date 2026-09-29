class TransactionModel {
  final String transactionId;
  final String userId;
  final String type; // 'Income' or 'Expense'
  final double amount;
  final String categoryId;
  final String description;
  final DateTime date;
  final String paymentMode;
  final String? receiptImageUrl;
  final DateTime createdAt;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.date,
    required this.paymentMode,
    this.receiptImageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'amount': amount,
      'categoryId': categoryId,
      'description': description,
      'date': date.toIso8601String(),
      'paymentMode': paymentMode,
      'receiptImageUrl': receiptImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TransactionModel(
      transactionId: documentId,
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'Expense',
      amount: (map['amount'] ?? 0).toDouble(),
      categoryId: map['categoryId'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      paymentMode: map['paymentMode'] ?? 'Cash',
      receiptImageUrl: map['receiptImageUrl'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
