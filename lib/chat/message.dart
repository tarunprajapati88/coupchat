import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String sender;
  final String senderEmail;
  final  String reciversID;
  final String message;
  final Timestamp timestamp;

  Message(
  { required this.sender,
    required this.senderEmail,
    required this.reciversID,
    required this.message,
    required this.timestamp, }
   );
  Map<String,dynamic>tomap(){
    return{
      'senderId': sender,
      'senderEmail':senderEmail,
      'reciversID':reciversID,
      'message':message,
      'timestamp':timestamp
    };

  }
}