import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String sender;
  final String senderEmail;
  final  String reciversID;
  final String message;
  final Timestamp timestamp;
  final bool seen;
  final String type;

  Message(
      { required this.sender,
    required this.senderEmail,
    required this.reciversID,
    required this.message,
    required this.timestamp,
    required this.seen,
    required this.type, }
   );
  Map<String,dynamic>tomap(){
    return{
      'senderId': sender,
      'senderEmail':senderEmail,
      'reciversID':reciversID,
      'message':message,
      'timestamp':timestamp,
      'seen':seen,
      'type':type
    };
  }
}