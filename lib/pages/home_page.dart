import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat/chat_service.dart';
import '../components/chached_image.dart';
import '../components/homedrawer.dart';
import '../components/user_tile.dart';
import 'Searchpage.dart';
import 'chat_room.dart';
class HomePage extends StatefulWidget {
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
      final ChatService _chatservice =ChatService();

      final FirebaseAuth _auth=FirebaseAuth.instance;

   int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[200],
        selectedIndex:currentPageIndex ,
        indicatorColor: Colors.grey[350],
        destinations: const <Widget>[
        NavigationDestination(
            selectedIcon: Icon(Icons.message),
            icon: Icon(Icons.message_outlined), label: 'Chats'),
        NavigationDestination(
          icon: Icon(Icons.person_add_alt),
            selectedIcon: Icon(Icons.person_add_alt_1), label: 'Add Users')
      ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },),
      backgroundColor: Colors.grey.shade100,
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
              fontSize: 20,
              color: Colors.black
          ),),
       backgroundColor: Colors.grey[300],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade200,
        child: StreamBuilder(
          stream: _chatservice.getUsersStrean(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final currentUserData = snapshot.data!.firstWhere(
                  (userData) => userData['email'] == _auth.currentUser!.email,
            );
            DocumentReference documentReference2 =FirebaseFirestore.instance.collection('Users').doc(currentUserData['uid']);
            return Homedrawer(
              image: ProfileImage(imageUrl: currentUserData['imageurl']),
              documentrefrence: documentReference2,
              name:currentUserData['username'] ,
              useridname:currentUserData['uniqueUsername'], imageUrl: currentUserData['imageurl'], userid: currentUserData['uid'],);
                    },
        ),
      ),
  body: IndexedStack(
    index: currentPageIndex,
    children: <Widget>[
      userlist(),
      Searchpage(),
    ],
  ),
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
