import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/sync/sync_service.dart';
import 'core/sync/sync_worker.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait (mobile only)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Background sync worker (not available on web)
  if (!kIsWeb) {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      'tugen-sync',
      'syncUserProgress',
      frequency: const Duration(hours: 1),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  // Pull content on startup (non-blocking)
  _pullContentInBackground();

  runApp(
    const ProviderScope(
      child: TugenApp(),
    ),
  );
}

/// Pull public content (phrases, decks, stories) in the background on launch.
/// This ensures the local DB is populated for offline use.
void _pullContentInBackground() {
  final db = AppDatabase();
  final sync = SyncService(db, null); // no userId needed for public content
  sync.pullContent().catchError((_) {});
}
