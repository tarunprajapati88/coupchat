import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/components/prfofile_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/edit_profile.dart';
import '../pages/login_page.dart';


class Homedrawer extends StatelessWidget {
final Widget? image;
final DocumentReference documentrefrence;
  const Homedrawer({super.key,
     required this.image,
    required this.documentrefrence
  });

  @override
  Widget build(BuildContext context) {
    final tilelen = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding: const  EdgeInsets.fromLTRB(15, 60, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Container(child: Column(
             children: [
               PrfofilePhoto(image:image , weight: tilelen/3, height: tilelen/3,),
               const SizedBox(height: 20,),
               GestureDetector(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfile() ));
                 },
                 child: DecoratedBox(
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Container(
                     padding: const EdgeInsets.only(left: 10),
                     height: 60,
                     child: const
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(Icons.edit),
                         SizedBox(width: 10,),
                         Text('E D I T  P R O F I L E')
                       ],
                     ),
                   ),
                 ),
               )
             ],
           )),

            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,);
                     },
              child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 60,
                  child: const
                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10,),
                    Text('L O G O U T')
                  ],
                  ),
                ),
              ),
            )],
        ),
      ),
    );
  }
}
