import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/services/gemini_service.dart';
import 'package:penny_pal/services/database_service.dart';
import 'package:penny_pal/providers/auth_provider.dart';
import 'package:penny_pal/providers/transaction_provider.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _gemini = GeminiService();
  final _dbService = DatabaseService();
  bool _isLoading = false;
  String? _userId;

  static const _suggestions = [
    'How do I start budgeting?',
    'What is an emergency fund?',
    'Needs vs wants?',
    'Tips for saving as a student',
    'How to cut food costs?',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _userId = Provider.of<AuthProvider>(context, listen: false).currentUserData?.userId;
        });
      }
    });
  }

  Future<void> _send(String text) async {
    text = text.trim();
    if (text.isEmpty || _isLoading || _userId == null) return;

    final tProvider = Provider.of<TransactionProvider>(context, listen: false);
    final contextData = {
      'balance': tProvider.availableBalance,
      'spent': tProvider.totalExpense,
    };

    _controller.clear();
    setState(() => _isLoading = true);

    await _dbService.saveChatMessage(_userId!, text, false, false);
    _scrollToBottom();

    try {
      final reply = await _gemini.sendMessage(text, context: contextData);
      if (mounted) {
        setState(() => _isLoading = false);
        await _dbService.saveChatMessage(_userId!, reply, true, false);
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        await _dbService.saveChatMessage(_userId!, 'Sorry, I encountered an error. Check connection.', true, true);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.smart_toy_outlined, color: colorScheme.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PennyPal AI', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Educational guidance only', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _suggestions.map((q) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _send(q),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(q, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.75))),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.5)),
                ],
              ),
            ),
            // Messages
            Expanded(
              child: _userId == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _dbService.getChatHistory(_userId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return const Center(child: Text('Error loading history.'));
                        final history = snapshot.data ?? [];
                        if (snapshot.hasData) _scrollToBottom();
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: history.isEmpty ? 1 + (_isLoading ? 1 : 0) : history.length + (_isLoading ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (history.isEmpty && i == 0) {
                              return _buildBubble("Hi! I'm PennyPal AI. Ask me anything about budgeting, saving, or managing your money.", true, false, colorScheme);
                            }
                            if (i == (history.isEmpty ? 1 : history.length)) return _buildTypingIndicator(colorScheme);
                            final msg = history[i];
                            return _buildBubble(msg['text'] as String, msg['isBot'] as bool, msg['isError'] as bool, colorScheme);
                          },
                        );
                      },
                    ),
            ),
            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.4))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _send,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ask anything about money...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        isDense: true,
                        filled: true,
                        fillColor: colorScheme.outline.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _isLoading ? null : () => _send(_controller.text),
                    icon: _isLoading
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary))
                        : Icon(Icons.send_rounded, color: colorScheme.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(String text, bool isBot, bool isError, ColorScheme colorScheme) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isError
              ? colorScheme.error.withValues(alpha: 0.1)
              : isBot ? colorScheme.outline.withValues(alpha: 0.2) : colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isBot ? 4 : 18),
            bottomRight: Radius.circular(isBot ? 18 : 4),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14, height: 1.45,
            color: isError ? colorScheme.error : isBot ? colorScheme.onSurface : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.outline.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [_DotPulse(delay: 0), SizedBox(width: 5), _DotPulse(delay: 160), SizedBox(width: 5), _DotPulse(delay: 320)],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _DotPulse extends StatefulWidget {
  final int delay;
  const _DotPulse({required this.delay});
  @override
  State<_DotPulse> createState() => _DotPulseState();
}

class _DotPulseState extends State<_DotPulse> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.forward(); });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7, height: 7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
}

