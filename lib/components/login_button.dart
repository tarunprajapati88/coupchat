import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
   final String  name;
   final Color color;
  const LoginButton({super.key,
  required this.name, required this.color
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: 50,
      decoration: BoxDecoration(
          color:color ,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child:  Center(child: Text( name,style: const TextStyle(
        fontSize: 15,
        fontWeight:FontWeight.w500 ,
          fontFamily: 'PlaywriteCU'
      ),)),
    );
  }
}
