import 'package:flutter/material.dart';

import '../components/textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextfield(),
            SizedBox(
              height: 10,
            ),
            MyTextfield(),
          ],
          ),
        ),
      ),
    );
  }
}
