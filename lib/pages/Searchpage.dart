import 'package:coupchat/pages/seeUSERprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                      final userData = userDocs[index].data() as Map<String, dynamic>;
                      final userId = userDocs[index].id;

                      if (userData['email'] != _auth.currentUser!.email) {
                        bool isFriend = myFriends.contains(userId);

                        return SearchUserTile(
                          text: userData['uniqueUsername'],
                          image: ProfileImage(imageUrl: userData['imageurl']),
                          onTap: () {
                            if (!isFriend) {
                              addFriend(_auth.currentUser!.uid, userData['uid']);
                            }
                            setState(() {
                              myFriends.add(userId);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  senderID: userData['email'],
                                  reciverID: userData['uid'],
                                  Username: userData['username'],
                                  image: ProfileImage(imageUrl: userData['imageurl']),
                                  uniqueUsername: userData['uniqueUsername'], isverfies: userData['Isverified'],
                                ),
                              ),
                            );
                          },
                          name: userData['username'],
                          icon: Icon(isFriend ? Icons.check_circle : Icons.person_add_alt_1,color: Colors.blueAccent,),
                          onTapProfile: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Seeuserprofile(
                                    image:  ProfileImage(imageUrl: userData['imageurl']),
                                    username: userData['username'],
                                    uniquename: userData['uniqueUsername'],
                                  verfied:  Icon(userData['Isverified'] ? Icons.verified_rounded : null,
                                  color: Colors.greenAccent,),
                                )
                              ),
                            );
                          }, Verfiedicon: Icon(userData['Isverified'] ? Icons.verified_rounded : null,
                          color: Colors.greenAccent,),
                        );
                      }
                      return const SizedBox();
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

    QuerySnapshot uniqueUsernameSnapshot = await _firestore
        .collection('Users')
        .where('uniqueUsernameLower', isGreaterThanOrEqualTo: query)
        .where('uniqueUsernameLower', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    QuerySnapshot usernameSnapshot = await _firestore
        .collection('Users')
        .where('usernameLower', isGreaterThanOrEqualTo: query)
        .where('usernameLower', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final allDocs = uniqueUsernameSnapshot.docs + usernameSnapshot.docs;
    final uniqueDocs = {for (var doc in allDocs) doc.id: doc}.values.toList();

    return uniqueDocs;
  }

  Future<void> addFriend(String currentUserId, String friendUserId) async {
    DocumentReference currentUserDoc = _firestore.collection('Users').doc(currentUserId);
    DocumentReference friendDoc = _firestore.collection('Users').doc(friendUserId);

    await currentUserDoc.collection('myfriends').doc(friendUserId).set({
      'friendRef': friendDoc,
      'addedAt': FieldValue.serverTimestamp(),
    });

    await friendDoc.collection('myfriends').doc(currentUserId).set({
      'friendRef': currentUserDoc,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
}
