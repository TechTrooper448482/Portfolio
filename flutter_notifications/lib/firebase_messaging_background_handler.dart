import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're using other Firebase services in the background, like Firestore,
  // make sure to call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  // Handle background message
}
