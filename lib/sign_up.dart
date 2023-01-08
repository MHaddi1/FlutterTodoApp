import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'main.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({super.key});

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  bool Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    return (isvalid);
  }

  final _formKey = GlobalKey<FormState>();

  static Future<User?> signUpUsingWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        print(user.email);
      }

      user = userCredential.user;
      print(user);

      print("sign up....!!");
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-registered") {
        print("This Email cannot be register");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Sign Up to Your App",
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Email",
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
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (password.text.isEmpty) {
                        return "Password Field is Empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: cPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (cPassword.text.isEmpty) {
                        return "Confirm Password Field is Empty";
                      }
                      if (value != password.text) {
                        return "Both Field is Not Match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      width: double.infinity,
                      child: RawMaterialButton(
                        fillColor: Colors.red,
                        elevation: 0.0,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () async {
                          //
                          if (_formKey.currentState!.validate() ||
                              Validate(email.text)) {
                            _formKey.currentState?.save();
                            User? user = await signUpUsingWithEmailPassword(
                                email: email.text,
                                password: password.text,
                                context: context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return const MyHomePage();
                            }));
                            const snackdemo = SnackBar(
                              content: Text('Sign Up Successfully...!!'),
                              backgroundColor: Colors.red,
                              elevation: 10,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(5),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackdemo);
                          }

                          // print(email.text);
                          // print(password.text);
                          // print(cPassword.text);
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an Account? "),
              
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyHomePage()));
                    },
                    child: const Text("Sign In",style: TextStyle(fontSize: 17,color: Colors.red),))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
