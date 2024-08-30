import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
   final String  name;

  const LoginButton({super.key,
  required this.name,

  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(

      width: screenWidth,
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.greenAccent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        /*  border: Border(
            right: BorderSide(color: Colors.black),
            top: BorderSide(color: Colors.black),
            left:  BorderSide(color: Colors.black),
            bottom:  BorderSide(color: Colors.black),
          )*/
      ),

      child:  Center(child: Text( name,style: const TextStyle(
        fontSize: 15,
        fontWeight:FontWeight.w500 ,
      ),)),
    );
  }
}
