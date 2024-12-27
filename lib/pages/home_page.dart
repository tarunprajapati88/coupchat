import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat/chat_service.dart';
import '../components/chached_image.dart';
import '../components/homedrawer.dart';
import '../components/loading.dart';
import '../components/themes.dart';
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
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: themeColors[4],
        selectedIndex: currentPageIndex,
        indicatorColor: themeColors[5],
        destinations:  <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.message,color: themeColors[6],),
            icon: Icon(Icons.message_outlined,color: themeColors[6],),
            label: 'Chats',

          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt,color: themeColors[6],),
            selectedIcon: Icon(Icons.person_add_alt_1,color: themeColors[6],),
            label: 'Add Users',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      backgroundColor: themeColors[1],//grey.shade100
      appBar: AppBar(
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon:  Icon(Icons.settings,color: themeColors[6],),
            );
          }),
        ],
        title:  Text(
          'linq',
          style: TextStyle(
           fontFamily: 'PlaywriteCU',
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color:themeColors[6],
          ),
        ),
        backgroundColor: themeColors[0],
      ),
      endDrawer: Drawer(
        backgroundColor:themeColors[2],
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatservice.getUsersStrean(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred.'));
            }
            if (!snapshot.hasData) {
              return  Center(child:Loading());
            }

            final currentUserData = snapshot.data!.firstWhere(
                  (userData) => userData['email'] == _auth.currentUser!.email,
            );

            final documentReference2 = FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUserData['uid']);

            return Homedrawer(
              image: ProfileImage(imageUrl: currentUserData['imageurl']),
              documentrefrence: documentReference2,
              name: currentUserData['username'],
              useridname: currentUserData['uniqueUsername'],
              imageUrl: currentUserData['imageurl'],
              userid: currentUserData['uid'],
              ISuserVerified: currentUserData['Isverified'],

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
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .collection('myfriends')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child:   Loading());
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
                foregroundColor: Colors.white,
                backgroundColor:themeColors[0],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 5,
              ),
              child: const Text('Add friends'),
            ),
          );
        }


        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchFriendDetails(friendsDocs),
          builder: (context, friendDetailsSnapshot) {
            if (friendDetailsSnapshot.hasError) {
              return const Center(child: Text('An error occurred.'));
            }
            if (!friendDetailsSnapshot.hasData) {
              return   Center(child:  Loading());
            }

            final friendDetails = friendDetailsSnapshot.data!;

            return ListView.builder(
              itemCount: friendDetails.length,
              itemBuilder: (context, index) {
                final friendData = friendDetails[index];

                return StreamBuilder<QuerySnapshot>(
                  stream: _chatservice.getMessage(currentUserId, friendData['uid']),
                  builder: (context, messageSnapshot) {
                    if (messageSnapshot.hasError) {
                      return Usertile(
                        text: friendData['username'],
                        onTap: () async => navigateToChatRoom(friendData,await fetchCurrentUsername()),
                        image: ProfileImage(imageUrl: friendData['imageurl']),
                        verfied: buildVerifiedIcon(friendData),
                        latestMsg: {},
                      );
                    }

                    if (!messageSnapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final messages = messageSnapshot.data!.docs;
                    final latestMessage = messages.isNotEmpty
                        ? messages.last.data() as Map<String, dynamic>
                        : {'message': 'No messages yet',
                      "reciversID": "",
                      'seen':"null",
                       'type':"",
                      "timestamp":""
                    };

                    return Usertile(
                      text: friendData['username'],
                      onTap: () async => navigateToChatRoom(friendData,await fetchCurrentUsername()),
                      image: ProfileImage(imageUrl: friendData['imageurl']),
                      verfied: buildVerifiedIcon(friendData),
                      latestMsg: latestMessage,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchFriendDetails(
      List<QueryDocumentSnapshot> friendsDocs) async {
    final List<Map<String, dynamic>> friendDetails = [];
    for (final doc in friendsDocs) {
      final friendRef = doc['friendRef'] as DocumentReference;
      final friendSnapshot = await friendRef.get();
      if (friendSnapshot.exists) {
        friendDetails.add(friendSnapshot.data() as Map<String, dynamic>);
      }
    }
    return friendDetails;
  }

  void navigateToChatRoom(Map<String, dynamic> friendData ,String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoom(
          token:friendData['fcmtoken'],
          senderID: _auth.currentUser!.email!,
          reciverID: friendData['uid'],
          Username: friendData['username'],
          image: ProfileImage(imageUrl: friendData['imageurl']),
          uniqueUsername: friendData['uniqueUsername'],
          isverfies: friendData['Isverified'], currentUserName:name,
        ),
      ),
    );
  }

  Icon buildVerifiedIcon(Map<String, dynamic> friendData) {
    return Icon(size: 15,
      friendData['Isverified'] ? Icons.verified_rounded : null,
      color: Colors.blue,
    );
  }
  Future<String> fetchCurrentUsername() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user logged in.");
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User data not found.");
    }
    return userDoc.data()!['username']??"" ;
  }

}
