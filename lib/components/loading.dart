import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading  extends StatelessWidget {
  Loading ({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.flickr(size: 40, leftDotColor: Colors.black, rightDotColor: Colors.grey);
  }
}
