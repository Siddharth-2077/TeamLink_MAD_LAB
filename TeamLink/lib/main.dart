// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:login_register/pages/login_page.dart';
import 'package:login_register/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';


void main() async {                                                             // MAIN FUNCTION

  WidgetsFlutterBinding.ensureInitialized();

  // * Wait for initialization of the Firebase Project
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set portrait as the preferred App-Orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //* Run the app
  runApp(MyApp());

}



class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}


class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: WelcomePage()
    );
  }

}