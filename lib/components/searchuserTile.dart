import 'package:coupchat/components/prfofile_photo.dart';
import 'package:flutter/material.dart';

class SearchUserTile extends StatelessWidget {
  final String text;
  final String name;
  final Widget? image;
  final void Function()? onTap;
  const SearchUserTile({super.key,
    required this.text,
    required this.onTap,
    required this.image,
    required this.name
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
                  child:PrfofilePhoto(image: image, height: tilelen/14, weight: tilelen/14,)
              ),
              const SizedBox(width:
              20,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text,
                    style: const TextStyle(fontSize:
                    18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(name)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
