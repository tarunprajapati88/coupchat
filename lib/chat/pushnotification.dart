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
    "private_key_id": "83c79d8939303f5cad8e920f8a2409c732955b84",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDHDX/llTdU8vsh\n7iPl1QYaT85W8adT/PrnqkjcXkg0gnBJyzoV4kY7rG9e8tH4+3AKK7sbqGH71AB0\n98BCuaQ+1fglWmXLVNVvr5U0vCz5LSwinM1dvgU8ODFEQgsK3sjOVcEE+JxEtfHG\nMwiPosZOQyEwRWSb/2PtEQQcwuTCoavBMiAnPEuJeUOLyeEjvI+W58lYsFeR5htg\nNi7hkqvSz2IZFq5f6h2v6k+F01giBO1Zo338RUr77aYrfxGcxL0aiqaPvJyKLOot\n3GehbDPwFWDliijEaluP9xaaPrju6zA3udABmwED3R3HWLpyY30cTkVDSr3g00BS\nE2FgwmwtAgMBAAECggEAFCEh23I9D7qoudQuzim+Pb/vUmyKqtws9WuLhbmFHMZK\nG7RREfB5gMRd2OC+airnOCgW+mOLUR+t0iZRy42hdfdGamSbYbYZBXvgn14eQC6Y\nxYFM5Vt3hRD7rnbtTfKcpP0YEWwgxXQO2KfFiF0CJ9zzCMIjvADWNp2faFcvMh1g\netDqCZnHwQDfu2WpTyDnoGsSNQOpyeq8NYs69n/uNzCJUEqOtu+PEaMtlHrhKhjx\nLfoKBuh6MLYlwQXQIwleR+1ybTjXK3XnmNXw4Km5abEMIamR3+uT9nZRjg5zgxCb\npdvDSBOeW2hZodYwLi1pj8VR6yWop/shQCITCBqiowKBgQDN2y86q0vwCpg3FPG/\niAPu3nubsYwiNuiNLeeutd8BJCvHO4F5eDFCEVlFUmpNwRWXdb1ZB+k5Oj/2YyNz\n8wAHsTOvuHVHYxAjKsQkXDOUoGwylHLcwVbcAreG7VcJkNPVlmT4FxT5nHVujV3C\nZKkmU0h5+hxI87Ws5U/heVK3IwKBgQD3ihBiBEyL04ZruiLxlXSTnQdHqjKui1m2\n5gVSWawHk0gPGcTBla/vVLPLskNCAJhgJhjcgwI9FrPeSGxCBs0ZBNfKadaVtMEm\n7st7xw/KbA2eJydYUKkCIOh+1sHPBY28w2JvSC2sIKHpvTP2W/aRh5zMfAzW78n/\nYIGiZBksbwKBgHh7YWAQI6jBOqd6XadA3zRuCKBuQNtBkcgXZvMNRRDw76JyxGuo\nmgPWDY6SFt+dM5rq8UBrbeftnMQC8BwLzCe0YdDlv9ZhN2+ttxCk2heR8OGFmthz\nW/f2qx2QSZGyrxjiJgRB1ifll6F1obuFmK5yrgeeB/H2mY0wxRjtHilLAoGAMu8g\nsdpqmbbbiN0TBZyYESuVbOSTayDXQ/AOlkRHRoPCpwDJYH/ZZKiMGlTCzBjtQZN1\nOCJo2oMKXamPRQK7PvOlJ0wh0EoSGF24Vu69zAvxvWIXEW//ZqW40SiFVoCxCm81\nmOpEI4/PYRYCVCXWFVnPJLA9wBg0+ywzYGOyXlcCgYAYi0P/Dfw5dfXBMBsmVH5q\nzyzRzORvPLT7eaHhK9G+QMdeS34Lj2qchYtTpbTVH3G8ZAGwJB9U8D4YVrvqmPnm\nOnxMJgGs+lQ0qYUWzC7fncVGamXF1fN7gpz955aR4PPPrGpTx/UBqYS3gSUD1VtE\n9ofXhgQfc19cX4AXivvLug==\n-----END PRIVATE KEY-----\n",
    "client_email": "coupchat1@appspot.gserviceaccount.com",
    "client_id": "103530353896658803995",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/coupchat1%40appspot.gserviceaccount.com"
  };

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
