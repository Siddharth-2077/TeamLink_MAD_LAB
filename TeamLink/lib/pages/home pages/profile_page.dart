// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_register/pages/create_post_page.dart';
import 'package:login_register/pages/enter_details_page.dart';
import 'package:login_register/pages/home%20pages/components/about_you_prompt.dart';
import 'package:login_register/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../dummy.dart';
import '../went_wrong_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  // Class members:
  late SharedPreferences shared_prefs;
  String profile_pic_url = "";
  String uid = '';
  String default_profile_pic_url =
      'https://firebasestorage.googleapis.com/v0/b/mad-lab-project-3008f.appspot.com/o/profile_pictures%2Fdefault_profile_picture.jpg?alt=media&token=7358bef6-b0e1-44bd-b906-e1c2c4348e96';

  String name = "user";
  bool profile_complete = false;

  // Class methods:
  // Shared Preferences:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
    if (shared_prefs != null) {
      setState(() {
        uid = shared_prefs.getString('user_uid') ?? '';
        profile_pic_url = shared_prefs.getString('profile_pic_url') ?? '';
        name = shared_prefs.getString('name') ?? name;
        profile_complete = shared_prefs.getBool('profile_completed') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    InitializeSharedPreferences();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(height: 30),

              //* LOGOUT BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                        child: GestureDetector(
                      //! ON TAP: Logout user and go to LoginPage
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },

                      child: Row(
                        children: [
                          Text(
                            "Logout",
                            style: TextStyle(
                                fontFamily: 'Inter-Bold', fontSize: 14),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.logout_outlined)
                        ],
                      ),
                    )),
                  )
                ],
              ),

              SizedBox(height: 40),

              //* Show the user-uploaded profile picture, else show default picture (url must be given)
              GestureDetector(
                onTap: () {
                  //! ON TAP: Go to modify details page
                  //* When the profile pic is clicked, user should be taken to edit profile page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EnterDetailsPage(
                              Title: "Edit your details",
                            )),
                  );
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CachedNetworkImage(
                      imageUrl: (profile_pic_url != ""
                          ? profile_pic_url
                          : default_profile_pic_url),
                      width: 170,
                      height: 170,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/images/default_dp_2.jpg')),
                    )),
              ),

              SizedBox(height: 20),

              //* If profile isn't complete display a placeholder rectangle, else display user's NAME
              Container(
                  width: 200,
                  height: 35,
                  decoration: BoxDecoration(
                      color: profile_complete == true
                          ? Colors.transparent
                          : Color.fromARGB(255, 235, 235, 235),
                      borderRadius: BorderRadius.circular(20)),
                  child: profile_complete == true
                      ? Center(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontFamily: 'Inter-Bold',
                              fontSize: 20,
                              //color: Colors.black
                            ),
                          ),
                        )
                      : null),

              //* BRANCH based on profile_complete
              Container(
                  child: profile_complete == false
                      ? SizedBox(height: 80)
                      : SizedBox(height: 50)),

              //* BRANCH based on profile_complete
              Container(
                  child: profile_complete == false
                      ?
                      //* Complete Profile Text
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                "Complete Profile",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Inter-Bold',
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        )
                      :
                      //* Your Posts Text
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 15),
                              child: Text(
                                "Your Posts",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Inter-Bold',
                                    color: Colors.black),
                              ),
                            ),
                            GestureDetector(
                              //! ON TAP: Go to Create a Post Page
                              // TODO ---------------------------------------------------------- //
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => CreatePost()),
                                );
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(200, 105, 240, 175),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(Icons.add),
                              ),
                            )
                          ],
                        )),

              SizedBox(height: 40),

              //* BRANCH based on profile_complete
              Container(
                  child: profile_complete == false
                      ? TellUsAboutYouCard() // Prompt to ask details of the user
                      : null
              ),

            ],
          ),
        ),
      ),
    );
  }
}
