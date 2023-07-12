import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muna_global/authentication/auththentication_exports.dart';
import 'package:muna_global/dialog_box/dialog_box_exports.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Invaild Email Strings/Letters
  static String p =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(p);

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  File? _imageFile;
  String photoUrl = '';

  selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Photo'),
          children: [
            SimpleDialogOption(
              onPressed: handleTakePhoto,
              child: const Text('From Camera'),
            ),
            SimpleDialogOption(
              onPressed: handleChooseFromGallery,
              child: const Text('From Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  Future<void> signUserIn() async {
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorAlertDialog(message: 'Please Select an Image');
        },
      );
    } else {
      password.text == confirmPassword.text
          ? email.text.isNotEmpty &&
                  password.text.isNotEmpty &&
                  confirmPassword.text.isNotEmpty &&
                  username.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog('Please fill up the Registration Complete form')
          : displayDialog('Password do not match');
    }
  }

  displayDialog(String msg) {
    showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(message: msg);
      },
    );
  }

  uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
          message: 'Registering, Please wait....',
        );
      },
    );
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask storageUploadTask = storageReference.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      photoUrl = urlImage;

      _registerUser();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    )
        .then((auth) {
      user = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (contex) {
          return ErrorAlertDialog(message: error.message.toString());
        },
      );
    });
    if (user != null) {
      saveUserInfoToFireStore(user!).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => const HomePage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User user) async {
    userRef.doc(user.uid).set({
      'username': username.text,
      'uid': user.uid,
      'email': email.text,
      'photoUrl': photoUrl,
    });
  }

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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: selectImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          _imageFile == null ? null : FileImage(_imageFile!),
                      child: _imageFile == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 100.0,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  // logo
                  // const Icon(
                  //   Icons.lock,
                  //   size: 100,
                  //   color: Colors.blue,
                  // ),
                  const SizedBox(height: 30),

                  // Welcome back
                  Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  MyTextField(
                    controller: username,
                    hintText: 'Username',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

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

                  MyTextField(
                    controller: confirmPassword,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                    text: 'Sign Up',
                  ),

                  const SizedBox(height: 20),

                  // not a member register now

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
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
