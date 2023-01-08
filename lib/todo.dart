import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addnote.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final fb = FirebaseDatabase.instance;
  var l;
  var g;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => addnote(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Todos',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Are you want to Logout?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.remove("email");
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                  return const MyHomePage();
                                }));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text("Yes"),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text("No"),
                              ),
                            )
                          ],
                        ));
              },
              child: const Icon(
                Icons.exit_to_app,
                size: 40,
                semanticLabel: "Logout",
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: FirebaseAnimatedList(
          query: ref,
          shrinkWrap: true,
          itemBuilder: (context, snapshot, animation, index) {
            var v = snapshot.value.toString();

            g = v.replaceAll(RegExp("{|}|subtitle: |title: "), "");

            g.trim();

            l = g.split(',');
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                    "Are yrou sure do you want to delete?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      ref.child(snapshot.key!).remove();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Todo()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("Yes"),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("No"),
                                    ),
                                  )
                                ],
                              ));
                    },
                  ),
                  title: Text(
                    l[2],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    l[1],
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
