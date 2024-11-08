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
  final ChatService _chatservice = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[200],
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.grey[350],
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.message),
              icon: Icon(Icons.message_outlined),
              label: 'Chats'),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt),
            selectedIcon: Icon(Icons.person_add_alt_1),
            label: 'Add Users',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        actions: [
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.settings));
          })
        ],
        title: const Text(
          'CoupChat',
          style: TextStyle(
              fontFamily: 'PlaywriteCU',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black),
        ),
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
            DocumentReference documentReference2 = FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUserData['uid']);
            return Homedrawer(
              image: ProfileImage(imageUrl: currentUserData['imageurl']),
              documentrefrence: documentReference2,
              name: currentUserData['username'],
              useridname: currentUserData['uniqueUsername'],
              imageUrl: currentUserData['imageurl'],
              userid: currentUserData['uid'],
            );
          },
        ),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          friendList(),
          const SearchPage(),
        ],
      ),
    );
  }

  Widget friendList() {
    final String currentUserId = _auth.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('myfriends')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final friendsDocs = snapshot.data!.docs;

        if (friendsDocs.isEmpty) {

          return Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18), // Rounded corners
                ),
                elevation: 5, // Shadow elevation
              ),
              child: const Text('Add friends'),
            ),
          );
        }

        return ListView.builder(
          itemCount: friendsDocs.length,
          itemBuilder: (context, index) {
            DocumentReference friendRef = friendsDocs[index]['friendRef'];

            return FutureBuilder<DocumentSnapshot>(
              future: friendRef.get(),
              builder: (context, friendSnapshot) {
                if (!friendSnapshot.hasData || friendSnapshot.hasError) {
                     return const Padding(
                       padding: EdgeInsets.only(left: 160,top: 300),
                       child: Stack(
                           children:[
                             CircularProgressIndicator()
                           ]
                       ),
                     );
                }

                final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;

                return Usertile(
                  text: friendData['username'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(
                          senderID: _auth.currentUser!.email!,
                          reciverID: friendData['uid'],
                          Username: friendData['username'],
                          image: ProfileImage(imageUrl: friendData['imageurl']),
                          uniqueUsername:  friendData['uniqueUsername'],
                          isverfies: friendData['Isverified'],
                        ),
                      ),
                    );
                  },
                  image: ProfileImage(imageUrl: friendData['imageurl']),
                  verfied:  Icon(friendData['Isverified'] ? Icons.verified_rounded : null,
                    color: Colors.greenAccent,),
                );
              },
            );
          },
        );
      },
    );
  }
}
