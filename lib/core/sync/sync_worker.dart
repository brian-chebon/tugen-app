import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../database/app_database.dart';
import 'sync_service.dart';

/// Top-level callback for Workmanager background tasks.
/// Must be a top-level function (not a method or closure).
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final db = AppDatabase();
      final syncService = SyncService(db, null); // TODO: get cached userId

      switch (taskName) {
        case 'syncUserProgress':
          await syncService.processQueue();
          break;
        default:
          break;
      }

      await db.close();
      return true;
    } catch (e) {
      return false;
    }
  });
}
