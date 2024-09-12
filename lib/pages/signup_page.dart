import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/pages/profile%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../components/login_button.dart';
import '../components/textfield.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}
class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();
 DocumentReference documentReference =FirebaseFirestore.instance.collection('Users').doc();
  bool _isLoading = false;
  String? uid;
  String? mail;
  Future<void> signup(BuildContext context) async{
  setState(() {
    _isLoading = true;
  });
    final authService =AuthService();
    try{
      if (_passwordcontroller.text != _confirmpasswordcontroller.text) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Center(
              child: Text('Passwords do not match',
                style:  TextStyle(
                  color: Colors.grey,
                  fontSize: 20,

                ),
              ),
            ),

          ),
        );
        return;
      }
      UserCredential userCredential = await authService.register(_emailcontroller.text, _passwordcontroller.text,);
      uid = userCredential.user?.uid;
      mail= userCredential.user?.email;
      setState(() {
        _isLoading = false;
      });
      DocumentReference documentReference =FirebaseFirestore.instance.collection('Users').doc(uid);
      await  showDialog(
          context: context,
          barrierDismissible: true, // Allow dismiss by tapping outside the dialog
          builder: (BuildContext context) {
            return AlertDialog(
                title:  Icon(
                Icons.check_circle,
                color: Colors.green[100],
                size: 48.0,
                            ),
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                'Account Created',
                style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text('Continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                      ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                    ),
                  ],
                ),
              ],
            );
          }
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  ProfilePage(documerntReference: documentReference, userid: uid,)),
            (Route<dynamic> route) => false,
      );    }
    catch(e){
      showDialog(
        context: context,
        builder:(context)=>  AlertDialog(
          title: Center(
            child: Text(e.toString(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,

              ),),
          ),
        ),
      );

    }
    finally {
      setState(() {
        _isLoading = false;
      });
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
                MyTextfield(
                  icon: const Icon(Icons.email_outlined),
                  name: 'Email',
                  obst: false,
                  controller: _emailcontroller,),
                const SizedBox(
                  height: 10,
                ),
                MyTextfield(
                  icon: const Icon(Icons.lock_outline_rounded),
                  name: 'Password',
                  obst: true,
                  controller: _passwordcontroller,),
                const SizedBox(
                  height: 7,
                ),

                MyTextfield(
                  icon: const Icon(Icons.lock_outline_rounded),
                  name: 'Confirm Password',
                  obst: true,
                  controller: _confirmpasswordcontroller,),
                const SizedBox(
                  height: 13,
                ),

                GestureDetector(child: const LoginButton(name: 'Sign Up', ),
                onTap: ()=>signup(context),
                ),
                const SizedBox(
                  height: 7,
                ),
                if (_isLoading)
                   Center(
                    child: CircularProgressIndicator(
                      color: Colors.green[100],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
