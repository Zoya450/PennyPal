import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: Text('Legal & Policies', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection(
            context,
            'Privacy Policy',
            'Your privacy is important to us. PennyPal collects your email address and financial data solely for the purpose of providing the budgeting and tracking services. We do not sell your personal data to third parties. All data is encrypted and securely stored using Google Firebase.',
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Terms and Conditions',
            'By using PennyPal, you agree to use the app for educational and personal finance tracking purposes only. The AI guidance provided is for educational purposes and does not constitute professional financial advice. PennyPal is not liable for any financial losses or decisions made based on the app\'s data.',
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Refund Policy',
            'PennyPal is a free-to-use application for educational purposes. We do not currently offer paid subscriptions or in-app purchases. If future premium features are added, refunds will be evaluated on a case-by-case basis within 14 days of purchase.',
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Cookie Policy',
            'We use strictly necessary cookies and local storage mechanisms to keep you logged in and to store your theme preferences (Dark/Light mode). We do not use third-party tracking cookies for advertising.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withValues(alpha: 0.75), height: 1.5),
        ),
      ],
    );
  }
}
