import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/prfofile_photo.dart';

class Seeuserprofile extends StatelessWidget {
 final Widget? image;
  final String username;
  final String uniquename;

 Seeuserprofile({super.key,
  required this.image,
   required this.username,
   required this.uniquename
  });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('User Profile'),backgroundColor: Colors.grey.shade300,),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Center(child: PrfofilePhoto(image: image, height: 220, weight: 220)),
          const SizedBox(height: 20,),
          Text(username,style: const TextStyle(
            fontSize: 25
          ),),
          Text("@"+uniquename),
        ],
      ),
    );
  }
}
