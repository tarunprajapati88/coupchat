import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return const HomePage();
          }
          else {
            return const LoginPage();
          }
        },
    );
  }
}
