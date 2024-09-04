
import 'package:flutter/material.dart';

import '../chat/chat_service.dart';
import '../components/homedrawer.dart';
import '../components/user_tile.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
final ChatService _chatservice =ChatService();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.green[50],
      appBar:  AppBar(
        actions: [
          Builder(
              builder: (context) {
                return IconButton(onPressed: (){
                  Scaffold.of(context).openEndDrawer();
                }, icon:const Icon(Icons.settings) );
              }
          )
        ],
        title: const Text('CoupChat',
          style: TextStyle(
              fontFamily: 'PlaywriteCU',
              fontWeight: FontWeight.w700,
              fontSize: 25,
              color: Colors.black
          ),),
        backgroundColor: Colors.green[100],
      ),
      endDrawer:  Drawer(
        backgroundColor: Colors.green[50],
        child: const Homedrawer(),
      ),
  body: Userlist(),
    );
  }
  Widget Userlist(){
    return StreamBuilder(
        stream: _chatservice.getUsersStrean(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text('Error');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text('Loading...');
          }
          return ListView(
            children: snapshot.data!.map<Widget>((userData)=> _buildUserListitem(userData,context)).toList(),
          );
        }
    );
  }
  Widget _buildUserListitem(Map<String,dynamic>userData,BuildContext context ){
    return Usertile(text: userData['email'], onTap: () {

    },

    );
  }
}
