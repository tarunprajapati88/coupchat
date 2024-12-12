import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/pages/seeUSERprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/chached_image.dart';
import '../components/searchuserTile.dart';
import 'chat_room.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  String? searchQuery;
  Set<String> myFriends = {};

  @override
  void initState() {
    super.initState();
    _loadMyFriends();
  }

  Future<void> _loadMyFriends() async {
    final myFriendsSnapshot = await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('myfriends')
        .get();

    setState(() {
      myFriends = myFriendsSnapshot.docs.map((doc) => doc.id).toSet();
    });
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

    return userDoc.data()!['username'] ?? "";
  }

  void navigateToChatRoom(Map<String, dynamic> userData, String currentUserName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoom(
          token: userData['fcmtoken'],
          senderID: _auth.currentUser!.email!,
          reciverID: userData['uid'],
          Username: userData['username'],
          image: ProfileImage(imageUrl: userData['imageurl']),
          uniqueUsername: userData['uniqueUsername'],
          isverfies: userData['Isverified'],
          currentUserName: currentUserName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: 'Search Users...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        searchQuery = null;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: searchQuery == null || searchQuery!.isEmpty
                  ? const Center(child: Text('Enter text to search'))
                  : FutureBuilder<List<DocumentSnapshot>>(
                future: _searchUsers(searchQuery!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.grey),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  final userDocs = snapshot.data!;

                  return ListView.builder(
                    itemCount: userDocs.length,
                    itemBuilder: (context, index) {
                      final userData =
                      userDocs[index].data() as Map<String, dynamic>;
                      final userId = userDocs[index].id;

                      if (userData['email'] != _auth.currentUser!.email) {
                        bool isFriend = myFriends.contains(userId);

                        return SearchUserTile(
                          text: userData['uniqueUsername'],
                          image: ProfileImage(imageUrl: userData['imageurl']),
                          onTap: () async {
                            if (!isFriend) {
                              addFriend(
                                  _auth.currentUser!.uid, userData['uid']);
                            }
                            setState(() {
                              myFriends.add(userId);
                            });
                            String currentUserName =
                            await fetchCurrentUsername();
                            navigateToChatRoom(userData, currentUserName);
                          },
                          name: userData['username'],
                          icon: Icon(
                            isFriend
                                ? Icons.check_circle
                                : Icons.person_add_alt_1,
                            color: Colors.blueAccent,
                          ),
                          onTapProfile: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Seeuserprofile(
                                    image: ProfileImage(imageUrl: userData['imageurl']),
                                  username: userData['username'],
                                  uniquename: userData['uniqueUsername'],
                                  verfied: Icon(userData['Isverified'] ? Icons.verified_rounded : null,),
                              ),
                            ));
                          }, Verfiedicon: Icon(userData['Isverified'] ? Icons.verified_rounded : null),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> _searchUsers(String query) async {
    final userSnapshot = await _firestore.collection('Users').get();
    return userSnapshot.docs
        .where((doc) =>
    (doc.data() as Map<String, dynamic>)['username']
        .toString()
        .toLowerCase()
        .contains(query) ||
        (doc.data() as Map<String, dynamic>)['uniqueUsername']
            .toString()
            .toLowerCase()
            .contains(query))
        .toList();
  }

  void addFriend(String currentUserId, String friendId) {
    _firestore
        .collection('Users')
        .doc(currentUserId)
        .collection('myfriends')
        .doc(friendId)
        .set({'friendRef': _firestore.collection('Users').doc(friendId)});
  }
}
