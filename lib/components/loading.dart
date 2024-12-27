import 'package:coupchat/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading  extends StatelessWidget {
  Loading ({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return LoadingAnimationWidget.flickr(size: 40, leftDotColor: themeColors[0], rightDotColor: themeColors[6]);
  }
}
