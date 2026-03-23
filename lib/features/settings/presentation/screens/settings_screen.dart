import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/audio/audio_service.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _cacheSize = '';

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final size = await ref.read(audioServiceProvider).getCacheSize();
    final mb = (size / (1024 * 1024)).toStringAsFixed(1);
    if (mounted) setState(() => _cacheSize = '$mb MB');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = ref.watch(localeProvider);
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context);

    if (_cacheSize.isEmpty) {
      _cacheSize = l10n.calculating;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Language section
          _SectionHeader(title: l10n.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.appLanguage),
            subtitle: Text(_localeName(locale.languageCode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, ref),
          ),

          const Divider(),

          // Storage section
          _SectionHeader(title: l10n.storage),
          ListTile(
            leading: const Icon(Icons.storage),
            title: Text(l10n.audioCache),
            subtitle: Text(_cacheSize),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.clearCache),
            subtitle: Text(l10n.clearCacheDesc),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.clearCacheConfirm),
                  content: Text(l10n.clearCacheMsg),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.clear),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                await ref.read(audioServiceProvider).clearCache();
                _loadCacheSize();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.cacheCleared)),
                  );
                }
              }
            },
          ),

          const Divider(),

          // Account section
          _SectionHeader(title: l10n.account),
          if (user != null && !user.isAnonymous) ...[
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(l10n.email),
              subtitle: Text(user.email ?? l10n.translate('notSet')),
            ),
          ],
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            subtitle: Text(l10n.privacyPolicyDesc),
            onTap: () => context.go('/profile/settings/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: Text('${l10n.aboutDesc} v1.0.0'),
          ),

          const Divider(),

          // Sign out
          if (user != null)
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text(
                l10n.logout,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
              },
            ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              l10n.madeWith,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.selectLanguage,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            for (final lang in [
              ('en', 'English'),
              ('sw', 'Kiswahili'),
              ('tug', 'Tugen'),
            ])
              ListTile(
                leading: Icon(
                  ref.read(localeProvider).languageCode == lang.$1
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Theme.of(ctx).colorScheme.primary,
                ),
                title: Text(lang.$2),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(lang.$1);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _localeName(String code) {
    return switch (code) {
      'en' => 'English',
      'sw' => 'Kiswahili',
      'tug' => 'Tugen',
      _ => code,
    };
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
