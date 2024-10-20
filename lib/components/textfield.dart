import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final Icon icon;
  final String name;
  final bool obst;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final FocusNode? focusNode2;
  const MyTextfield({super.key,
  required  this.icon,
    required this.name,
    required this.obst,
    required this.controller,
    this.focusNode,
    required this.focusNode2
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
        fillColor: Colors.grey.shade100,
        hintText: name,
        prefixIcon: icon,
        prefixIconColor: Colors.grey,
        enabledBorder: const OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2
          ),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        )
      ),
      obscureText: obst,
      controller:controller ,
      focusNode:focusNode ,
      onSubmitted: (_){
        focusNode2?.requestFocus();
      },
    );
  }
}
