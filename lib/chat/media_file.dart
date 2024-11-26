import 'package:cloud_firestore/cloud_firestore.dart';

class MediaFile{
  final String sender;
  final String senderEmail;
  final  String reciversID;
  final String mediaurl;
  final Timestamp timestamp;
  final bool seen;
  final String type;

  MediaFile(
      { required this.sender,
        required this.senderEmail,
        required this.reciversID,
        required this.mediaurl,
        required this.timestamp,
        required this.seen,
        required this.type,}
      );
  Map<String,dynamic>tomap(){
    return{
      'senderId': sender,
      'senderEmail':senderEmail,
      'reciversID':reciversID,
      'mediaurl':mediaurl,
      'timestamp':timestamp,
      'seen':seen,
      'type':type
    };
  }
}