import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static const String projectId = "coupchat1";
  static const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  static const Map<String, dynamic> serverAccountJsonKey = {
    "type": "service_account",
    "project_id": "coupchat1",
    "private_key_id": "e4f73e7bfa7c18a68ddc87caf0ef80481a3bf9e4",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCyQjtCu7domLGt\n6vq9fTtMrQQpn+zB6Rv8/EaZ50DyNZGlyFF5lrfgYDHeve33es49kzDuZCceu7CG\nYyJWcGSbkU0mEWB727sR2oEmTXwa5lvaa3DeC5W4CMh6sJR37eZ5aWCDH6bDmIvi\nXQoHQDUQmAR4qQfEzSnWk9kGbWXTshcIAt1lSI/eoDU8BRClO55ttZrZReVRZlQm\n2koeE+w8iS+9s7vABMWtzeT4w1DCjh0/98sdFl0uotValEZd3K0gsCTydIR7GF1c\nRKVbe6bRdfmEFaQipQsqSalW6DjnoX+nn4U0VuK67jxmF8aGkw+D1ECqFzmWlial\nlDMzEoq/AgMBAAECggEAU7uhu5SSsCq9l4zfsB/BuaAx6t2I6IM31uunvEZw7vUz\nz7RbdSpTgC2fb1o3DD9e3nSkEO7xo1GVt2KcsA7Ga37ixuV1tWh/JIFHljbie35G\nmkBKubqmXtadWWhVrUoOL2zM3XsCKjGfT7rVaZeC9aL6wrTfhdW7d+RmFstPgBMG\n1UM0+mEfgQNxaPyG8xdABeHkvXZd1YCKKgPyIMtmZqlh77/e2qvXih1qg4As/k6G\nVL95DSMxYQRHBFvl+rj0aOkK5G3JFolrO/NHvY0bxkhUCC/lvGMREynllaD4dLui\n7JB0OU3qCgVHui0V1qw0OUW76aHHNzwy13J0cOQAAQKBgQDyC/Qi6CjBCzVLAHjQ\nPEkEdmqnDeusJJK+V5QjZfvswCzRAG3jW4Mz0iwuUrF0RRsyoTrWkN4XeVJaAS1m\nreXHdhPTXZGXKV5IRc6CzkWBqCEb0Y+P2gXZWyQhdIS1L3qkcLxPjkPPxPNc0RYQ\nQq/F4xHgcXKdBvcVR2NFN42KvwKBgQC8iOpmCUREAxJ6/vRrwWXVYs4kfCfDqiKi\nbsWFJvTh8XEZyYUB9HoquH5Li4yDHHXxO6soJITS7Tqgn74L1/j//MBFFDNzEa6g\nAFdTxT/QVhdBV5k8SOogA/Pf6WtZ/iVN2NgmthXoLA0g+WsS72Tg/mJGrh+5pUsR\njcfI3rsAAQKBgQDteXLmyJYriD6aPnVKAMu22COdkRfXRe6/Vxedf1KjHo0Z5Wzq\n8v8P2bXFIRa/t4mOrAcZOvrbVwnICn2rzxOxFZUv/A56m3jIOcz6Izyoj/cj3wAW\nJ9czQKt7M2F8jn+qVH09JJw9fcMzHmSiQXtJEJaaeVP04j+LHgY0g+OX6wKBgQCx\nQsGv4fKPR5wujFvenF1Ufat33ku8yc/6jM+lW3VOoiVGq5QkvGnIlOIZwUEBXNb/\nUqyf94Xykx1WPBsBI7R3anqT+GRPQka/JNL2bjSLewYuZ2ApsByAsXawBdTrLeqB\nAOppqzV5r0FAyYEEspRUfpiD/97QOzsTbAx1LgUAAQKBgGy/g2g6a7mMcrg2DR7a\n8y23Pa4GKmw34VjRh70rVuCo3lcrPgsYucKXa2qeFoD5OwoIIG5r1Tc5aFkB45BE\nRkFZyo1KvLkmcPYDZpMC/meVBKk0kGHdvKFvSSxIOAImZFwWmQC+nXZUEezc06Wp\nWHx8ZSFjsuUcyO8g+5gKQ2y9\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-yn1tm@coupchat1.iam.gserviceaccount.com",
    "client_id": "108423707072594780333",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-yn1tm%40coupchat1.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
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
        Uri.parse(fcmUrl),
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
