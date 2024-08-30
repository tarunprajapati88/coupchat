import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../components/login_button.dart';
import '../components/signup_button.dart';
import '../components/textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
 // final void Function()? onTap;
   LoginPage({super.key,
 //  required this.onTap
   });
 void login(BuildContext context) async{
   final authService =AuthService();
   try{
     await authService.signInWithEmailPass(_emailcontroller.text, _passwordcontroller.text);
     Navigator.pushNamed(context, '/home');
   }
   catch(e){
         showDialog(
             context: context,
              builder:(context)=>  AlertDialog(
       title: Text(e.toString()),
     ),
         );

   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('CoupChat',
              style: TextStyle(
                fontFamily: 'PlaywriteCU',
                fontSize: 40,
                color: Colors.black,

              ),),
              const SizedBox(
                height: 70,
              ),
              const Text('Welcome back,login to continue',
                style: TextStyle(
                  fontFamily: 'PlaywriteCU',
                  fontSize: 17,
                  color: Colors.black,

                ),),
              const SizedBox(
                height: 10,
              ),
              MyTextfield(icon: const Icon(Icons.email_outlined), name: 'Email', obst: false, controller: _emailcontroller,),
              const SizedBox(
                height: 10,
              ),
              MyTextfield(icon: const Icon(Icons.lock_outline_rounded), name: 'Password', obst: true, controller: _passwordcontroller,),
              const SizedBox(
                height: 7,
              ),
              const Row(
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
              const SizedBox(
                height: 7,
              ),
              GestureDetector(child: const LoginButton(name: 'LOGIN',),
              onTap:()=> login(context),
              ),
              const SizedBox(
                height: 7,
              ),
              const SignupButton(name: 'Create a new account',)
            ],
            ),
          ),
        ),
      ),
    );
  }
}
