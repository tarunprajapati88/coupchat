

import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key,});
  @override
  Widget build(BuildContext context) {
    return const TextField(

      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Colors.grey
        ),
        border: InputBorder.none,
       filled: true,
        fillColor: Colors.white30,
        hintText: 'Email',
        prefixIcon: Icon(Icons.mail),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white54,
          )
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent)
        )
      ),
    );
  }
}
