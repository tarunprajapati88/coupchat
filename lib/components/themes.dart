import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static int currentThemeIndex = 0;
  static List<Color> mainThemeColors = [
    // 0 AppBar background
    Colors.white, // Lighter background for the app bar

    // 1 Scaffold background
    Colors.grey.shade100, // Softer, more neutral background

    // 2 Drawer background
    Colors.grey.shade100, // Slightly darker to create contrast

    // 3 User tile background
    Colors.white, // Clean and fresh look

    // 4 Bottom navigation bar background
    Colors.grey.shade200, // Subtle, consistent background

    // 5 Bottom navigation selected icon color
    Colors.grey.shade500, // Darker shade for better contrast

    // 6 AppBar text color
    Colors.black87, // Slightly softer black for better readability

    // 7 User tile title text
    Colors.black, // Rich black for strong readability

    // 8 Last message timestamp color
    Colors.grey.shade500, // Muted gray for subtle contrast

    // 9 Sender container background
    Colors.grey.shade200, // Soft background for readability

    // 10 Current user container
    Colors.grey.shade300, // Lighter for contrast with sender

    // 11 Current user text
    Colors.black87, // Softer black for consistency

    // 12 Sender text color
    Colors.black87, // Rich black for readability

    // 13 Seen message indicator
    Colors.brown.shade700, // Rich brown for better contrast

    // 14 Text field background
    Colors.grey.shade200, // Subtle gray background

    // 15 Text field items
    Colors.grey.shade700, // Darker gray for input fields

    // 16 Login page text
    Colors.black87, // Darker black for strong readability
  ];


  static List<Color> alternateTheme1 = [
    Colors.brown.shade400,      // Richer brown for deeper contrast
    Colors.brown.shade200,      // Balanced lighter brown
    Colors.brown.shade300,      // Mid-tone brown for depth
    Colors.brown.shade100,      // Softest brown for lighter backgrounds
    Colors.brown.shade300,      // Maintaining consistency
    Colors.brown.shade400,      // Darker shade for selected areas
    Colors.black87,             // Softer black for readability
    Colors.black87,             // Consistent black for strong text contrast
    Colors.grey.shade700,       // Darker grey for better contrast
    Colors.brown.shade400,      // Bold brown for icon and selected areas
    Colors.brown.shade100,      // Subtle brown for form fields or details
    Colors.black54,             // Softer black for less prominent text
    Colors.white,               // Clean white for backgrounds
    Colors.brown.shade600,      // Richer brown for highlights
    Colors.white,               // Consistent white background
    Colors.grey.shade600,       // Subtle grey for input fields
    Colors.black87              // Clear black for headings
  ];


  static List<Color> darkThemeColors = [
    // 0 appbar
    Colors.black,

    // 1 scaffold background
    Colors.grey.shade900,

    // 2 drawer background
    Colors.grey.shade800,

    // 3 user tile
    Colors.grey.shade700,

    // 4 bottom navigation bar
    Colors.grey.shade800,

    // 5 bottom navigation selected color
    Colors.grey.shade600,

    // 6 appbar text
    Colors.white,

    // 7 user tile title text
    Colors.white,

    // 8 last message time tick
    Colors.grey.shade400,

    // 9 sender container
    Colors.grey.shade800,

    // 10 current user container
    Colors.grey.shade600,

    // 11 current user text
    Colors.white,

    // 12 sender text color
    Colors.white,

    // 13 seen message
    Colors.greenAccent,

    // 14 text field background
    Colors.grey.shade800,

    // 15 text fields items
    Colors.grey.shade500,

    // 16 login page text
    Colors.white,
  ];


  static List<Color> alternateTheme3 = [
    // 0 AppBar background
    Colors.pink.shade200,

    // 1 Scaffold background
    Colors.pink.shade100,

    // 2 Drawer background
    Colors.pink.shade100,

    // 3 User tile background
    Colors.pink.shade50,

    // 4 Bottom navigation bar background
    Colors.pink.shade100,

    // 5 Bottom navigation selected item color
    Colors.pink.shade200,

    // 6 AppBar text
    Colors.black,

    // 7 User tile title text
    Colors.black,

    // 8 Last message time and tick color
    Colors.pink.shade300,

    // 9 Sender container background
    Colors.white,

    // 10 Current user container background
    Colors.pink.shade50,


    // 11 Current user text
    Colors.black,

    // 12 Sender text color
    Colors.black,

    // 13 Seen message tick color
    Colors.pink.shade300,

    // 14 Text field background
    Colors.white,

    // 15 Text field items
    Colors.grey.shade500,

    // 16 Login page text
    Colors.black,
  ];

  static List<Color> alternateTheme4 = [
    // 0 AppBar background
    Colors.lightBlue.shade200,

    // 1 Scaffold background
    Colors.lightBlue.shade100,

    // 2 Drawer background
    Colors.lightBlue.shade100,

    // 3 User tile background
    Colors.blue.shade50,

    // 4 Bottom navigation bar background
    Colors.lightBlue.shade100,

    // 5 Bottom navigation selected item color
    Colors.lightBlue.shade300,

    // 6 AppBar text
    Colors.black,

    // 7 User tile title text
    Colors.black,

    // 8 Last message time and tick color
    Colors.lightBlue.shade400,

    // 9 Sender container background
    Colors.white,

    // 10 Current user container background
    Colors.lightBlue.shade50,

    // 11 Current user text
    Colors.black,

    // 12 Sender text color
    Colors.black,

    // 13 Seen message tick color
    Colors.lightBlue.shade400,

    // 14 Text field background
    Colors.white,

    // 15 Text field items
    Colors.grey.shade500,

    // 16 Login page text
    Colors.black,
  ];
  static List<Color> oliveGreenThemeColors = [
    Colors.green.shade500,  // 0: AppBar
    Colors.green.shade100,  // 1: Scaffold background
    Colors.green.shade200,  // 2: Drawer background
    Colors.green.shade50,   // 3: User tile
    Colors.green.shade200,  // 4: Bottom navigation bar
    Colors.green.shade300,  // 5: Bottom navigation selected color
    Colors.black87,         // 6: AppBar text
    Colors.black87,         // 7: User tile title text
    Colors.green.shade600,  // 8: Last message time tick
    Colors.green.shade300,   // 9: Sender container
    Colors.green.shade50,  // 10: Current user container
    Colors.black,           // 11: Current user text
    Colors.black,           // 12: Sender text color
    Colors.green.shade800,  // 13: Seen message
    Colors.green.shade50,   // 14: Text field background
    Colors.green.shade600,  // 15: Text field items
    Colors.black87,         // 16: Login page text
  ];

  static List<Color> purpleBTSThemeColors = [
    Colors.deepPurple.shade400,  // 0: AppBar
    Colors.deepPurple.shade100,   // 1: Scaffold background
    Colors.deepPurple.shade100,  // 2: Drawer background
    Colors.deepPurple.shade50,   // 3: User tile
    Colors.deepPurple.shade100,  // 4: Bottom navigation bar
    Colors.deepPurple.shade300,  // 5: Bottom navigation selected color
    Colors.black,                // 6: AppBar text
    Colors.black,  // 7: User tile title text
    Colors.deepPurple.shade400,  // 8: Last message time tick
    Colors.deepPurple.shade200,   // 9: Sender container
    Colors.deepPurple.shade50,  // 10: Current user container
    Colors.black,                // 11: Current user text
    Colors.white,  // 12: Sender text color
    Colors.purple.shade800,      // 13: Seen message
    Colors.deepPurple.shade50,   // 14: Text field background
    Colors.grey,  // 15: Text field items
    Colors.deepPurple.shade900,  // 16: Login page text
  ];
  static List<Color> britishRacingGreenDarkThemeColors = [
    Color.fromARGB(255, 0, 28, 24),  // 0: AppBar (deep British racing green)
    Color.fromARGB(255, 2, 20, 18),  // 1: Scaffold background (almost black-green)
    Color.fromARGB(255, 0, 36, 31),  // 2: Drawer background (dark racing green)
    Color.fromARGB(255, 7, 61, 52) ,  // 3: User tile (deep forest green)
    Color.fromARGB(255, 0, 36, 31),  // 4: Bottom navigation bar (dark racing green)
    Color.fromARGB(255, 8, 66, 56),  // 5: Bottom navigation selected color (brighter racing green)
    Color.fromARGB(255, 214, 233, 220), // 6: AppBar text (light muted green-gray)
    Color.fromARGB(255, 220, 240, 230), // 7: User tile title text (off-white greenish)
    Color.fromARGB(255, 16, 85, 73),    // 8: Last message time tick (medium racing green)
    Color.fromARGB(255, 2, 41, 35),     // 9: Sender container (dark green)
    Color.fromARGB(255, 3, 55, 47),     // 10: Current user container (deep green)
    Color.fromARGB(255, 220, 240, 230), // 11: Current user text (off-white greenish)
    Color.fromARGB(255, 220, 240, 230), // 12: Sender text color (off-white greenish)
    Color.fromARGB(255, 34, 153, 129) // Brighter shade of teal-green
    ,
    Color.fromARGB(255, 2, 41, 35),     // 14: Text field background (dark green)
    Colors.grey,     // 15: Text field items (muted bright green)
    Color.fromARGB(255, 200, 220, 210), // 16: Login page text (soft muted greenish-white)
  ];

  static List<Color> redOrangeThemeColors = [
    Color.fromARGB(255, 255, 87, 51),  // 0: AppBar (vibrant red-orange)
    Color.fromARGB(255, 255, 235, 215), // 1: Scaffold background (soft peach)
    Color.fromARGB(255, 255, 204, 153), // 2: Drawer background (light orange)
    Color.fromARGB(255, 255, 255, 240), // 3: User tile (light cream)
    Color.fromARGB(255, 255, 153, 102), // 4: Bottom navigation bar (medium orange)
    Color.fromARGB(255, 255, 87, 51),   // 5: Bottom navigation selected color (bright red-orange)
    Color.fromARGB(255, 102, 34, 17),   // 6: AppBar text (dark brown)
    Color.fromARGB(255, 153, 51, 0),    // 7: User tile title text (dark burnt orange)
    Color.fromARGB(255, 255, 153, 102), // 8: Last message time tick (medium orange)
    Color.fromARGB(255, 255, 87, 51), // 9: Sender container (light orange)
    Color.fromARGB(255, 255, 204, 153) ,   // 10: Current user container (bright red-orange)
    Color.fromARGB(255, 102, 34, 17),   // 11: Current user text (dark brown)
   Colors.white                    ,    // 12: Sender text color (dark burnt orange)
    Color.fromARGB(255, 204, 68, 34),   // 13: Seen message (medium red-brown)
    Color.fromARGB(255, 255, 235, 215), // 14: Text field background (soft peach)
    Color.fromARGB(255, 204, 85, 51),   // 15: Text field items (reddish-brown)
    Color.fromARGB(255, 102, 34, 17),   // 16: Login page text (dark brown)
  ];

  static List<Color> beigeBrownThemeColors = [
    Color.fromARGB(255, 245, 245, 240), // 0: AppBar (light beige)
    Color.fromARGB(255, 240, 220, 200), // 1: Scaffold background (beige)
    Color.fromARGB(255, 224, 192, 144), // 2: Drawer background (soft brown-beige)
    Color.fromARGB(255, 255, 255, 240), // 3: User tile (light cream)
    Color.fromARGB(255, 178, 109, 59),   // 4: Bottom navigation bar (dark brown)
    Color.fromARGB(255, 255, 239, 204), // 5: Bottom navigation selected color (beige-orange)
    Color.fromARGB(255, 102, 34, 17),   // 6: AppBar text (dark brown)
    Color.fromARGB(255, 153, 101, 34),  // 7: User tile title text (dark burnt brown-orange)
    Color.fromARGB(255, 240, 200, 150), // 8: Last message time tick (beige-brown)
    Color.fromARGB(255, 255, 204, 153), // 9: Sender container (light beige)
    Color.fromARGB(255, 139, 69, 19), // 10: Current user container (beige-brown)
    Colors.white,   // 11: Current user text (dark brown)
    Color.fromARGB(255, 102, 34, 17),                       // 12: Sender text color (light beige)
    Color.fromARGB(255, 255, 153, 102),    // 13: Seen message (brownish-orange)
    Color.fromARGB(255, 240, 220, 200), // 14: Text field background (beige)
    Color.fromARGB(255, 153, 101, 34),  // 15: Text field items (beige-brown)
    Color.fromARGB(255, 102, 34, 17),   // 16: Login page text (dark brown)
  ];
  static Future<void> loadThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    currentThemeIndex = prefs.getInt('themeIndex') ?? 0;
  }

  static Future<void> saveThemeIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeIndex', index);
    currentThemeIndex = index;
  }


  static List<Color> getThemeColors(int index) {
    switch (index) {
      case 0:
        return mainThemeColors;
      case 1:
        return alternateTheme1;
      case 2:
        return darkThemeColors;
      case 3:
        return alternateTheme3;
      case 4:
        return alternateTheme4;
      case 5:
        return oliveGreenThemeColors;
      case 6:
        return purpleBTSThemeColors;
      case 7:
        return britishRacingGreenDarkThemeColors;
      case 8:
        return redOrangeThemeColors;
      case 9:
        return beigeBrownThemeColors;
      default:
        return mainThemeColors;
    }
  }
}