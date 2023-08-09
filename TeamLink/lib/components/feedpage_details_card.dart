// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'dart:io';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_register/components/select_image_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedpageDetailCard extends StatefulWidget {
  const FeedpageDetailCard({super.key});

  @override
  State<StatefulWidget> createState() {
    return FeedpageDetailCardState();
  }
}

class FeedpageDetailCardState extends State<FeedpageDetailCard> {
  // Firestore and Firebase-Storage DB instances
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref();

  ImagePicker picker = ImagePicker();
  File? _image;
  bool uploaded_image = false;

  late SharedPreferences shared_prefs;
  String uid = "";
  String feed_image_download_url = "";

  final FeedTitleController = new TextEditingController();
  final FeedDescriptionController = new TextEditingController();
  final FeedSecondaryDescriptionController = new TextEditingController();
  final FeedLinkController = new TextEditingController();

  bool feed_agree_guidelines = false;

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

  bool CheckIfFeedConditionsPass() {
    if (FeedTitleController.text.toString().isEmpty ||
        !feed_agree_guidelines) {
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

  void FailedToUploadMessage() {
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
                'Failed to upload Image!',
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

    InitializeSharedPreferences();

    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // Openings details enter card
          Container(
            width: 500,
            height: 1125,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 235, 235, 235),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              SizedBox(height: 20),



              // SELECT IMAGE TILE
              GestureDetector(
                onTap: () async {
                    
                  XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  
                  setState(() async {

                    if (image != null) {
                      _image = File(image!.path);

                      if (uid == "" || uid == "nil") {
                        FailedToUploadMessage();
                        return;
                      }
                      
                      // Loading circle
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 6,
                              color: Colors.amberAccent,           
                            ),
                          );
                      }); 

                      //* Push to firebase storage
                      var time = DateTime.now().millisecondsSinceEpoch.toString();
                      Reference reference = storage.child("feed_pictures/"+uid+"/$time");                  
                      await reference.putFile(_image!); 
                      feed_image_download_url = await reference.getDownloadURL();                  
                      
                      Navigator.pop(context);

                      uploaded_image = true;

                      //* Used to trigger a redraw of the UI and to update the Profile_Pic displayed locally
                      setState(() {
                        _image = File(image!.path);
                      });


                    } else {
                      image = AssetImage('assets/images/default_dp_2.jpg') as XFile?;
                    }

                  });

                },
                //* If image selected from gallery IS NOT null, display it
                child: _image != null ? 
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    //isAntiAlias: true,
                  ),
                )
                : 
                //* If image selected from gallery IS null, display the default icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: AssetImage('assets/images/default_post_pic.png'),
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    //isAntiAlias: true,
                  ),
                )
              ),



              SizedBox(height: 20),



              //* TITLE FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: FeedTitleController,
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
                      hintText: "* Caption",
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

              //* DESCRIPTION FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExtendedTextField(
                  keyboardType: TextInputType.multiline,
                  controller: FeedDescriptionController,
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
                      hintText: "Description (optional)",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31))),
                  style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 18),
                  maxLength: 300,
                  maxLines: 15,
                ),
              ),

              SizedBox(height: 20),

              //* EXTERNAL LINKL FIELD //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: FeedLinkController,
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
                    value: feed_agree_guidelines,
                    onChanged: (value) {
                      setState(() {
                        feed_agree_guidelines = !feed_agree_guidelines;
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
                      "Post on Feed",
                      style: TextStyle(fontSize: 16, fontFamily: 'Inter-Bold'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      //! BUTTON PRESS - POST A FEED-POST
                      onPressed: () async {
                        bool passes = CheckIfFeedConditionsPass();
                        if (passes) {
                          //* POST TO FIREBASE FIRESTORE
                          firestore = FirebaseFirestore.instance;

                          final feed_data = <String, dynamic>{
                            "caption": FeedTitleController.text.toString().trim(),
                            "description": FeedDescriptionController.text.toString().trim(),
                            "timestamp": Timestamp.now(),
                            "uid": uid,
                            "url": FeedLinkController.text.toString().trim(),
                            "image_url": (uploaded_image ? feed_image_download_url : "https://firebasestorage.googleapis.com/v0/b/mad-lab-project-3008f.appspot.com/o/feed_pictures%2Fdefault_post_pic.png?alt=media&token=7464ffff-7957-4b52-92bd-d1bac3032e6f")
                          };

                          //* Push to Firestore, with user's UID as the document-id
                          await firestore.collection("feed").add(feed_data);

                          SuccessfullyPostedMessage();
                          
                        } else {
                          InvalidPostMessage();
                        }
                      },
                      //! -------------------------------
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
        ],
      ),
    ));
  }
}
