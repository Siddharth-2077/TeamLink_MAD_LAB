// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:extended_text_field/extended_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:login_register/components/openings_details_card.dart';
import 'package:login_register/components/select_image_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/feedpage_details_card.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});
  @override
  State<StatefulWidget> createState() {
    return CreatePostState();
  }
}



class CreatePostState extends State<CreatePost> {

  late SharedPreferences shared_prefs;
  String uid = "";

  bool opening_switch = true;
  bool feed_post_switch = true;

  // Shared Preferences:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
    if (shared_prefs != null) {
      setState(() {
        uid = shared_prefs.getString('user_uid') ?? '';
      });      
    }
  }

  @override
  Widget build(BuildContext context) {

    InitializeSharedPreferences();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text("Create a new Post"),
      ),
      //* BODY
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
        
              SizedBox(height: 10),        
        
              //* CREATE AN OPENING SWITCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        "Create an Opening",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter-Bold',
                        ),
                      ),
                    ),
              
                    SizedBox(width: 15),
              
                    FlutterSwitch(
                      value: opening_switch,
                      width: 55,
                      height: 30,
                      onToggle: (val) {
                        setState(() {
                          opening_switch = val;
                        });
                      }
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),



              //* OPENINGS DETAILS CARD (if openings switch is enabled)
              Padding(
                padding: EdgeInsets.only(),
                child: (opening_switch == true ? OpeningsDetailCard() : null),
              ),



              SizedBox(height: (feed_post_switch == true ? 50 : (opening_switch == true ? 50 : 10))),

              //* CREATE A FEED-POST SWITCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:0),
                      child: Text(
                        "Create a Feed Post",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter-Bold',
                        ),
                      ),
                    ),
              
                    SizedBox(width: 15),
              
                    FlutterSwitch(
                      value: feed_post_switch,
                      width: 55,
                      height: 30,
                      onToggle: (val) {
                        setState(() {
                          feed_post_switch = val;
                        });
                      }
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: 20),



              //* FEED-PAGE DETAILS CARD (if feed switch is enabled)
              Padding(
                padding: EdgeInsets.only(),
                child: (feed_post_switch == true ? FeedpageDetailCard() : null),
              ),
              
                            

              SizedBox(height: 50),
        
            ],
          ),
        ),
      ),
    );
  }
}
