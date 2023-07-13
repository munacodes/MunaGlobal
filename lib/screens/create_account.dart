import 'package:flutter/material.dart';
import 'package:muna_global/dialog_box/dialog_box_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? username;

  submit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      Navigator.pop(context, username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: header(context, titleText: 'Set up your profile'),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Create a username',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (val) {
                          if (val!.trim().length < 3 || val.isEmpty) {
                            const ErrorAlertDialog(
                              message: 'Username too short',
                            );
                          } else if (val.trim().length > 12) {
                            const ErrorAlertDialog(
                              message: 'Username too long',
                            );
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 3 characters"),
                      ),
                    ),
                  ),
                ),
                MyButton(
                  onTap: () {
                    submit();
                  },
                  text: 'Submit',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
