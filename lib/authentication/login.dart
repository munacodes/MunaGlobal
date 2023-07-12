import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/authentication/auththentication_exports.dart';
import 'package:muna_global/dialog_box/dialog_box_exports.dart';
import 'package:muna_global/screens/home_page.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Invaild Email Strings/Letters
  static String p =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(p);

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  uploadToFirebase() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
  }

  void signUserIn() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      uploadToFirebase();
    } else {
      const ErrorAlertDialog(
          message: 'Please fill up the Registration Complete form');
    }
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        // show error to user
        ErrorAlertDialog(message: e.code);
      }
    }
  }

  // void showErrorMessage(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           message,
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 40),

                  // Welcome back
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: email,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: password,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            // color: Colors.grey[600]
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                    text: 'Sign In',
                  ),

                  const SizedBox(height: 20),

                  // not a member register now

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
