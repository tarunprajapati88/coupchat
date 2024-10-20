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
      decoration: BoxDecoration(
          color: Colors.grey[400],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child:  Center(child: Text( name,style: const TextStyle(
        fontSize: 15,
        fontWeight:FontWeight.w500 ,
      ),)),
    );
  }
}
