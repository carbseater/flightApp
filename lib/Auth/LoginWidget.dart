
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class LoginWidget extends StatefulWidget {

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) =>Scaffold(
    body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            //   return AdminDashboard();
            return UserPage();
          }
          return
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40,),
                      TextField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Email'),

                      ),
                      SizedBox(height: 4,),
                      TextField(
                        controller: passwordController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                          primary: Colors.blueGrey
                        ),
                        icon: Icon(Icons.lock_open,size: 32,),
                        label: Text(
                          "Sign in",
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: signIn,
                      ),

                    ],
                  ),
                ),
              ),
            );

        },
    )
  );


  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );
  }
}