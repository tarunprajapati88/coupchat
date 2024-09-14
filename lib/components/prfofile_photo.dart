import 'package:flutter/cupertino.dart';

class PrfofilePhoto extends StatelessWidget {
  final Widget? image;
  final double height;
  final double weight;
  const PrfofilePhoto({super.key
  , required this.image, required this.height, required this.weight
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100)
      ),
      height: height ,
      width: weight,
      child: ClipOval(
        child: image,
      ),
    );
  }
}
