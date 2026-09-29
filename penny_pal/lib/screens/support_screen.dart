import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/core/theme.dart';
import 'package:penny_pal/services/database_service.dart';
import 'package:penny_pal/providers/auth_provider.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _dbService = DatabaseService();

  bool _isLoading = false;
  bool _submitted = false;
  String? _errorMsg;

  // Track previous statuses to detect changes
  final Map<String, String> _prevStatuses = {};
  bool _firstLoad = true;

  Future<void> _submitForm() async {
    final subject = _subjectCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      setState(() => _errorMsg = 'Please fill out both fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).currentUserData?.userId;
      if (userId == null) throw Exception('You must be logged in to send a message.');

      await _dbService.submitSupportQuery(userId, subject, message);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _submitted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMsg = e.toString();
        });
      }
    }
  }

  void _checkForStatusChanges(List<Map<String, dynamic>> tickets) {
    if (_firstLoad) {
      // Seed initial statuses silently
      for (final t in tickets) {
        _prevStatuses[t['id']] = t['status'] ?? 'Open';
      }
      _firstLoad = false;
      return;
    }

    for (final t in tickets) {
      final id = t['id'] as String;
      final newStatus = t['status'] ?? 'Open';
      final oldStatus = _prevStatuses[id];

      if (oldStatus != null && oldStatus != newStatus) {
        // Status changed — show popup
        _prevStatuses[id] = newStatus;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showStatusPopup(t['subject'] ?? 'Your complaint', newStatus);
        });
      } else if (oldStatus == null) {
        _prevStatuses[id] = newStatus;
      }
    }
  }

  void _showStatusPopup(String subject, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    final penny = Theme.of(context).extension<PennyColors>();
    final inProgress = penny?.warningText ?? Colors.orange;
    final resolved = penny?.incomeMint ?? Colors.green;
    final open = colorScheme.secondary;

    final (icon, color, message) = switch (status) {
      'In Progress' => (Icons.pending_actions_outlined, inProgress, 'Your complaint is now being reviewed by our team.'),
      'Resolved'    => (Icons.check_circle_outlined,    resolved,   'Your complaint has been resolved. Thank you for your patience!'),
      _             => (Icons.inbox_outlined,            open,       'Your complaint has been received and is open.'),
    };

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: Icon(icon, size: 52, color: color),
        title: Text('Complaint $status', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Text('"$subject"', textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
          ],
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: color),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUserData?.userId;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Support', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("We're here to help.", style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 13)),
              const SizedBox(height: 24),

              // FAQ cards
              _faqCard(context, colorScheme, 'How do I reset my password?', 'Go to Log in → tap "Forgot password?" and follow the email link.'),
              const SizedBox(height: 12),
              _faqCard(context, colorScheme, 'Is PennyPal free?', 'Yes! PennyPal is completely free for students.'),
              const SizedBox(height: 12),
              _faqCard(context, colorScheme, 'Can I use it offline?', 'Yes, PennyPal works offline and syncs when you reconnect.'),
              const SizedBox(height: 24),

              // My tickets section — listens for status changes
              if (userId != null) ...[
                const Text('My Tickets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _dbService.getUserSupportQueries(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _checkForStatusChanges(snapshot.data!);
                    }
                    final tickets = snapshot.data ?? [];
                    if (tickets.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.inbox_outlined, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                            const SizedBox(width: 12),
                            Text('No tickets yet.', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: tickets.map((t) {
                        final status = t['status'] ?? 'Open';
                        final penny2 = Theme.of(context).extension<PennyColors>();
                        final color = status == 'Resolved'
                            ? (penny2?.incomeMint ?? Colors.green)
                            : status == 'In Progress'
                                ? (penny2?.warningText ?? Colors.orange)
                                : colorScheme.secondary;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colorScheme.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(t['subject'] ?? 'No Subject', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                                    child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(t['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.65))),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Contact form
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: _submitted
                    ? Center(
                        child: Column(
                          children: [
                            Icon(Icons.check_circle_outline, size: 48, color: colorScheme.primary),
                            const SizedBox(height: 12),
                            const Text('Message sent!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 4),
                            Text("We'll get back to you within 24h.",
                                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                _subjectCtrl.clear();
                                _messageCtrl.clear();
                                setState(() => _submitted = false);
                              },
                              child: const Text('Send another message'),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Contact us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 16),
                          if (_errorMsg != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(_errorMsg!, style: TextStyle(color: colorScheme.error, fontSize: 13)),
                            ),
                          const Text('Subject', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _subjectCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(hintText: 'e.g. Bug report'),
                            enabled: !_isLoading,
                          ),
                          const SizedBox(height: 16),
                          const Text('Message', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _messageCtrl,
                            maxLines: 4,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submitForm(),
                            decoration: const InputDecoration(hintText: 'Describe your issue or feedback…'),
                            enabled: !_isLoading,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _submitForm,
                              icon: _isLoading
                                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary))
                                  : const Icon(Icons.send, size: 18),
                              label: Text(_isLoading ? 'Sending...' : 'Send message'),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _faqCard(BuildContext context, ColorScheme colorScheme, String question, String answer) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: Text(answer, style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.7), height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }
}
