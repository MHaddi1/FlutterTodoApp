import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/main.dart';
import 'package:my_todo/modal/my_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addnote.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final fb = FirebaseDatabase.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController title = TextEditingController();
  TextEditingController subtite = TextEditingController();

  String? c = null;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child(firebaseAuth.currentUser!.uid);

    final formKey = GlobalKey<FormState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            const Center(child: CircularProgressIndicator());
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
                    builder: (ctx) => AlertDialog(
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
                            ),
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
            Map<String, dynamic> userMap =
                Map<String, dynamic>.from(snapshot.value as Map);
            // print('"Data: " ${userMap}');
            final user = UserData.fromJson(userMap);

            print(firebaseAuth.currentUser!.uid);

            try {
              {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      c = snapshot.key;
                      print(c);
                    });
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              actions: [
                                Column(
                                  children: [
                                    Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                               validator: ((value) {
                                                if (value!.isEmpty) {
                                                  return "Not Empty Title";
                                                }
                                                return null;
                                              }),
                                              controller: title,
                                              
                                              decoration: const InputDecoration(
                                                  labelText: "Title"),
                                            ),
                                            TextFormField(
                                              validator: ((value) {
                                                if (value!.isEmpty) {
                                                  return "Not Empty Subtitle";
                                                }
                                                return null;
                                              }),
                                              controller: subtite,
                                              
                                              decoration: const InputDecoration(
                                                  labelText: "Subtitle"),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                Center(
                                  child: ElevatedButton(
                                      onPressed: (() async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          await upd();
                                         
                                        }
                                      }),
                                      child: const Text("Update")),
                                ),
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("cancel")),
                                ),
                              ],
                            )));
                  },
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
                        user.title.toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user.subtitle.toString(),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                );
              }
            } catch (e) {
              return Text(e.toString());
              print(e.toString());
            }
            // return Text(user.title.toString());
          },
        ),
      ),
    );
  }

  upd() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    DatabaseReference ref1 = FirebaseDatabase.instance.ref(
      firebaseAuth.currentUser!.uid,
    );
    UserData update = UserData(title: title.text, subtitle: subtite.text);

    print(update.title);
    await ref1.child(c!).update(update.toJson());
     Navigator.of(context).pop();
    title.clear();
    subtite.clear();
  }
}
