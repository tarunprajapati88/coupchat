import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../components/login_button.dart';

import '../components/textfield.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();

   SignupPage({super.key});
void signup(BuildContext context) async{
    final authService =AuthService();
    if (_passwordcontroller.text != _confirmpasswordcontroller.text) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords do not match'),
        ),
      );
      return;
    }
    try{
      await authService.register(_emailcontroller.text, _passwordcontroller.text);
      Navigator.pushNamed(context, '/');
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
                const Text('Create a new account !!',
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

                MyTextfield(icon: const Icon(Icons.lock_outline_rounded), name: 'Confirm Password', obst: true, controller: _confirmpasswordcontroller,),
                const SizedBox(
                  height: 13,
                ),
                GestureDetector(child: const LoginButton(name: 'Sign Up', ),
                onTap: ()=>signup(context),
                ),
                const SizedBox(
                  height: 7,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
