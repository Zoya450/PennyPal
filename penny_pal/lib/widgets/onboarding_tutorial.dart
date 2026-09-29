import 'package:flutter/material.dart';

class OnboardingTutorial extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingTutorial({super.key, required this.onFinish});

  @override
  State<OnboardingTutorial> createState() => _OnboardingTutorialState();
}

class _OnboardingTutorialState extends State<OnboardingTutorial> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _steps = [
    {
      'title': 'Welcome to PennyPal!',
      'description': 'Your personal student finance assistant. Let\'s quickly show you around so you can start making smarter money decisions today.',
      'icon': Icons.waving_hand_outlined,
    },
    {
      'title': 'Track Income & Expenses',
      'description': 'Use the Transactions tab to log your pocket money, part-time income, and daily spending. See exactly where every penny goes.',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Set Savings Goals',
      'description': 'Saving up for a laptop, a trip, or just a rainy day? Create goals, add money to them, and watch your progress grow.',
      'icon': Icons.track_changes_outlined,
    },
    {
      'title': 'Budget Like a Pro',
      'description': 'Create budgets per category (food, transport, fun) and get notified when you\'re close to the limit.',
      'icon': Icons.pie_chart_outline,
    },
    {
      'title': 'AI Guidance',
      'description': 'Ask PennyPal AI anything about budgeting, saving, or personal finance. It reads your dashboard and gives personalized tips.',
      'icon': Icons.smart_toy_outlined,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLastPage = _currentPage == _steps.length - 1;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onFinish,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Skip', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.45), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 8),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    final color = index.isEven ? colorScheme.primary : colorScheme.secondary;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(step['icon'] as IconData, size: 60, color: color),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          step['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            step['description'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.65),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  if (_currentPage > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: _currentPage > 0 ? 2 : 1,
                    child: FilledButton(
                      onPressed: () {
                        if (!isLastPage) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        } else {
                          widget.onFinish();
                        }
                      },
                      child: Text(isLastPage ? "Let's Go!" : 'Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
