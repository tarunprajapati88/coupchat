import 'package:coupchat/components/themes.dart';
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
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return TextField(
      style: TextStyle(color: themeColors[16]),
      decoration: InputDecoration(
        hintStyle:  TextStyle(
          color: themeColors[15],
            fontFamily: 'PlaywriteCU'
        ),
        border: InputBorder.none,
       filled: true,
        fillColor:themeColors[14],
        hintText: name,
        helperStyle: const TextStyle( fontFamily: 'PlaywriteCU'),
        prefixIcon: icon,
        prefixIconColor: themeColors[15],
        enabledBorder: OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: themeColors[0],
            width: 1
          ),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color:themeColors[0]),
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
