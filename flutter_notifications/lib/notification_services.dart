// import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }
  }

  void initLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tapped logic here
      },
    );
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // Ensure this icon is available
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random.secure().nextInt(100000), // Generate a unique id
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      // Save or send new token to the server
    });
  }

void handleMessage(BuildContext context, RemoteMessage message){
  
}


}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices notificationServices = NotificationServices();
  notificationServices.requestNotificationPermission();
  notificationServices.initLocalNotifications();
  notificationServices.firebaseInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Local Notifications'),
        ),
        body: Center(
          child: Text('Listening for notifications...'),
        ),
      ),
    );
  }
}
















// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('user granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('user granted provisional permission');
//     } else {
//       print('user denied permission');
//     }
//   }

//   void initLocalNotifications(RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');

//     var initializationSetting = InitializationSettings(
//       android: androidInitializationSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveBackgroundNotificationResponse: (payload) {});
//   }

//   void firebaseInIt() {
//     FirebaseMessaging.onMessage.listen((message) {
//       print(message.notification!.title.toString());
//       print(message.notification!.body.toString());
//       showNotification(message);
//     });
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (Platform.isAndroid) {
//         initLocalNotifications(message);
//         showNotification(message);
//       }
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//         Random.secure().nextInt(100000).toString(),
//         'High Importance Notifications',
//         importance: Importance.max);
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'Your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             ticker: 'ticker');

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }

//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       print('refresh');
//     });
//   }
// }
