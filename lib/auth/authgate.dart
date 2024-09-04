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
          // If the snapshot has user data, they're logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          // If there's no user data, they're not logged in
          else {
            return const LoginPage();
          }
        },
    );
  }
}
