import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  final String  name;
  const SignupButton({super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
         Navigator.pushNamed(context, '/second');
      },
      child: Container(
        width: screenWidth,
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border(
            right: BorderSide(color: Colors.greenAccent),
            top: BorderSide(color: Colors.greenAccent),
            left:  BorderSide(color: Colors.greenAccent),
            bottom:  BorderSide(color: Colors.greenAccent),
          )
        ),
        child:  Center(child: Text( name,style: const TextStyle(
          fontSize: 15,
          fontWeight:FontWeight.w500 ,
          color: Colors.white
        ),)),
      ),
    );
  }
}
