import 'package:coupchat/pages/fcmToken.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../components/loading.dart';
import '../components/login_button.dart';
import '../components/signup_button.dart';
import '../components/textfield.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 final FocusNode _focusNode1=FocusNode();
  final FocusNode _focusNode2=FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
 
  Future<void> login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final authService = AuthService();
    try {
      await authService.signInWithEmailPass(_emailController.text, _passwordController.text);
      await FCM.updateFcmTokenInFirestore(true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  const HomePage()),
            (Route<dynamic> route) => false,
      );

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString(),
          style: const TextStyle(

            fontSize: 15,
          ),),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          'linq',
                          style: TextStyle(
                            fontFamily: 'PlaywriteCU',
                            fontSize: 50,
                            color: Colors.black,
                          ),
                        ),

                        Column(
                          children: [
                            Icon(Icons.message_outlined,size: 40,),
                            SizedBox(height: 30,)
                          ],
                        ),

                      ],
                    ),
                    const SizedBox(height: 70),
                    const Text(
                      'Welcome back, login to continue',
                      style: TextStyle(
                        fontFamily: 'PlaywriteCU',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextfield(
                      focusNode: _focusNode1,
                      icon: const Icon(Icons.email_outlined),
                      name: 'Email',
                      obst: false,
                      controller: _emailController, focusNode2: _focusNode2,
                    ),
                    const SizedBox(height: 10),
                    MyTextfield(
                      focusNode: _focusNode2,
                      icon: const Icon(Icons.lock_outline_rounded),
                      name: 'Password',
                      obst: true,
                      controller: _passwordController, focusNode2: _focusNode2, 
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                                fontFamily: 'PlaywriteCU'
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    GestureDetector(
                      child:  LoginButton(name: 'LOGIN', color: Colors.grey.shade400,),
                      onTap: () => login(context),
                    ),
                    const SizedBox(height: 7),
                    const SignupButton(name: 'Create a new account'),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            IgnorePointer(
              ignoring: !_isLoading,
              child:  Center(
                child:Loading(),
              ),
            ),
        ],
      ),
    );
  }
}
