import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coupchat/components/prfofile_photo.dart';

import '../components/textfield2.dart';
class ChatRoom extends StatefulWidget {
  final String senderID;
  final String reciverID;
  final String Username;
  final Widget? image;

  const ChatRoom({super.key,
    required this.senderID,
    required this.reciverID, required this.Username, this.image
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final TextEditingController tosend =TextEditingController();
  final ChatService _chatService=ChatService();


  void sendMessage()async{
    if(tosend.text.isNotEmpty){

      await _chatService.sendMessage(widget.reciverID, tosend.text);
      tosend.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tilelen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leadingWidth: tilelen/7.5,
        titleSpacing: 0,
        leading:   Row(
          children: [
            const BackButton(),
            PrfofilePhoto(image: widget.image, height: tilelen/17, weight: tilelen/17,),
          ],
        ),
        title: Text(widget.Username,
          style: const TextStyle(
          ),),

        backgroundColor: Colors.green[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _builduserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.reciverID, senderID),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text('loading..');
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          List<Widget> messageWidgets = docs.map((doc) => _buildMessageItem(doc)).toList().reversed.toList();

          return ListView(
            reverse: true,
            children: messageWidgets,
          );
              }
          );

  }
  Widget  _buildMessageItem(DocumentSnapshot doc){

    Map<String,dynamic>data =doc.data() as Map<String,dynamic>;
    bool isCurrentuser =data['senderId']==_auth.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Column(
        crossAxisAlignment: isCurrentuser?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isCurrentuser? Colors.green[100]:Colors.white,
            ),
            child: Text( data['message'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),),
          ),
        ],
      ),
    );
  }

  Widget _builduserInput(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: MyTextfield2
            (icon: const Icon(Icons.message),
            name: 'Message',
            obst: false,
            controller: tosend,
          )
          ),
          IconButton(
                highlightColor: Colors.green[100],
                onPressed: sendMessage,
                icon: const Icon(Icons.arrow_circle_up,
                size: 50,
                color: Colors.black87,))
        ],
      ),
    );
  }
}
