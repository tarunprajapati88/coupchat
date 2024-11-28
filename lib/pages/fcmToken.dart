import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FCM{

   static Future<void> updateFcmTokenInFirestore(bool add) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser!.uid;
      String? token;
      if(add){
      token = await FirebaseMessaging.instance.getToken();
      }
      else{
        token="";
      }
      await _firestore.collection('Users').doc(uid).update({
        'fcmtoken':token ,
      });
    } catch (e) {
      debugPrint("Error updating FCM token in Firestore: $e");
    }
  }
}