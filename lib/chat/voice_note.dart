import 'package:cloud_firestore/cloud_firestore.dart';

class Voice{
  final String sender;
  final String senderEmail;
  final  String reciversID;
  final String audiourl;
  final Timestamp timestamp;
  final bool seen;
  final String type;

  Voice(
      { required this.sender,
        required this.senderEmail,
        required this.reciversID,
        required this.audiourl,
        required this.timestamp,
        required this.seen,
        required this.type, }
      );
  Map<String,dynamic>tomap(){
    return{
      'senderId': sender,
      'senderEmail':senderEmail,
      'reciversID':reciversID,
      'audiourl':audiourl,
      'timestamp':timestamp,
      'seen':seen,
      'type':type
    };
  }
}