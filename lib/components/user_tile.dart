import 'package:coupchat/components/prfofile_photo.dart';
import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
 final Widget? image;
 final Icon verfied;
  final void Function()? onTap;
  const Usertile({super.key,
  required this.text,
    required this.onTap,
    required this.image,
    required this.verfied
  });

  @override
  Widget build(BuildContext context) {
    final tilelen = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
        child: Container(
          height: tilelen/11,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                child:PrfofilePhoto(image: image,
                  height: tilelen/14,
                  weight: tilelen/14,)
                ),
              const SizedBox(width:
                20,),
              Text(text,
              style: const TextStyle(fontSize:
              18,
              fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 3,),
              verfied
            ],
          ),
        ),
      ),
    );
  }
}
