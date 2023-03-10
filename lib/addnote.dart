import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/modal/my_modal.dart';
import 'package:my_todo/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addnote extends StatelessWidget {
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final fb = FirebaseDatabase.instance;
   FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child(firebaseAuth.currentUser!.uid);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Add Todos"),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Todo()));
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: title,
                        decoration: const InputDecoration(
                          hintText: 'title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is empty";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: subtitle,
                        decoration: const InputDecoration(
                          hintText: 'subtitle',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is empty";
                          }
                          return null;
                        },
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                  final uid = firebaseAuth.currentUser!.uid;
                  // print(uid);
                  // SharedPreferences pref =
                  //     await SharedPreferences.getInstance();
                  // pref.setString("email", title.text);
                  UserData send = UserData(
                      title: title.text, subtitle: subtitle.text, uid: uid);
                  ref.push().set(send.toJson()).asStream();
                  //  ref.push().set(uid).asStream();

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Todo()));
                }
              },
              child: const Text(
                "save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
