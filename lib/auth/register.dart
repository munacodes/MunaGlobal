import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final DateTime timestamp = DateTime.now();

  final usersCollection = FirebaseFirestore.instance.collection('Users');

  void signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure password match
    if (_passwordController.text != _confirmPasswordController.text) {
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

      usersCollection.doc(userCredential.user!.email).set({
        // Using split '@'[0] tells it to split the email where
        //there is '@' which is index [0] and use it as a username
        'userName': _emailController.text.split('@')[0], // initial username
        'userEmail': userCredential.user!.email,
        'bio': 'Empty bio...', // initially empty bio
        "id": userCredential.user!.uid,
        "photoUrl": userCredential.user!.photoURL,
        "displayName": userCredential.user!.email!.split('@')[0],
        "timestamp": timestamp,
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
