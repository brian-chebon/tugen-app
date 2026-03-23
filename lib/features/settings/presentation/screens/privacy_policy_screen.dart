import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugen App Privacy Policy',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: March 2026',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            _section(theme, '1. Data We Collect',
                'We collect only the minimum data needed to provide the service:\n'
                    '\n'
                    '- Email address (if you create an account)\n'
                    '- Learning progress (quiz scores, flashcard reviews, streaks)\n'
                    '- App usage data (anonymous analytics via Firebase Analytics)\n'
                    '\n'
                    'Guest users: No personal data is collected. Progress is stored locally on your device only.'),
            _section(theme, '2. How We Use Your Data',
                '- To save and sync your learning progress across devices\n'
                    '- To improve the app experience through anonymous usage analytics\n'
                    '- We do NOT sell your data to third parties\n'
                    '- We do NOT use your data for advertising purposes'),
            _section(theme, '3. Data Storage & Security',
                '- Data is stored securely using Firebase (Google Cloud) infrastructure\n'
                    '- User data is access-controlled: only you can read/write your own progress\n'
                    '- Audio content and learning materials are stored in Firebase Storage with read-only public access\n'
                    '- Local data is stored in an SQLite database on your device'),
            _section(theme, '4. Your Rights (Kenya DPA 2019)',
                'Under the Kenya Data Protection Act 2019, you have the right to:\n'
                    '\n'
                    '- Access your personal data\n'
                    '- Correct inaccurate data\n'
                    '- Request deletion of your data\n'
                    '- Withdraw consent at any time\n'
                    '\n'
                    'To exercise these rights, delete your account in Settings or contact us.'),
            _section(theme, '5. Audio Recordings',
                'Audio content in this app is recorded with the informed consent of native Tugen speakers. '
                    'All recordings are used solely for language education purposes and are licensed under Creative Commons (CC-BY).'),
            _section(theme, '6. Children',
                'This app is suitable for all ages. We do not knowingly collect personal information from children under 13 without parental consent. '
                    'Guest mode allows children to use the app without creating an account.'),
            _section(theme, '7. Third-Party Services',
                'This app uses the following third-party services:\n'
                    '\n'
                    '- Firebase Authentication (account management)\n'
                    '- Firebase Firestore (data storage)\n'
                    '- Firebase Analytics (anonymous usage statistics)\n'
                    '\n'
                    'These services are governed by Google\'s Privacy Policy.'),
            _section(theme, '8. Contact',
                'For questions about this privacy policy or your data, please contact the Tugen App team.'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _section(ThemeData theme, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
