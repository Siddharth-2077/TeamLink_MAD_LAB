// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_null_comparison, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class DummyPage extends StatefulWidget {

  const DummyPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return DummyPageState();
  }

}



class DummyPageState extends State<DummyPage> {

  // Class members:
  late SharedPreferences shared_prefs;
  String uid = "blank_uid";
  String email_id = "blank_email_id";


  //! Shared Preferences Operations:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
    GetSharedPrefsUID();
  }

  void GetSharedPrefsUID() {
    if (shared_prefs == null)
      return;
    if (shared_prefs.containsKey("user_uid") == true) {
      setState(() {
        uid = shared_prefs.getString("user_uid") ?? uid;
      });      
    }
    if (shared_prefs.containsKey("user_uid") == true) {
      setState(() {
        email_id = shared_prefs.getString("email_id") ?? email_id;
      });      
    }
  }


  @override
    Widget build(BuildContext context) {

    // Initialization tasks:
    InitializeSharedPreferences();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("__Dummy Page__"),
              SizedBox(height: 10),
              Text("EMAIL:    " + email_id),
              SizedBox(height: 10),
              Text("UID:    " + uid)
            ],
          ),
        ),
      ),
    );
  }

}