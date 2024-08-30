import 'package:flutter/material.dart';

import '../components/login_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginButton(name: 'Log Out',),
        ],
      ),
    );
  }
}
