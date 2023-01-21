import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/main.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {


  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future _forgetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Type Your Email here to Reset Password",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: password,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Field is Empty";
                    }
                    return null;
                  }),
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                    onPressed: (() async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await _forgetPassword(email: password.text);
                        print("send.....");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: ((_) {
                          return const MyHomePage();
                        })));
                        password.text.isEmpty;
                      }
                    }),
                    icon: const Icon(Icons.email),
                    label: const Text(
                      "Send",
                      style: TextStyle(backgroundColor: Colors.red),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
