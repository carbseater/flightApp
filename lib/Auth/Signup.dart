
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import 'LoginWidget.dart';
class SignUpWidget extends StatefulWidget {

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: Container(
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
                "Sign Up",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signUp,

            ),
            SizedBox(height: 40,),
            ElevatedButton(onPressed: ()=>{

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>LoginWidget()))
            },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey
                ),
                 child: Text("SignIn")),



          ],
        ),
      ),
    ),
  );
  Future signUp() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder:(context)=> Center(child: CircularProgressIndicator(),)
    );
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );
    //Navigator.currentState!.popUntil((route)=>route.isFirst);
  }

}
