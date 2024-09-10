import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/chat/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final FirebaseAuth _auth=FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getUsersStrean() {
    return _firestore.collection('Users').snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user =doc.data();
        return user;
      }).toList();
    });
  }
  Future<void>sendMessage(String reciverId,message)async{
    final String currentUserId=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();

 Message newMessage = Message(
     sender: currentUserId,
     senderEmail: currentUserEmail,
     reciversID: reciverId,
     message: message,
     timestamp: timestamp
 );
 List<String>ids =[currentUserId,reciverId];
 ids.sort();
 String chatroomId =ids.join('_');
 await _firestore
     .collection('chat_rooms')
     .doc(chatroomId)
     .collection('message')
     .add(newMessage.tomap());
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