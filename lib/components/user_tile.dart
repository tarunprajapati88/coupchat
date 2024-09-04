import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const Usertile({super.key,
  required this.text,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          
        ),
        child: Row(
          children: [
            Icon(Icons.person),
            Text(text)
          ],
        ),
      ),
    );
  }
}
