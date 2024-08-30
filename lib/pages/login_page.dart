import 'package:flutter/material.dart';

import '../components/login_button.dart';
import '../components/signup_button.dart';
import '../components/textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(13.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CoupChat',
              style: TextStyle(
                fontFamily: 'PlaywriteCU',
                fontSize: 40,
                color: Colors.black,

              ),),
              SizedBox(
                height: 70,
              ),
              Text('Welcome back,login to continue',
                style: TextStyle(
                  fontFamily: 'PlaywriteCU',
                  fontSize: 17,
                  color: Colors.black,

                ),),
              SizedBox(
                height: 10,
              ),
              MyTextfield(icon: Icon(Icons.email_outlined), name: 'Email', obst: false,),
              SizedBox(
                height: 10,
              ),
              MyTextfield(icon: Icon(Icons.lock_outline_rounded), name: 'Password', obst: true,),
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text('Forgot Password?',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500
                    ),),
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),
              LoginButton(name: 'LOGIN',),
              SizedBox(
                height: 7,
              ),
              SignupButton(name: 'Create a new account',)
            ],
            ),
          ),
        ),
      ),
    );
  }
}
