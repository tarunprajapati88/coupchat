
import 'dart:io';

import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
 final Image? image;
  final void Function()? onTap;
  const Usertile({super.key,
  required this.text,
    required this.onTap,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    final tilelen = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
        child: Container(
          height: tilelen/10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(100)
                   ),
                  height:  tilelen/12,
                  width: tilelen/12,
                  child: ClipOval(
                    child: image,
                  ),
                  ),
                ),

              const SizedBox(width:
                20,),
              Text(text,
              style: TextStyle(fontSize:
              18,
              fontWeight: FontWeight.w400),

              )
            ],
          ),
        ),
      ),
    );
  }
}
