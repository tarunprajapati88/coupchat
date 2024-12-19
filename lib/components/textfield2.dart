import 'package:flutter/material.dart';

class MyTextfield2 extends StatelessWidget {
  final Icon icon;
  final String name;
  final bool obst;

  final TextEditingController controller;

  const MyTextfield2({super.key,
    required  this.icon,
    required this.name,
    required this.obst,
    required this.controller,

  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintStyle: const TextStyle(
              fontFamily: 'PlaywriteCU',
              color: Colors.grey
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey.shade50,
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
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          )
      ),
      obscureText: obst,
      controller:controller,
    );
  }
}
