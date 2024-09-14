import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat/chat_service.dart';
import '../components/homedrawer.dart';
import '../components/user_tile.dart';
import 'chat_room.dart';
import '../globals.dart';
class HomePage extends StatelessWidget {
   HomePage({super.key});
      final ChatService _chatservice =ChatService();
      final FirebaseAuth _auth=FirebaseAuth.instance;

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
        backgroundColor: Colors.green.shade100,
      ),
      endDrawer:  Drawer(
        backgroundColor: Colors.green.shade50,
        child: Homedrawer(image: globalUserData,),
      ),
  body: userlist(),
    );
  }
  Widget userlist(){
    return StreamBuilder(
        stream: _chatservice.getUsersStrean(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.map<Widget>((userData) {
              return _buildUserListitem(userData, context);
            }).toList(),

          );
        }
    );
  }
  Widget _buildUserListitem(Map<String,dynamic>userData,BuildContext context ){
      if(userData['email']!=_auth.currentUser!.email){
        return
          Usertile(text: userData['username'], onTap: () {
          Navigator.push(context,MaterialPageRoute(
               builder: (context)=>ChatRoom(
                senderID: userData['email'],
                reciverID: userData['uid'],
                Username: userData['username'],
                image:   ProfileImage(imageUrl: userData['imageurl']),

              )) );
        },  image:
              ProfileImage(imageUrl: userData['imageurl']),
    );
  } else{
        return Container();}
      }
}
class ProfileImage extends StatelessWidget {
  final String? imageUrl;

  const ProfileImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
    )
        : Image.asset(
      'assets/avatar.png.png',
      fit: BoxFit.cover,
    );
  }
}