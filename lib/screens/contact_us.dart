import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/models/models_exports.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController message = TextEditingController();

  validation(UserModel user) async {
    if (message.text.isEmpty) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Please Fill Message'),
          backgroundColor: Color(0xff746bc9),
        ),
      );
    } else {
      contactUsRef.doc(auth!.email).set({
        'username': user.username,
        'email': user.email,
        'message': message.text,
      });
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  Widget _buildSingleField({required String startText}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              startText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerDetailsPart(UserModel user) {
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleField(
            startText: user.username,
          ),
          _buildSingleField(
            startText: user.email,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xfff8f8f8),
        title: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff746bc9),
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: StreamBuilder(
          stream: userRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            UserModel user = UserModel.fromDocument(
                snapshot.data as DocumentSnapshot<Object?>);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              height: 600,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Send Us Your Message',
                    style: TextStyle(
                      color: Color(0xff746bc9),
                      fontSize: 28,
                    ),
                  ),
                  _buildContainerDetailsPart(user),
                  Container(
                    height: 200,
                    child: TextFormField(
                      controller: message,
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Message',
                      ),
                    ),
                  ),
                  MyButton(
                    text: 'Submit',
                    onTap: () {
                      validation(user);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
