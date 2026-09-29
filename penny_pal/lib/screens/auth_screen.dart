import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'dart:async';
import 'package:penny_pal/providers/auth_provider.dart';
import 'package:penny_pal/main.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;
  const AuthScreen({super.key, required this.isLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  int _failedLoginAttempts = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedCountryCode = '+1';
  final List<Map<String, String>> _countryCodes = [
    {'code': '+1',   'flag': 'US'},
    {'code': '+27',  'flag': 'ZA'},
    {'code': '+33',  'flag': 'FR'},
    {'code': '+44',  'flag': 'GB'},
    {'code': '+49',  'flag': 'DE'},
    {'code': '+61',  'flag': 'AU'},
    {'code': '+91',  'flag': 'IN'},
    {'code': '+92',  'flag': 'PK'},
    {'code': '+94',  'flag': 'LK'},
    {'code': '+971', 'flag': 'AE'},
  ];

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showPrettyPopup(String title, String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? colorScheme.error : colorScheme.primary,
            size: 48,
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message, textAlign: TextAlign.center, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            )
          ],
        );
      },
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ForgotPasswordDialog(prefillEmail: _emailController.text.trim()),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_isLogin && !_agreedToTerms) return;
      
      final auth = Provider.of<AuthProvider>(context, listen: false);
      bool success;
      if (_isLogin) {
        success = await auth.login(_emailController.text.trim(), _passwordController.text);
      } else {
        final fullPhone = '$_selectedCountryCode ${_phoneController.text}';
        success = await auth.register(
          fullName: _nameController.text,
          email: _emailController.text,
          mobileNumber: fullPhone,
          password: _passwordController.text,
        );
      }
      if (!mounted) return;
      if (success) {
        setState(() => _failedLoginAttempts = 0);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        if (_isLogin) setState(() => _failedLoginAttempts++);
        _showPrettyPopup('Oops!', auth.error ?? 'Authentication failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = PennyPalApp.of(context).isDarkMode;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: isDesktop
          ? _buildDesktopLayout(theme, colorScheme, isDark)
          : _buildMobileLayout(theme, colorScheme, isDark),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Row(
      children: [
        // Left brand panel
        Expanded(
          child: _buildBrandPanel(theme, colorScheme, isDark),
        ),
        // Right form panel
        Expanded(
          child: _buildFormPanel(theme, colorScheme, isDark),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return _buildFormPanel(theme, colorScheme, isDark, showBackButton: true);
  }

  Widget _buildBrandPanel(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF101A4D), Color(0xFF0B1135)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isDark ? null : colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outline, width: 1.5)),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.monetization_on_outlined, color: theme.scaffoldBackgroundColor, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                'PennyPal',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: colorScheme.onSurface),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Your money,\nmade simple.',
            style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, height: 1.15),
          ),
          const SizedBox(height: 32),
          _buildBrandPoint(context, 'Track every expense'),
          const SizedBox(height: 16),
          _buildBrandPoint(context, 'Hit your savings goals'),
          const SizedBox(height: 16),
          _buildBrandPoint(context, 'Learn as you spend'),
          const Spacer(),
          Text(
            'Fresh all along',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandPoint(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 16, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withValues(alpha: 0.9))),
      ],
    );
  }

  Widget _buildFormPanel(ThemeData theme, ColorScheme colorScheme, bool isDark, {bool showBackButton = false}) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBackButton) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  _isLogin ? 'Welcome back' : 'Create your account',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? 'Log in to continue.' : 'Start tracking in a minute.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 32),

                // Name field (register only)
                if (!_isLogin) ...[
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full name',
                    hint: 'Aisha Khan',
                    icon: Icons.person_outline,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email field
                _buildInputField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter your email';
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone field (register only)
                if (!_isLogin) ...[
                  const Text('Mobile number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            items: _countryCodes.map((c) => DropdownMenuItem(value: c['code'], child: Text('${c['flag']} ${c['code']!}'))).toList(),
                            onChanged: (val) => setState(() => _selectedCountryCode = val ?? '+1'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter your mobile number';
                            final phoneRegex = RegExp(r'^[0-9\s\-]{7,15}$');
                            if (!phoneRegex.hasMatch(v)) return 'Enter a valid mobile number';
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '234 567 8900',
                            prefixIcon: Icon(Icons.phone_outlined, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Password field
                _buildPasswordField(colorScheme),

                // Forgot password link (login only) - shows after 3 failed attempts
                if (_isLogin && _failedLoginAttempts >= 3) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('Forgot password?', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                ] else if (_isLogin && _failedLoginAttempts > 0) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${3 - _failedLoginAttempts} attempt${3 - _failedLoginAttempts == 1 ? '' : 's'} before reset option',
                      style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.45), fontSize: 11),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Consent Checkbox
                if (!_isLogin) ...[
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: colorScheme.primary,
                        onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/legal'); 
                          },
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Privacy, Terms & Cookie Policies',
                                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Submit button
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final isSubmitDisabled = auth.isLoading || (!_isLogin && !_agreedToTerms);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitDisabled ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: auth.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: theme.scaffoldBackgroundColor),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_isLogin ? 'Log in' : 'Sign up'),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Switch mode
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _isLogin = !_isLogin),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
                        children: [
                          TextSpan(text: _isLogin ? 'New here? ' : 'Already registered? '),
                          TextSpan(
                            text: _isLogin ? 'Create an account' : 'Log in',
                            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          validator: (v) => (v == null || v.length < 8) ? 'Use at least 8 characters' : null,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: Icon(Icons.lock_outline, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  final String prefillEmail;
  const _ForgotPasswordDialog({required this.prefillEmail});

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  late TextEditingController _emailCtrl;
  bool _isLoading = false;
  bool _sent = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.prefillEmail);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) { setState(() => _error = 'Please enter your email.'); return; }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) { setState(() => _error = 'Enter a valid email address.'); return; }

    setState(() { _isLoading = true; _error = ''; });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) setState(() { _isLoading = false; _sent = true; });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.code == 'user-not-found'
            ? 'No account found with that email.'
            : e.message ?? 'Failed to send reset email.';
      });
    } catch (e) {
      setState(() { _isLoading = false; _error = 'Something went wrong. Try again.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: _sent ? _buildSuccess(colorScheme) : _buildForm(colorScheme),
        ),
      ),
    );
  }

  Widget _buildForm(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock_reset_outlined, size: 52, color: colorScheme.primary),
        const SizedBox(height: 16),
        const Text('Reset Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Enter your email and we will send you a password reset link.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 24),
        if (_error.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Icon(Icons.error_outline, size: 18, color: colorScheme.error),
              const SizedBox(width: 8),
              Expanded(child: Text(_error, style: TextStyle(color: colorScheme.error, fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline, size: 20)),
        ),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: _isLoading ? null : _sendReset,
              child: _isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Send Reset Link'),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildSuccess(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.mark_email_read_outlined, size: 64, color: colorScheme.primary),
        const SizedBox(height: 16),
        const Text('Email Sent!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          'A reset link was sent to . Check your inbox and spam folder.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.7), height: 1.5),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ),
      ],
    );
  }
}
