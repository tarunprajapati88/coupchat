import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final Icon icon;
  final String name;
  final bool obst;
  final TextEditingController controller;
  const MyTextfield({super.key,
  required  this.icon,
    required this.name,
    required this.obst,
    required this.controller
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: Colors.grey
        ),
        border: InputBorder.none,
       filled: true,
        fillColor: Colors.white12,
        hintText: name,
        prefixIcon: icon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          )
        ),
        focusedBorder:const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent)
        )
      ),
      obscureText: obst,
      controller:controller ,
    );
  }
}
