import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  print(email);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? const MyHomePage() : Todo(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> _intialzationFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
//  @override
//   void initState() {
//     super.initState();
//     Timer(
//         const Duration(seconds: 3),
//         () => Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const MyHomePage())));
//   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: FutureBuilder(
        future: _intialzationFirebase(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      )),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static Future<User?> loginUsingWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      print("login....");
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("Not User Found For Email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My App",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Login To Your App",
            style: TextStyle(
                fontSize: 44, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 44,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (email.text.isEmpty) {
                        return "Email Field Is Empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (pass.text.isEmpty) {
                        return "Password Field is Empty";
                      }
                      return null;
                    },
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forget Password ?",
                        style: TextStyle(color: Colors.red),
                      )),
                  Container(
                    width: double.infinity,
                    child: RawMaterialButton(
                      elevation: 0.0,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      fillColor: Colors.red,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 4), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          User? user = await loginUsingWithEmailPassword(
                              email: email.text,
                              password: pass.text,
                              context: context);

                          print(user);

                          if (user != null) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("email", email.text);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return const Todo();
                            }));
                          }
                        }
                      },
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              // as elevated button gets clicked we will see text"Loading..."
                              // on the screen with circular progress indicator white in color.
                              //as loading gets stopped "Submit" will be displayed
                              children: const [
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Do not have Account? ",
              ),

              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Sign_Up()));
                  },
                  child: const Text("Sign Up",style: TextStyle(fontSize: 17,color: Colors.red),))
            ],
          ),
        ],
      ),
    );
  }
}
