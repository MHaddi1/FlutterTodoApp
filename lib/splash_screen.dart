import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
    
                 SizedBox(
                   height:200,width:200,
                   child:Image.asset("assets/images/logo.png")
                 ),
                      Container(
                        margin: const EdgeInsets.only(top:30),
                        //margin top 30
                        child:const Text("My Todo", style: TextStyle(
                            fontSize: 30,
                        ),),
                      ),
                      Container(
                        margin:const EdgeInsets.only(top:15),
                        child:const Text("Version: 1.0.0", style:TextStyle(
                           color:Colors.black45,
                           fontSize: 20,
                        )),
                      ),
            ],
          )),
    );
  }
}
