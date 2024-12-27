import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static String? fcmUrl = '${dotenv.env['FCM_URL']}';

  static  Map<String, dynamic> serverAccountJsonKey = {
    "type": dotenv.env['FIREBASE_TYPE'],
    "project_id": dotenv.env['FIREBASE_PROJECT_ID'],
    "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID'],
    "private_key": dotenv.env['FIREBASE_PRIVATE_KEY']?.replaceAll(r'\n', '\n'),
    "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL'],
    "client_id": dotenv.env['FIREBASE_CLIENT_ID'],
    "auth_uri": dotenv.env['FIREBASE_AUTH_URI'],
    "token_uri": dotenv.env['FIREBASE_TOKEN_URI'],
    "auth_provider_x509_cert_url": dotenv.env['FIREBASE_AUTH_PROVIDER_CERT'],
    "client_x509_cert_url": dotenv.env['FIREBASE_CLIENT_CERT'],
    "universe_domain": dotenv.env['FIREBASE_UNIVERSE_DOMAIN']
  }


  ;

  static Future<String> getAccessToken() async {
    final List<String> scopes = ["https://www.googleapis.com/auth/firebase.messaging"];
    final auth.ServiceAccountCredentials credentials =
    auth.ServiceAccountCredentials.fromJson(serverAccountJsonKey);

    final auth.AccessCredentials accessCredentials =
    await auth.obtainAccessCredentialsViaServiceAccount(credentials, scopes, http.Client());
    return accessCredentials.accessToken.data;
  }

  static Future<void> sendPushNotification({
    required String targetToken,
    required String title,
    required String body,
  }) async {
    try {
      final String accessToken = await getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final Map<String, dynamic> notificationPayload = {
        "message": {
          "token": targetToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "android": {
            "notification": {
              "channel_id": "chats",

            },
            "priority": "high",
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "type": "chat",
          },
        },
      };

      final http.Response response = await http.post(
        Uri.parse(fcmUrl!),
        headers: headers,
        body: jsonEncode(notificationPayload),
      );

      if (response.statusCode == 200) {
        print("Push notification sent successfully");
      } else {
        print("Failed to send push notification. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    var result = await FlutterNotificationChannel().registerNotificationChannel(
      description: 'Pop Up Notifications',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'chats',
      visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      allowBubbles: true,
      enableVibration: true,
      enableSound: true,
      showBadge: true,

    );
    print(result);
    print("Background message received: ${message.messageId}");
  }

  static Future<void> initializeForegroundNotifications() async {

    await FlutterNotificationChannel().registerNotificationChannel(
      description: 'Pop Up Notifications',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'chats',
      visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      allowBubbles: true,
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
    });
  }

}
