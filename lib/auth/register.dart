import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  final String? userId;
  const Register({
    super.key,
    required this.onTap,
    this.userId,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final DateTime timestamp = DateTime.now();

  void signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure password match
    if (_usernameController.text.isEmpty) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      displayMessage('Username required');
    } else if (_usernameController.text.length < 5) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      displayMessage('username too short');
    } else if (_emailController.text.isEmpty) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      displayMessage('Email required');
    } else if (_passwordController.text.isEmpty) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      displayMessage('Password required');
    } else if (_passwordController.text.length < 6) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      displayMessage('Password too short');
    } else if (_confirmPasswordController.text.isEmpty) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      displayMessage('Please confirm your password');
    } else if (_passwordController.text != _confirmPasswordController.text) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      // display error message
      displayMessage('Password don\'t match');
      return;
    }

    // try creating the user
    try {
      // create the user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // after creating the user, create a new document in cloud firestore called Users

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'UserName': _usernameController.text,
        'UserEmail': userCredential.user!.email,
        'Bio': 'Empty bio...',
        "UserUid": userCredential.user!.uid,
        "PhotoUrl": userCredential.user!.photoURL,
        "TimeStamp": timestamp,
      });

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      // display error message
      displayMessage(e.code);
    }
  }

  // display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 50),

                  // welcome back message
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: _usernameController,
                    hintText: 'UserName',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // email textfield
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  MyTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // sign in button
                  MyButton(
                    onTap: signUp,
                    text: 'Sign Up',
                  ),
                  const SizedBox(height: 25),

                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
