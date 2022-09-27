
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Auth/Signup.dart';
import 'home_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAWrTqCOMMlIK3XS2XrSAWzNc5XQE27n8Y",
          authDomain: "flight-booking-2e236.firebaseapp.com",
          databaseURL: "https://flight-booking-2e236-default-rtdb.firebaseio.com",
          projectId: "flight-booking-2e236",
          storageBucket: "flight-booking-2e236.appspot.com",
          messagingSenderId: "397894267573",
          appId: "1:397894267573:web:a0426102c98abb489e44fc",
        ) // Your projectId
    );
  } else {
    await Firebase.initializeApp();


  }

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MainPage()
    );
  }
}
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
        if(snapshot.hasData){
        //   return AdminDashboard();
          return UserPage();
        }
        return SignUpWidget();
      },
    )
  );
}

