import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final auth = ref.read(authServiceProvider);
      if (_isLogin) {
        await auth.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await auth.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          _emailController.text.split('@').first,
        );
      }
      if (mounted) context.go('/phrasebook');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _isLoading = true);
    try {
      final auth = ref.read(authServiceProvider);
      await auth.signInAnonymously();
      if (mounted) context.go('/phrasebook');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).validEmail)),
      );
      return;
    }

    try {
      final auth = ref.read(authServiceProvider);
      await auth.resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).resetPasswordSent)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Logo area
                Icon(
                  Icons.language,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appName,
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.learnTugen,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (v) =>
                      v != null && v.contains('@') ? null : l10n.validEmail,
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: const Icon(Icons.lock_outlined),
                  ),
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : l10n.minPassword,
                ),
                const SizedBox(height: 8),

                // Forgot password
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: Text(l10n.forgotPassword),
                    ),
                  ),
                const SizedBox(height: 16),

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isLogin ? l10n.signIn : l10n.createAccount),
                ),
                const SizedBox(height: 12),

                // Toggle login/signup
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? l10n.noAccount : l10n.hasAccount,
                  ),
                ),
                const SizedBox(height: 24),

                // Guest access
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _continueAsGuest,
                  icon: const Icon(Icons.person_outline),
                  label: Text(l10n.continueAsGuest),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
