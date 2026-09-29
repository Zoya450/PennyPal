import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:penny_pal/services/database_service.dart';

class AdminScreen extends StatefulWidget {
  final int initialTab;
  const AdminScreen({super.key, this.initialTab = 0});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  final DatabaseService _db = DatabaseService();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── USER DETAIL / EDIT DIALOG ──────────────────────────────────────────────
  void _showUserDetail(BuildContext context, Map<String, dynamic> user) {
    final colorScheme = Theme.of(context).colorScheme;
    final nameCtrl = TextEditingController(text: user['fullName'] ?? '');
    final emailCtrl = TextEditingController(text: user['email'] ?? '');
    final phoneCtrl = TextEditingController(text: user['mobileNumber'] ?? '');
    String selectedRole = user['role'] ?? 'student';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                        child: Icon(Icons.person, color: colorScheme.primary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['fullName'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('UID: ${user['id']}', style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.5)), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _fieldLabel('Full Name'),
                  _styledField(nameCtrl, 'Full Name', Icons.person_outline),
                  const SizedBox(height: 16),
                  _fieldLabel('Email'),
                  _styledField(emailCtrl, 'Email', Icons.email_outlined),
                  const SizedBox(height: 16),
                  _fieldLabel('Mobile Number'),
                  _styledField(phoneCtrl, 'Mobile Number', Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _fieldLabel('Role'),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'student', child: Text('Student')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (val) => setModalState(() => selectedRole = val!),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(colorScheme, 'Created', user['createdAt']?.toString().split('T').first ?? 'Unknown'),
                  _infoRow(colorScheme, 'Last Login', user['lastLogin']?.toString().split('T').first ?? 'Unknown'),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmDeleteUser(ctx, user),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          label: const Text('Delete', style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: () async {
                            await _db.updateUser(user['id'], {
                              'fullName': nameCtrl.text.trim(),
                              'email': emailCtrl.text.trim(),
                              'mobileNumber': phoneCtrl.text.trim(),
                              'role': selectedRole,
                            });
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User updated successfully.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save Changes'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteUser(BuildContext ctx, Map<String, dynamic> user) {
    showDialog(
      context: ctx,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete User', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Permanently delete ${user['fullName'] ?? 'this user'}? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _db.deleteUser(user['id']);
              if (dctx.mounted) Navigator.pop(dctx);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── SUPPORT DETAIL ─────────────────────────────────────────────────────────
  void _showSupportDetail(BuildContext context, Map<String, dynamic> q) {
    final colorScheme = Theme.of(context).colorScheme;
    String status = q['status'] ?? 'Open';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Text(q['subject'] ?? 'No Subject', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    _statusBadge(status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('From: ${q['userId'] ?? 'Unknown'}', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5)), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Text(q['message'] ?? 'No message', style: const TextStyle(fontSize: 15, height: 1.5)),
                ),
                const SizedBox(height: 24),
                const Text('Update Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['Open', 'In Progress', 'Resolved'].map((s) {
                    final isActive = status == s;
                    return ChoiceChip(
                      label: Text(s, style: TextStyle(fontWeight: FontWeight.w600, color: isActive ? Colors.white : colorScheme.onSurface)),
                      selected: isActive,
                      selectedColor: s == 'Resolved' ? Colors.green : s == 'In Progress' ? Colors.orange : colorScheme.primary,
                      onSelected: (_) => setModalState(() => status = s),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await _db.deleteSupportQuery(q['id']);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        label: const Text('Delete', style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await _db.updateSupportStatus(q['id'], status);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status updated.')));
                          }
                        },
                        icon: const Icon(Icons.check_outlined),
                        label: const Text('Save Status'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── HELPERS ────────────────────────────────────────────────────────────────
  Widget _fieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
  );

  Widget _styledField(TextEditingController ctrl, String hint, IconData icon) =>
      TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );

  Widget _infoRow(ColorScheme cs, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface.withValues(alpha: 0.6), fontSize: 13)),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );

  Widget _statusBadge(String status) {
    final color = status == 'Resolved' ? Colors.green : status == 'In Progress' ? Colors.orange : Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Panel', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Manage users and resolve support tickets.', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 13)),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Users'),
                      Tab(text: 'Support'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(db: _db),
                  _UsersTab(db: _db, onTap: (user) => _showUserDetail(context, user)),
                  _SupportTab(db: _db, onTap: (q) => _showSupportDetail(context, q)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── OVERVIEW / ANALYTICS TAB ───────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final DatabaseService db;
  const _OverviewTab({required this.db});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: db.getAllUsers(),
      builder: (context, usersSnap) {
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: db.getAllSupportQueries(),
          builder: (context, supportSnap) {
            final users = usersSnap.data ?? [];
            final queries = supportSnap.data ?? [];

            final totalUsers = users.length;
            final adminCount = users.where((u) => u['role'] == 'admin').length;
            final studentCount = totalUsers - adminCount;

            final openTickets = queries.where((q) => q['status'] == 'Open').length;
            final inProgressTickets = queries.where((q) => q['status'] == 'In Progress').length;
            final resolvedTickets = queries.where((q) => q['status'] == 'Resolved').length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat summary cards
                  Row(
                    children: [
                      _StatCard(label: 'Total Users', value: '$totalUsers', icon: Icons.people_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Admins', value: '$adminCount', icon: Icons.admin_panel_settings_outlined, color: Colors.orange),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Open Tickets', value: '$openTickets', icon: Icons.inbox_outlined, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // User role pie chart
                  if (totalUsers > 0) ...[
                    _SectionTitle('User Role Distribution'),
                    const SizedBox(height: 12),
                    _buildPieCard(
                      context,
                      colorScheme,
                      sections: [
                        PieChartSectionData(value: studentCount.toDouble(), title: 'Students\n$studentCount', color: colorScheme.primary, radius: 80, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        if (adminCount > 0)
                          PieChartSectionData(value: adminCount.toDouble(), title: 'Admins\n$adminCount', color: Colors.orange, radius: 80, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                      legendItems: [
                        _LegendItem('Students ($studentCount)', colorScheme.primary),
                        if (adminCount > 0) _LegendItem('Admins ($adminCount)', Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Support ticket status cards
                  if (queries.isNotEmpty) ...[
                    _SectionTitle('Support Ticket Status'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          _TicketStatItem(label: 'Open', count: openTickets, color: Colors.blue),
                          _TicketDivider(),
                          _TicketStatItem(label: 'In Progress', count: inProgressTickets, color: Colors.orange),
                          _TicketDivider(),
                          _TicketStatItem(label: 'Resolved', count: resolvedTickets, color: Colors.green),
                        ],
                      ),
                    ),
                  ],

                  if (totalUsers == 0 && queries.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Icon(Icons.analytics_outlined, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                            const SizedBox(height: 12),
                            Text('No data yet', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPieCard(BuildContext context, ColorScheme colorScheme, {required List<PieChartSectionData> sections, required List<_LegendItem> legendItems}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 3,
                centerSpaceRadius: 30,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: legendItems.map((item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(item.label, style: const TextStyle(fontSize: 12)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _LegendItem {
  final String label;
  final Color color;
  const _LegendItem(this.label, this.color);
}

class _TicketDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1, height: 40,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: Theme.of(context).colorScheme.outline,
  );
}

class _TicketStatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _TicketStatItem({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text('$count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.55))),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) =>
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
}

// ── USERS TAB ──────────────────────────────────────────────────────────────
class _UsersTab extends StatefulWidget {
  final DatabaseService db;
  final void Function(Map<String, dynamic>) onTap;
  const _UsersTab({required this.db, required this.onTap});

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  String _search = '';
  String _roleFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Search + Filter bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: _roleFilter,
                    isDense: true,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'student', child: Text('Students')),
                      DropdownMenuItem(value: 'admin', child: Text('Admins')),
                    ],
                    onChanged: (v) => setState(() => _roleFilter = v!),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: widget.db.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return const Center(child: Text('Error loading users.'));
              var users = snapshot.data ?? [];

              // Apply search
              if (_search.isNotEmpty) {
                users = users.where((u) {
                  final name = (u['fullName'] ?? '').toLowerCase();
                  final email = (u['email'] ?? '').toLowerCase();
                  return name.contains(_search) || email.contains(_search);
                }).toList();
              }
              // Apply role filter
              if (_roleFilter != 'All') {
                users = users.where((u) => u['role'] == _roleFilter).toList();
              }

              if (users.isEmpty) return const Center(child: Text('No users found.'));

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: users.length,
                itemBuilder: (_, i) {
                  final u = users[i];
                  final isAdmin = u['role'] == 'admin';
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: CircleAvatar(
                        backgroundColor: (isAdmin ? Colors.orange : colorScheme.primary).withValues(alpha: 0.15),
                        child: Icon(isAdmin ? Icons.admin_panel_settings : Icons.person, color: isAdmin ? Colors.orange : colorScheme.primary),
                      ),
                      title: Text(u['fullName'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(u['email'] ?? 'No Email', style: const TextStyle(fontSize: 13)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (isAdmin ? Colors.orange : colorScheme.primary).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isAdmin ? 'Admin' : 'Student',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isAdmin ? Colors.orange : colorScheme.primary),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => widget.onTap(u),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── SUPPORT TAB ────────────────────────────────────────────────────────────
class _SupportTab extends StatefulWidget {
  final DatabaseService db;
  final void Function(Map<String, dynamic>) onTap;
  const _SupportTab({required this.db, required this.onTap});

  @override
  State<_SupportTab> createState() => _SupportTabState();
}

class _SupportTabState extends State<_SupportTab> {
  String _search = '';
  String _statusFilter = 'All';

  Color _statusColor(String? s) {
    if (s == 'Resolved') return Colors.green;
    if (s == 'In Progress') return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Search + Filter bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search subject or message...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: _statusFilter,
                    isDense: true,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Open', child: Text('Open')),
                      DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'Resolved', child: Text('Resolved')),
                    ],
                    onChanged: (v) => setState(() => _statusFilter = v!),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: widget.db.getAllSupportQueries(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return const Center(child: Text('Error loading tickets.'));
              var queries = snapshot.data ?? [];

              if (_search.isNotEmpty) {
                queries = queries.where((q) {
                  final subject = (q['subject'] ?? '').toLowerCase();
                  final message = (q['message'] ?? '').toLowerCase();
                  return subject.contains(_search) || message.contains(_search);
                }).toList();
              }
              if (_statusFilter != 'All') {
                queries = queries.where((q) => q['status'] == _statusFilter).toList();
              }

              if (queries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      Text('No tickets found.', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: queries.length,
                itemBuilder: (_, i) {
                  final q = queries[i];
                  final status = q['status'] ?? 'Open';
                  final statusColor = _statusColor(status);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => widget.onTap(q),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(q['subject'] ?? 'No Subject', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              q['message'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.7), height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.person_outline, size: 13, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(q['userId'] ?? 'Unknown', style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.4)), overflow: TextOverflow.ellipsis),
                                ),
                                const Icon(Icons.chevron_right, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
