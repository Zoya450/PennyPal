import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penny_pal/models/transaction_model.dart';
import 'package:penny_pal/models/budget_model.dart';
import 'package:penny_pal/models/savings_goal_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- TRANSACTIONS ---
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _db
        .collection('Transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final txs = snapshot.docs
              .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
              .toList();
          // Sort client-side to avoid requiring a Firestore composite index
          txs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return txs;
        });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _db
        .collection('Transactions')
        .doc(transaction.transactionId)
        .set(transaction.toMap());
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _db
        .collection('Transactions')
        .doc(transaction.transactionId)
        .update(transaction.toMap());
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _db.collection('Transactions').doc(transactionId).delete();
  }

  // --- BUDGETS ---
  Stream<List<BudgetModel>> getBudgets(String userId, String month) {
    return _db
        .collection('Budgets')
        .where('userId', isEqualTo: userId)
        .where('month', isEqualTo: month)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addOrUpdateBudget(BudgetModel budget) async {
    await _db.collection('Budgets').doc(budget.budgetId).set(budget.toMap());
  }

  Future<void> deleteBudget(String budgetId) async {
    await _db.collection('Budgets').doc(budgetId).delete();
  }

  // --- SAVINGS GOALS ---
  Stream<List<SavingsGoalModel>> getSavingsGoals(String userId) {
    return _db
        .collection('SavingsGoals')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SavingsGoalModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addSavingsGoal(SavingsGoalModel goal) async {
    await _db.collection('SavingsGoals').doc(goal.goalId).set(goal.toMap());
  }

  Future<void> updateSavingsGoal(SavingsGoalModel goal) async {
    await _db.collection('SavingsGoals').doc(goal.goalId).update(goal.toMap());
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    await _db.collection('SavingsGoals').doc(goalId).delete();
  }

  Future<void> updateSavingsGoalProgress(String goalId, double amountToAdd) async {
    await _db.collection('SavingsGoals').doc(goalId).update({
      'currentAmount': FieldValue.increment(amountToAdd),
    });
  }

  // --- AI CHAT HISTORY ---
  Stream<List<Map<String, dynamic>>> getChatHistory(String userId) {
    return _db
        .collection('AIChats')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs.map((doc) => doc.data()).toList();
          docs.sort((a, b) => (a['timestamp'] as String).compareTo(b['timestamp'] as String));
          return docs;
        });
  }

  Future<void> saveChatMessage(String userId, String text, bool isBot, bool isError) async {
    await _db.collection('AIChats').add({
      'userId': userId,
      'text': text,
      'isBot': isBot,
      'isError': isError,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // --- SUPPORT QUERIES ---
  Future<void> submitSupportQuery(String userId, String subject, String message) async {
    await _db.collection('SupportQueries').add({
      'userId': userId,
      'subject': subject,
      'message': message,
      'status': 'Open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getUserSupportQueries(String userId) {
    return _db
        .collection('SupportQueries')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
          // Sort client-side by status or created time (since Firestore needs an index to sort on different fields)
          return docs;
        });
  }

  // --- ADMIN ---
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _db.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('Users').doc(userId).update(data);
  }

  Future<void> deleteUser(String userId) async {
    await _db.collection('Users').doc(userId).delete();
  }

  Stream<List<Map<String, dynamic>>> getAllSupportQueries() {
    return _db.collection('SupportQueries').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  Future<void> updateSupportStatus(String queryId, String status) async {
    await _db.collection('SupportQueries').doc(queryId).update({'status': status});
  }

  Future<void> deleteSupportQuery(String queryId) async {
    await _db.collection('SupportQueries').doc(queryId).delete();
  }

  Future<void> markTutorialAsSeen(String userId) async {
    await _db.collection('Users').doc(userId).update({'hasSeenTutorial': true});
  }
}
