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
    "private_key_id": "83fb0b071a361a0bc3b0397b57d3ec0f7fee45db",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCiXCjAjvfmrmmF\nU6ZvZaDjqmNFR0CgRVGewwo2mQuoZP3J1l4zbQe6EQ2lQtmCvI2m+qSPy+x8ha75\npeTKEamB6o/H9Ae/xm7AK9XQZHNQgM0QOCOr5TIo12/1CyvVd5AvveipocDnDHcv\nIQn/PRruhkr4WG8+F4iDlw4Dk1fSi5tJga58ir3hxwKl2JG9c1rhlNcJbmvnUkLE\n1n5utz9ljuEXVWCh2Lf4iWzzWuXXtTWmXDTV+GvvaXZNYr0jSkbNfR0HoncbVmer\n4suG13ocld1YiKlEJ5WUXUMzGnwEfxHqvn+vCDs+xQTMbpaDmbRC/zRmE5ef1x0j\nkkeZTCIRAgMBAAECggEACiHBqkiRuEvMinUupvd625I7uSxJ4GaLAiMOPVt+In9Q\n5hpSTRfB+m7LgPNjwviUx2WPROj3JEssYOhlF2YUQ6b5W4NDQ4i0yxnBMUy/dHfh\nNCCouzalk25kTnCoxty7+vq5LPLK6LA6tM51QwATcOyg+4/7Oy75Rir0RS1Z9unF\nWxadTTK54/6e03d6rQMkxaOzNUnZJg90l6bYHlzaLy91yu0S3Sxr+KWq9U3z/LSZ\nX593FZN9JNc27F9jEw6OPOUi7CX0/PlONjs9eRz+pUZ2qN3HXDktqXg1OmFc26lO\nqOc1c5qHwi3uj0h4303u/CWnXjw65dYJV0lRw4GEAQKBgQDdAS2HShm81gMZH9Pf\nxN5nHDZSoHOhZgcXwlTbC837d/FWVFFLzfAQ30ElAcoGhqOxIcg8791dl8M+Cbx2\nMch9AgKOGFmThWjMxwroMrEVay1xjf+6caraqQXIfUzuX9zVdaw3Z1dZ68BnJSvJ\nOVP1tuhLH7KClOxsz3tRPsdnAQKBgQC8EbdLr7F80JSd6xdK9Ho8yVyGEc/Wu4hA\nbShQKxftZza686k4sfbSUQ/YNl0qc+G8lu23pFgytJTJOuHjE2Txz+ZL8I9Q6b2l\nMEYfHdmyl4SP01VbDLrdBkwXGXsJmKrqtcWorFh9AHlTatKvAgSgew4JkMSRxpUM\nCr+/e+FLEQKBgGE/cW9EtgqYCYj2rl6a3Fp22ZiGLhtpL9nOk1RH3322C6Y3OAap\nOefStXG5VdKFUGZTPS9DRR839pvH4PwJb/VB+ynXoSL+41yogS4nkDCilr6PA2Zh\nOhM5qOfN6xpBaIUtYHiIqrFQwbshaiEDbuSCdbkI254GNfqzWcooW8oBAoGAYQ1T\nZb94/Ew3JXdYQdn/6raPBLDUbJ/CJF0wXI6gfmaxG7D6NsO/97DVWGJVmb7LUyMf\n8ZDh4ujFj0LPpvsvMIp08eNmUf8NWt2akhw5Z6xBQGdyuNXM6JqDUbhYgg9CxHSh\nV/X4hClmcuHBb4a/FIHsMIuApSmxaNFzOkGXdcECgYAzHDdiTQLK7cFYh2lwHM71\nxBsVuLVm6UPtoaEnmfClZw1pYUsosU6E0kJ48q2O0cBerTucQOqJYERZj4LD82B8\nARFRO8kmgzTzPLDJP7KmuiAvfZ1IHQBzdqrBQVdNUalBX6pcvmzpAj1eB46O/nmK\neJ1dqDb6YRziS4OCM0zISQ==\n-----END PRIVATE KEY-----\n",
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
