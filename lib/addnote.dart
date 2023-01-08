import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addnote extends StatelessWidget {
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Add Todos"),
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_)=>const Todo()));
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: Container(
          child: Column(
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
                    {
                      ref.push().set({
                        "title": title.text,
                        "subtitle": subtitle.text,
                        "uid": uid
                      }).asStream();
                      //  ref.push().set(uid).asStream();

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const Todo()));
                    }
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
      ),
    );
  }
}
