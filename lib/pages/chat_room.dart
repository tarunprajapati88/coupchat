import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/chat/chat_service.dart';
import 'package:coupchat/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String senderID;
  final String reciverID;
  final String Username;

  const ChatRoom({super.key,
   required this.senderID,
     required this.reciverID, required this.Username
   });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final TextEditingController tosend =TextEditingController();
  final ChatService _chatService=ChatService();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        Future.delayed(const Duration(milliseconds: 1), ()=> scrolldown(1));
      }
    });
  }
  @override
  void dispose(){
    super.dispose();
    myFocusNode.dispose();
    tosend.dispose();
  }
  final ScrollController _scrollController=ScrollController();
  void scrolldown( final int a){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: a),
        curve: Curves.fastOutSlowIn
    );
  }
  void sendMessage()async{
    if(tosend.text.isNotEmpty){
      await _chatService.sendMessage(widget.reciverID, tosend.text);
      tosend.clear();
      scrolldown(1);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: Text(widget.Username,
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
          WidgetsBinding.instance.addPostFrameCallback((_) => scrolldown(1));
          return ListView(
            controller: _scrollController,
            children:
              snapshot.data!.docs.map((doc)=>_buildMessageItem(doc)).toList(),
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
          Expanded(child: MyTextfield
            (icon: const Icon(Icons.message),
              name: 'Message',
              obst: false,
              controller: tosend,
            focusNode: myFocusNode, focusNode2: null,
          )
          ),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_circle_up,
          size: 40,
          color: Colors.black,))
        ],
      ),
    );
 }
}
