import 'package:coupchat/components/prfofile_photo.dart';
import 'package:coupchat/components/themes.dart';
import 'package:flutter/material.dart';

class SearchUserTile extends StatelessWidget {
  final String text;
  final String name;
  final Widget? image;
  final Icon icon;
  final Icon Verfiedicon;
  final void Function()? onTap;
  final void Function()? onTapProfile;

  const SearchUserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.image,
    required this.name,
    required this.icon,
    required this.onTapProfile,
    required this.Verfiedicon,

  });

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    final tilelen = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      child: Container(
        height: tilelen / 11,
        decoration: BoxDecoration(
          color: themeColors[3],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTapProfile,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                      child: PrfofilePhoto(
                        image: image,
                        height: tilelen / 14,
                        weight: tilelen / 14,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              text,
                              style:  TextStyle(
                                color: themeColors[7],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                  fontFamily: 'PlaywriteCU'
                              ),
                            ),
                            const SizedBox(width: 3,),
                            Verfiedicon
                          ],
                        ),
                        Text(name,style:  TextStyle( fontFamily: 'PlaywriteCU',color: themeColors[7]),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: icon,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
