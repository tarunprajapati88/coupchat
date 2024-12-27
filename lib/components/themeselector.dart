import 'package:coupchat/components/themes.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChangeThemeWidget extends StatefulWidget {
  final Function(int) onThemeSelected;

  const ChangeThemeWidget({Key? key, required this.onThemeSelected}) : super(key: key);

  @override
  State<ChangeThemeWidget> createState() => _ChangeThemeWidgetState();
}

class _ChangeThemeWidgetState extends State<ChangeThemeWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);

    final List<Color> themeOptionColors = [
      Colors.grey,
      Colors.brown,
      Colors.black87,
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.green.shade700,
      Colors.deepPurple,
      Color.fromARGB(255, 0, 28, 24),
      Color.fromARGB(255, 255, 87, 51),
      Color.fromARGB(255, 102, 34, 17),
    ];
    final List<Color> themeOptionColors2 = [
      Colors.grey.shade100,
      Colors.brown.shade200,
      Colors.grey.shade400,
      Colors.pink.shade100,
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.deepPurple.shade100,
      Color.fromARGB(255, 220, 240, 230),
      Color.fromARGB(255, 255, 235, 215),
      Color.fromARGB(255, 224, 192, 144),
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themeColors[3],
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.dark_mode_outlined, color: themeColors[7]),
                  SizedBox(width: 10),
                  Text(
                    'CHANGE THEME',
                    style: TextStyle(fontFamily: 'PlaywriteCU', color: themeColors[7]),
                  ),
                ],
              ),
              if (isExpanded)
                Container(
                  height: 300, // Set a maximum height here
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: 10, // Number of items
                    itemBuilder: (context, index) {
                      final themeNames = [
                        "Main Theme",
                        "Brownie",
                        "Blackiee",
                        "Birdiess",
                        'Blues',
                        'Olieee',
                        'BTS army',
                        'BritishRacingGreen',
                        'Bestiee',
                        'Beige'
                      ];
                      return GestureDetector(
                        onTap: () {
                          widget.onThemeSelected(index);
                          ThemeManager.saveThemeIndex(index);
                          setState(() {
                            ThemeManager.currentThemeIndex = index;
                            isExpanded = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const MyApp(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                                (route) => false,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: themeOptionColors2[index],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: themeOptionColors[index],
                              ),
                              const SizedBox(width: 10),
                              Text(
                                themeNames[index],
                                style: TextStyle(fontSize: 14, color: Colors.black38),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
