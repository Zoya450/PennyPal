import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const _systemPrompt = '''
You are PennyPal AI, a friendly and encouraging financial literacy assistant for young people and students.

Your role:
- Provide clear, educational guidance about personal finance topics
- Help users understand budgeting, saving, spending wisely, and setting financial goals
- Use simple, everyday language — never use jargon without explaining it
- Keep responses concise: 2–4 sentences for simple questions, slightly longer only when truly needed
- Be warm, supportive, and non-judgmental
- Always clarify you offer educational guidance, not professional financial advice

You must NOT:
- Recommend specific stocks, funds, or financial products
- Give specific tax or legal advice
- Make promises about financial outcomes
''';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 400,
      ),
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message, {Map<String, dynamic>? context}) async {
    try {
      final promptContext = context != null
          ? "User's current financial context: ${context.toString()}\n\n"
          : "";
      final fullPrompt = "$promptContext Question: $message";
      
      final response = await _chat.sendMessage(Content.text(fullPrompt));
      return response.text ?? _getSimulatedResponse(message, context);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 600)); // simulate network delay
      return _getSimulatedResponse(message, context);
    }
  }

  String _getSimulatedResponse(String message, Map<String, dynamic>? context) {
    final lowerMsg = message.toLowerCase();
    
    // Check for context-aware questions
    if (context != null) {
      if (lowerMsg.contains('how much') && (lowerMsg.contains('left') || lowerMsg.contains('balance') || lowerMsg.contains('money'))) {
        final balance = context['balance'] ?? 0;
        return "Based on your current dashboard, you have a total balance of \$${balance.toStringAsFixed(2)} left. Make sure to stick to your budget!";
      } else if (lowerMsg.contains('spend') || lowerMsg.contains('spent')) {
        final spent = context['spent'] ?? 0;
        return "You have spent \$${spent.toStringAsFixed(2)} so far this month. You can check the Transactions tab to see exactly where it went.";
      }
    }

    // Default static educational responses
    if (lowerMsg.contains('budget')) {
      return "A budget is simply a plan for your money! The easiest way to start is the 50/30/20 rule: 50% for needs (rent, groceries), 30% for wants (entertainment, dining out), and 20% for savings or paying off debt.";
    } else if (lowerMsg.contains('save') || lowerMsg.contains('saving')) {
      return "To save money effectively as a student, try to automate your savings! Even setting aside just \$10 a week into a separate account builds a strong habit. Also, take advantage of student discounts wherever you can.";
    } else if (lowerMsg.contains('food') || lowerMsg.contains('groceries')) {
      return "Food costs can drain your budget quickly! Try planning your meals on Sundays before you grocery shop, and strictly stick to your list. Cooking in bulk and freezing leftovers is a huge money-saver.";
    } else if (lowerMsg.contains('emergency')) {
      return "An emergency fund is money set aside specifically for unexpected expenses, like a car repair or medical bill. A good goal is to save up 3 to 6 months' worth of living expenses in a highly accessible savings account.";
    } else if (lowerMsg.contains('needs vs wants')) {
      return "Needs are essentials for survival and work—like housing, basic groceries, utilities, and transportation. Wants are everything else: eating out, designer clothes, and subscription services. Always cover your needs first!";
    } else {
      return "That's a great question! Managing money takes practice. I recommend tracking your spending in the PennyPal Dashboard for a week to see where your money is actually going. Small changes add up over time!";
    }
  }
}
