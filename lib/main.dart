
import 'package:coupchat/firebase_options.dart';

import 'package:coupchat/pages/home_page.dart';
import 'package:coupchat/pages/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/authgate.dart';

void main()async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
         '/': (context) => const Authgate() ,
        '/second': (context) => const SignupPage() ,
        '/home': (context) => HomePage() ,

      },
    );
  }
}



