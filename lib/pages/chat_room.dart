import 'package:coupchat/components/textfield.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
   const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
TextEditingController tosend =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Container(
            height: 80,
            color: Colors.green.shade100,
          ),
          Expanded(
            child: Container(
                          ),
          ),
         Padding(

           padding: const EdgeInsets.all(5.0),
           child: Row(

             children: [
               Expanded(
                 child: MyTextfield(
                     icon: Icon(Icons.message),
                     name: 'Message',
                     obst: false,
                     controller: tosend),
               ),
               IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_up_rounded,
               color: Colors.green.shade100,
                 size: 40,
               ))
             ],
           ),
         )
        ],
      ),
    );
  }
}
