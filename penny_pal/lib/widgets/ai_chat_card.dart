import 'package:flutter/material.dart';
import 'package:penny_pal/core/theme.dart';

class AiChatCard extends StatefulWidget {
  const AiChatCard({super.key});

  @override
  State<AiChatCard> createState() => _AiChatCardState();
}

class _AiChatCardState extends State<AiChatCard> {
  final _controller = TextEditingController();
  final List<_ChatMsg> _messages = [
    _ChatMsg(text: 'Hi! Ask me anything about budgeting, saving, or managing your money.', isBot: true),
  ];
  bool _isLoading = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(text: text, isBot: false));
      _controller.clear();
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMsg(
          text: "That's a great question! Try tracking this category for a week to identify patterns.",
          isBot: true,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final penny = Theme.of(context).extension<PennyColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ask PennyPal AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        ...(_messages.take(3).map((msg) => _buildBubble(msg, colorScheme, penny))),
        if (_isLoading) _buildTypingIndicator(colorScheme, penny),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Type a question…',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(Icons.send, color: colorScheme.primary),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Educational guidance only.',
          style: TextStyle(
            fontSize: 11,
            color: penny?.mutedText ?? colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(_ChatMsg msg, ColorScheme colorScheme, PennyColors? penny) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Bot bubble: white 7% + border in dark | outline 25% in light
    // User bubble: gold gradient in dark | primary solid in light
    final botBg = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : colorScheme.outline.withValues(alpha: 0.25);
    final botBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.transparent;

    return Align(
      alignment: msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: !msg.isBot && isDark ? penny?.goldGradient : null,
          color: msg.isBot
              ? botBg
              : (!isDark ? colorScheme.primary : null),
          border: msg.isBot ? Border.all(color: botBorder, width: 1) : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isBot ? 4 : 16),
            bottomRight: Radius.circular(msg.isBot ? 16 : 4),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 13,
            color: msg.isBot
                ? colorScheme.onSurface
                : (isDark ? penny?.goldText : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colorScheme, PennyColors? penny) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : colorScheme.outline.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DotPulse(delay: 0),
            SizedBox(width: 4),
            _DotPulse(delay: 150),
            SizedBox(width: 4),
            _DotPulse(delay: 300),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _ChatMsg {
  final String text;
  final bool isBot;
  const _ChatMsg({required this.text, required this.isBot});
}
