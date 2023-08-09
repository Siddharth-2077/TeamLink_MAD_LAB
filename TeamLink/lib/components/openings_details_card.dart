// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:extended_text_field/extended_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:login_register/components/select_image_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';



class OpeningsDetailCard extends StatefulWidget {
  const OpeningsDetailCard({super.key});

  @override
  State<StatefulWidget> createState() {
    return OpeningsDetailCardState();
  }
}



class OpeningsDetailCardState extends State<OpeningsDetailCard> {
  // Firestore and Firebase-Storage DB instances
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late SharedPreferences shared_prefs;
  String uid = "";

  // Controllers:
  final OpeningTitleController = new TextEditingController();
  final OpeningDescriptionController = new TextEditingController();
  final OpeningSecondaryDescriptionController = new TextEditingController();
  final OpeningLinkController = new TextEditingController();

  // Values
  bool opening_agree_guidelines = false;

  // Function Definitions:
  // Shared Preferences:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
    if (shared_prefs != null) {
      setState(() {
        uid = shared_prefs.getString('user_uid') ?? '';
      });
    }
  }

  bool CheckIfOpeningConditionsPass() {
    if (OpeningTitleController.text.toString().isEmpty ||
        OpeningDescriptionController.text.toString().isEmpty ||
        !opening_agree_guidelines) {
      return false;
    }
    return true;
  }

  // ERROR FUNCTIONS:
  void InvalidPostMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            icon: Icon(Icons.error),
            iconColor: Colors.white,
            backgroundColor: Colors.black,
            titlePadding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
            title: Center(
              child: Text(
                'Invalid Post!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  // SUCCESS FUNCTIONS:
  void SuccessfullyPostedMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            icon: Icon(Icons.check),
            iconColor: Colors.white,
            backgroundColor: Colors.black,
            titlePadding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
            title: Center(
              child: Text(
                'Post was created Successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // Openings details enter card
          Container(
            width: 500,
            height: 1175,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 235, 235, 235),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              SizedBox(height: 20),

              //* TITLE FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: OpeningTitleController,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20, bottom: 20, left: 25),
                      suffixIcon: Icon(Icons.title),
                      suffixIconColor: Color.fromRGBO(0, 0, 0, 0.75),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fillColor: Color(0xffFDCE84),
                      filled: true,
                      hintText: "* Title",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31))),
                  style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 18),
                ),
              ),

              SizedBox(height: 20),

              //* PRIMARY DESCRIPTION FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExtendedTextField(
                  keyboardType: TextInputType.multiline,
                  controller: OpeningDescriptionController,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20, bottom: 20, left: 25),
                      suffixIcon: Icon(Icons.feed_outlined),
                      suffixIconColor: Color.fromRGBO(0, 0, 0, 0.75),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fillColor: Color(0xff8ACAC0),
                      filled: true,
                      hintText: "* Description",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31))),
                  style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 18),
                  maxLength: 450,
                  maxLines: 15,
                ),
              ),

              SizedBox(height: 20),

              //* SECONDARY DESCRIPTION FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExtendedTextField(
                  keyboardType: TextInputType.multiline,
                  controller: OpeningSecondaryDescriptionController,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20, bottom: 20, left: 25),
                      suffixIcon: Icon(Icons.description_outlined),
                      suffixIconColor: Color.fromRGBO(0, 0, 0, 0.75),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fillColor: Color(0xff8ACAC0),
                      filled: true,
                      hintText: "Secondary Description (optional)",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31))),
                  style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 18),
                  maxLength: 300,
                  maxLines: 10,
                ),
              ),

              SizedBox(height: 20),

              //* EXTERNAL LINKL FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: OpeningLinkController,
                  keyboardType: TextInputType.url,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20, bottom: 20, left: 25),
                      suffixIcon: Icon(Icons.link),
                      suffixIconColor: Color.fromRGBO(0, 0, 0, 0.75),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fillColor: Color(0xff8ACAC0),
                      filled: true,
                      hintText: "External Link (optional)",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31))),
                  style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 14),
                ),
              ),

              SizedBox(height: 25),

              Row(
                children: [
                  SizedBox(width: 15),
                  Checkbox(
                    value: opening_agree_guidelines,
                    onChanged: (value) {
                      setState(() {
                        opening_agree_guidelines = !opening_agree_guidelines;
                      });
                    },
                  ),
                  Text("Agrees with Community Guidelines")
                ],
              ),

              SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Post an Opening",
                      style: TextStyle(fontSize: 16, fontFamily: 'Inter-Bold'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      //! BUTTON PRESS - POST AN OPENING
                      onPressed: () async {
                        bool passes = CheckIfOpeningConditionsPass();
                        if (passes) {
                          //* POST TO FIREBASE FIRESTORE
                          firestore = FirebaseFirestore.instance;

                          final opening_data = <String, dynamic>{
                            "title": OpeningTitleController.text.toString().trim(),
                            "description": OpeningDescriptionController.text.toString().trim(),
                            "second_description": OpeningSecondaryDescriptionController.text.toString().trim(),
                            "timestamp": Timestamp.now(),
                            "uid": uid,
                            "url": OpeningLinkController.text.toString().trim()
                          };

                          //* Push to Firestore, with user's UID as the document-id
                          await firestore.collection("openings").add(opening_data);

                          SuccessfullyPostedMessage();
                          
                        } else {
                          InvalidPostMessage();
                        }
                      },
                      //! ------------------------------
                      child: Icon(Icons.check),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),

          SizedBox(height: 10),
        ],
      ),
    ));
  }
}
