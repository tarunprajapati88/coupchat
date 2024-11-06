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
  final TextEditingController _controller = TextEditingController();
  String? searchQuery;
  final FirebaseAuth _auth=FirebaseAuth.instance;
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
                    searchQuery = value.trim();
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius:  BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2
                    ),
                  ),
                  focusedBorder:OutlineInputBorder(
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
                  : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('uniqueUsername', isGreaterThanOrEqualTo: searchQuery)
                    .where('uniqueUsername', isLessThan: searchQuery! + '\uf8ff')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(
                      color: Colors.grey,
                    ));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }
                  final userDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: userDocs.length,
                    itemBuilder: (context, index) {
                      final userData = userDocs[index];

                      if(userData['email']!=_auth.currentUser!.email){
                      return SearchUserTile(text: userData['uniqueUsername'], image:
                      ProfileImage(imageUrl: userData['imageurl']), onTap: () {
                        Navigator.push(context,MaterialPageRoute(
                            builder: (context)=>ChatRoom(
                              senderID: userData['email'],
                              reciverID: userData['uid'],
                              Username: userData['username'],
                              image:   ProfileImage(imageUrl: userData['imageurl']),

                            )) );
                      }, name: userData['username'],);}
                      return null;
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
}
