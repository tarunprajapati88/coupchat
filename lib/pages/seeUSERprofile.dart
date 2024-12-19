import 'package:flutter/material.dart';
import '../components/prfofile_photo.dart';

class Seeuserprofile extends StatelessWidget {
 final Widget? image;
  final String username;
  final String uniquename;
  final Row verfied;

 const Seeuserprofile({super.key,
  required this.image,
   required this.username,
   required this.uniquename,
    required this.verfied
  });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('User Profile',
        style: TextStyle(fontFamily: 'PlaywriteCU',),),
        backgroundColor: Colors.grey.shade300,),
      body: Column(
        children: [
          const SizedBox(height: 40,),
          Center(child: PrfofilePhoto(image: image, height: 220, weight: 220)),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  verfied,
                  Text("@"+uniquename,style: const TextStyle( fontFamily: 'PlaywriteCU'),),
                ],
              ),
              const SizedBox(width: 8,),

            ],
          ),

        ],
      ),
    );
  }
}
