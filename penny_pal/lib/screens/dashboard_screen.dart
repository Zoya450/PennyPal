import 'package:flutter/material.dart';
import 'package:penny_pal/main.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/providers/auth_provider.dart';
import 'package:penny_pal/screens/dashboard_content.dart';
import 'package:penny_pal/screens/transactions_screen.dart';
import 'package:penny_pal/screens/budgets_screen.dart';
import 'package:penny_pal/screens/savings_screen.dart';
import 'package:penny_pal/screens/reports_screen.dart';
import 'package:penny_pal/screens/ai_screen.dart';
import 'package:penny_pal/screens/learning_screen.dart';
import 'package:penny_pal/screens/support_screen.dart';
import 'package:penny_pal/screens/admin_screen.dart';
import 'package:penny_pal/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static DashboardScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<DashboardScreenState>()!;

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void switchTab(int index) {
    setState(() => _selectedIndex = index);
  }

  // â”€â”€ STUDENT NAV â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const List<_NavItem> _studentNav = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
    _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Transactions'),
    _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Budgets'),
    _NavItem(icon: Icons.track_changes_outlined, activeIcon: Icons.track_changes, label: 'Savings Goals'),
    _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Reports'),
    _NavItem(icon: Icons.smart_toy_outlined, activeIcon: Icons.smart_toy, label: 'AI Guidance'),
    _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Learning Hub'),
    _NavItem(icon: Icons.help_outline, activeIcon: Icons.help, label: 'Support'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  static const List<Widget> _studentPages = [
    DashboardContent(),
    TransactionsScreen(),
    BudgetsScreen(),
    SavingsScreen(),
    ReportsScreen(),
    AiScreen(),
    LearningScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];

  // â”€â”€ ADMIN NAV â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const List<_NavItem> _adminNav = [
    _NavItem(icon: Icons.analytics_outlined, activeIcon: Icons.analytics, label: 'Overview'),
    _NavItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Users'),
    _NavItem(icon: Icons.support_agent_outlined, activeIcon: Icons.support_agent, label: 'Support'),
  ];

  static const List<Widget> _adminPages = [
    _AdminOverviewTab(),
    _AdminUsersTab(),
    _AdminSupportTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = PennyPalApp.of(context).isDarkMode;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 800;

    final authProvider = Provider.of<AuthProvider>(context);
    final isRoleAdmin = authProvider.currentUserData?.role == 'admin';
    final isEmailAdmin = authProvider.currentUserData?.email.toLowerCase() == 'admin@pennypal.com';
    final isAdmin = isRoleAdmin || isEmailAdmin;

    final navItems = isAdmin ? _adminNav : _studentNav;
    final pages = isAdmin ? _adminPages : _studentPages;

    // keep index in bounds when switching accounts
    if (_selectedIndex >= pages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _selectedIndex = 0));
    }
    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    if (isAdmin) {
      return _buildAdminShell(theme, colorScheme, isDark, isDesktop, navItems, pages, safeIndex);
    }
    return _buildStudentShell(theme, colorScheme, isDark, isDesktop, navItems, pages, safeIndex);
  }

  // â”€â”€ ADMIN SHELL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildAdminShell(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    bool isDesktop,
    List<_NavItem> navItems,
    List<Widget> pages,
    int safeIndex,
  ) {
    final adminName = Provider.of<AuthProvider>(context, listen: false).currentUserData?.fullName ?? 'Admin';

    Widget body;
    if (isDesktop) {
      body = Row(
        children: [
          _buildAdminSidebar(theme, colorScheme, isDark, navItems, safeIndex, adminName),
          Expanded(child: _AdminPageWrapper(child: pages[safeIndex])),
        ],
      );
    } else {
      body = _AdminPageWrapper(child: pages[safeIndex]);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: colorScheme.surface,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.admin_panel_settings, color: theme.scaffoldBackgroundColor, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: colorScheme.onSurface)),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: colorScheme.onSurface),
                  onPressed: () => PennyPalApp.of(context).toggleTheme(),
                ),
                IconButton(
                  icon: Icon(Icons.logout_outlined, color: colorScheme.onSurface),
                  onPressed: _logout,
                ),
              ],
            ),
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outline, width: 1)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(navItems.length, (i) {
                      final isActive = safeIndex == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = i),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isActive ? navItems[i].activeIcon : navItems[i].icon,
                              size: 24,
                              color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              navItems[i].label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                                color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
      body: body,
    );
  }

  Widget _buildAdminSidebar(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    List<_NavItem> navItems,
    int safeIndex,
    String adminName,
  ) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outline, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.admin_panel_settings, color: theme.scaffoldBackgroundColor, size: 20),
                ),
                const SizedBox(width: 10),
                Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: colorScheme.onSurface)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Logged in as $adminName', style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.45))),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('MANAGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: colorScheme.onSurface.withValues(alpha: 0.4))),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isActive = safeIndex == index;
                return _buildSidebarItem(item, index, isActive, colorScheme, theme);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: colorScheme.onSurface.withValues(alpha: 0.7), size: 22),
                  title: Text(isDark ? 'Light mode' : 'Dark mode', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14)),
                  onTap: () => PennyPalApp.of(context).toggleTheme(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Icon(Icons.logout_outlined, color: colorScheme.onSurface.withValues(alpha: 0.7), size: 22),
                  title: Text('Log out', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14)),
                  onTap: _logout,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // â”€â”€ STUDENT SHELL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildStudentShell(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    bool isDesktop,
    List<_NavItem> navItems,
    List<Widget> pages,
    int safeIndex,
  ) {
    // Mobile bottom nav shows 4 core items
    final bottomItems = [navItems[0], navItems[1], navItems[2], navItems[3]];
    final bottomIndices = [0, 1, 2, 3];

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktop
          ? null
          : Drawer(child: _buildStudentSidebar(theme, colorScheme, isDark, navItems, safeIndex)),
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: colorScheme.surface,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.menu, color: colorScheme.onSurface),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
              title: Row(
                children: [
                  Icon(Icons.monetization_on_outlined, color: colorScheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text('PennyPal', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: colorScheme.onSurface)),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.smart_toy_outlined, color: colorScheme.onSurface),
                  onPressed: () => setState(() => _selectedIndex = 5),
                ),
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: colorScheme.onSurface),
                  onPressed: () => PennyPalApp.of(context).toggleTheme(),
                ),
                IconButton(
                  icon: Icon(Icons.logout_outlined, color: colorScheme.onSurface),
                  onPressed: _logout,
                ),
              ],
            ),
      body: isDesktop
          ? Row(children: [
              _buildStudentSidebar(theme, colorScheme, isDark, navItems, safeIndex),
              Expanded(child: pages[safeIndex]),
            ])
          : pages[safeIndex],
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outline, width: 1)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(bottomItems.length, (i) {
                      final isActive = safeIndex == bottomIndices[i];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = bottomIndices[i]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isActive ? bottomItems[i].activeIcon : bottomItems[i].icon,
                              size: 24,
                              color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bottomItems[i].label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                                color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStudentSidebar(ThemeData theme, ColorScheme colorScheme, bool isDark, List<_NavItem> navItems, int safeIndex) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outline, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.monetization_on_outlined, color: theme.scaffoldBackgroundColor, size: 20),
                ),
                const SizedBox(width: 10),
                Text('PennyPal', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: colorScheme.onSurface)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isActive = safeIndex == index;
                return _buildSidebarItem(item, index, isActive, colorScheme, theme);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: colorScheme.onSurface.withValues(alpha: 0.7), size: 22),
                  title: Text(isDark ? 'Light mode' : 'Dark mode', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14)),
                  onTap: () => PennyPalApp.of(context).toggleTheme(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Icon(Icons.logout_outlined, color: colorScheme.onSurface.withValues(alpha: 0.7), size: 22),
                  title: Text('Log out', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14)),
                  onTap: _logout,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(_NavItem item, int index, bool isActive, ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _selectedIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: isActive ? colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 22,
                  color: isActive ? theme.scaffoldBackgroundColor : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive ? theme.scaffoldBackgroundColor : colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    await Provider.of<AuthProvider>(context, listen: false).logout();
    navigator.pushNamedAndRemoveUntil('/', (route) => false);
  }
}

// â”€â”€ ADMIN PAGE WRAPPER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AdminPageWrapper extends StatelessWidget {
  final Widget child;
  const _AdminPageWrapper({required this.child});

  @override
  Widget build(BuildContext context) => child;
}

// â”€â”€ ADMIN TABS (split out from AdminScreen for direct use) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AdminOverviewTab extends StatelessWidget {
  const _AdminOverviewTab();
  @override
  Widget build(BuildContext context) => const AdminScreen(initialTab: 0);
}

class _AdminUsersTab extends StatelessWidget {
  const _AdminUsersTab();
  @override
  Widget build(BuildContext context) => const AdminScreen(initialTab: 1);
}

class _AdminSupportTab extends StatelessWidget {
  const _AdminSupportTab();
  @override
  Widget build(BuildContext context) => const AdminScreen(initialTab: 2);
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}

