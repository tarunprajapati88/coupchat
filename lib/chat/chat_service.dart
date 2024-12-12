import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/chat/media_file.dart';
import 'package:coupchat/chat/message.dart';
import 'package:coupchat/chat/pushnotification.dart';
import 'package:coupchat/chat/voice_note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Stream<List<Map<String, dynamic>>> getUsersStrean() {
    return _firestore.collection('Users').snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user =doc.data();
        return user;
      }).toList();
    });
  }



  Future<DocumentReference>sendMessage(String reciverId,message, bool seen,String targetToken,String name)async{

    final String currentUserId=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();
    PushNotificationService.sendPushNotification(targetToken: targetToken, title: name, body: message);
 Message newMessage = Message(
     sender: currentUserId,
     senderEmail: currentUserEmail,
     reciversID: reciverId,
     message: message,
     timestamp: timestamp,
     seen: seen,
     type: 'text',

 );
 List<String>ids =[currentUserId,reciverId];
 ids.sort();
 String chatroomId =ids.join('_');
    DocumentReference docRef= await _firestore
     .collection('chat_rooms')
     .doc(chatroomId)
     .collection('message')
     .add(newMessage.tomap());
    return docRef;

}



  Future<DocumentReference>sendVoiceNote(String reciverId,url, bool seen,String targetToken,name)async{
    final String currentUserId=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();
    PushNotificationService.sendPushNotification(targetToken: targetToken, title: name, body: 'Sent a voicenote');
    Voice newMessage = Voice(
      sender: currentUserId,
      senderEmail: currentUserEmail,
      reciversID: reciverId,
      audiourl: url,
      timestamp: timestamp,
      seen: seen,
      type: 'voicenote',

    );
    List<String>ids =[currentUserId,reciverId];
    ids.sort();
    String chatroomId =ids.join('_');
    DocumentReference docRef= await _firestore
        .collection('chat_rooms')
        .doc(chatroomId)
        .collection('message')
        .add(newMessage.tomap());
    return docRef;
  }



  Future<String> uploadVoiceNote(String filePath) async {
    File file = File(filePath);
    String fileName = 'voice_notes/${DateTime.now().millisecondsSinceEpoch}.m4a';
    try {
      TaskSnapshot uploadTask = await _storage.ref(fileName).putFile(file);
      String downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception("Error uploading voice note: $e");
    }
  }



  Future<String> uploadImage(File imageFile) async {
    try {

      String fileName = '${DateTime.now().millisecondsSinceEpoch}_chat_image.jpg';


      Reference storageRef = _storage.ref().child('chat_images/$fileName');


      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;


      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Image upload failed: ${e.toString()}");
    }
  }



  Future<DocumentReference>sendMedia(String reciverId,url, bool seen,String targetToken,name)async{
    final String currentUserId=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();
    PushNotificationService.sendPushNotification(targetToken: targetToken, title: name, body: 'Sent a image');
    MediaFile newMessage = MediaFile(
      sender: currentUserId,
      senderEmail: currentUserEmail,
      reciversID: reciverId,
      mediaurl: url,
      timestamp: timestamp,
      seen: seen,
      type: 'image',

    );
    List<String>ids =[currentUserId,reciverId];
    ids.sort();
    String chatroomId =ids.join('_');
    DocumentReference docRef= await _firestore
        .collection('chat_rooms')
        .doc(chatroomId)
        .collection('message')
        .add(newMessage.tomap());
    return docRef;
  }
Stream<QuerySnapshot>getMessage(String userID,otheruserID){
  List<String>ids =[userID,otheruserID];
  ids.sort();
  String chatroomId =ids.join('_');
  return _firestore
      .collection('chat_rooms')
      .doc(chatroomId).collection('message')
      .orderBy('timestamp',descending: false)
      .snapshots();
}

}