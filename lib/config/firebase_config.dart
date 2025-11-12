import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// ignore: unused_import
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      try {
        // Fallback to FlutterFire options if available
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (_) {}
    }
  }
  // Handle background message if needed
}

class FirebaseConfig {
  static bool _messagingConfigured = false;

  static Future<FirebaseApp> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return Firebase.apps.first;
    }
    try {
      // Try default initialization (works when platform config files exist)
      return await Firebase.initializeApp();
    } catch (_) {
      // Fallback to FlutterFire-generated options
      // Requires lib/firebase_options.dart (run: flutterfire configure)
      return await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  static Future<void> configureMessaging() async {
    if (_messagingConfigured) return;
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _messagingConfigured = true;
  }
}


