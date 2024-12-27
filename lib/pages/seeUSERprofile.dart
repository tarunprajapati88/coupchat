import 'package:flutter/material.dart';
import '../components/prfofile_photo.dart';
import '../components/themes.dart';

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
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return  Scaffold(
      backgroundColor:themeColors[1],
      appBar: AppBar(
        iconTheme: IconThemeData(color: themeColors[6]),
        title:  Text('User Profile',
        style: TextStyle(fontFamily: 'PlaywriteCU',color: themeColors[6]),),
        backgroundColor:themeColors[0],),
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
                  Text("@"+uniquename,style:  TextStyle( fontFamily: 'PlaywriteCU',color: themeColors[6]),),
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
