import 'package:flutter/material.dart';
import 'package:penny_pal/main.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();

  void _scrollToFeatures() {
    final context = _featuresKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = PennyPalApp.of(context).isDarkMode;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.monetization_on_outlined,
                color: theme.scaffoldBackgroundColor,
                size: 20,
              ),
            ),
            // Logo only, text removed per user request
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: colorScheme.onSurface),
            onPressed: () => PennyPalApp.of(context).toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          if (screenWidth > 350)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.onSurface),
              child: const Text('Log in', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          if (screenWidth > 300)
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 4.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: theme.scaffoldBackgroundColor,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text('Get started'),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Hero Section
                  isDesktop 
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 11, child: _buildHeroLeft(context, textTheme, colorScheme)),
                          const SizedBox(width: 48),
                          Expanded(flex: 10, child: const _MockupCard()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroLeft(context, textTheme, colorScheme),
                          const SizedBox(height: 48),
                          const _MockupCard(),
                        ],
                      ),

                  const SizedBox(height: 64),

                  // Features Section
                  // Features Section
                  Text(
                    key: _featuresKey,
                    'Everything you need to\nmanage money',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Simple tools for students starting their financial journey.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 32),
                  
                  isDesktop
                    ? GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: _buildFeatureCards(),
                      )
                    : Column(
                        children: _buildFeatureCards().map((card) => Padding(padding: const EdgeInsets.only(bottom: 16), child: card)).toList(),
                      ),

                  const SizedBox(height: 64),

                  // Steps Section
                  Text(
                    'Up and running in three\nsteps',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No bank connection needed.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 32),
                  isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildStepCards().map((card) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: card))).toList(),
                      )
                    : Column(
                        children: _buildStepCards().map((card) => Padding(padding: const EdgeInsets.only(bottom: 16), child: card)).toList(),
                      ),
                  
                  const SizedBox(height: 64),

                  // CTA Band
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: isDark 
                          ? const LinearGradient(colors: [Color(0xFF101A4D), Color(0xFF0B1135)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                          : null,
                      color: isDark ? null : colorScheme.surface,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: colorScheme.outline, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ready to take control of\nyour money?',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Join PennyPal and build habits that last.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Create free account'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  Text(
                    'Â© PennyPal Â· Educational tool only. Not a bank, wallet, payment service or financial advisor.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroLeft(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_upward, size: 16, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                'Fresh all along Â· Built for students',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Make every penny count,\nfrom day one.',
          style: textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.1,
            letterSpacing: -1.0,
            fontSize: 42,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Track expenses, set budgets and reach savings goals with a friendly guide that teaches you money skills as you go.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Start free'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: _scrollToFeatures,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.outline, width: 1.5),
              ),
              child: const Text('See features'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: const [
            _TrustPoint(icon: Icons.shield_outlined, text: 'Encrypted & private'),
            _TrustPoint(icon: Icons.sync_outlined, text: 'Works offline'),
            _TrustPoint(icon: Icons.phone_android_outlined, text: 'Phone, tablet & web'),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildFeatureCards() {
    return const [
      _FeatureCard(
        icon: Icons.receipt_long_outlined,
        title: 'Expense tracking',
        description: 'Log income and spending in seconds, with smart categories and receipt photos.',
      ),
      _FeatureCard(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Monthly budgets',
        description: 'Set limits per category and see what is left at a glance.',
      ),
      _FeatureCard(
        icon: Icons.track_changes_outlined,
        title: 'Savings goals',
        description: 'Save for a laptop or a trip with progress bars and milestones.',
      ),
      _FeatureCard(
        icon: Icons.notifications_none_outlined,
        title: 'Instant alerts',
        description: 'Get nudged before you overspend, not after.',
      ),
      _FeatureCard(
        icon: Icons.smart_toy_outlined,
        title: 'AI guidance',
        description: 'Ask budgeting questions and get clear, educational answers.',
      ),
      _FeatureCard(
        icon: Icons.menu_book_outlined,
        title: 'Learning hub',
        description: 'Short lessons on budgeting, saving and needs vs wants.',
      ),
    ];
  }

  List<Widget> _buildStepCards() {
    return const [
      _StepCard(number: '1', title: 'Create your account', description: 'Sign up with your email in under a minute.'),
      _StepCard(number: '2', title: 'Set a budget', description: 'Choose a monthly amount and category limits.'),
      _StepCard(number: '3', title: 'Track and learn', description: 'Log spending, watch progress and grow your skills.'),
    ];
  }
}

class _TrustPoint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _MockupCard extends StatelessWidget {
  const _MockupCard();
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = PennyPalApp.of(context).isDarkMode;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: isDark 
                ? const LinearGradient(colors: [Color(0xFF101A4D), Color(0xFF0B1135)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            color: isDark ? null : colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: colorScheme.outline, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Monthly budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Icon(Icons.notifications_none, size: 20, color: colorScheme.onSurface),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('\$1,550', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1)),
                  const SizedBox(width: 8),
                  Text(' / \$2,000', style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withValues(alpha: 0.6), height: 1.5)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _MockupRow(icon: Icons.laptop_mac, label: 'New laptop', value: '60%'),
              const SizedBox(height: 12),
              const _MockupRow(icon: Icons.fastfood_outlined, label: 'Food', value: '\$18'),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Positioned(
          bottom: -20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: theme.scaffoldBackgroundColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Food at 85% of limit',
                  style: TextStyle(color: theme.scaffoldBackgroundColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MockupRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MockupRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(color: theme.scaffoldBackgroundColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}

