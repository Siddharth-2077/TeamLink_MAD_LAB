// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore



import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../pages/dummy.dart';



class SelectImageTile extends StatefulWidget {

  const SelectImageTile({super.key});

  @override
  State<StatefulWidget> createState() {
    return SelectImageTileState();
  }

}





class SelectImageTileState extends State<SelectImageTile> {

  final storage = FirebaseStorage.instance.ref();
  late SharedPreferences shared_prefs;
  String user_uid = '';

  ImagePicker picker = ImagePicker();
  File? _image;
  

  // Shared Preferences:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
    if (shared_prefs != null) {
      user_uid = shared_prefs.getString('user_uid') ?? '';
    }
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
                'Failed to upload image!',
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
      width: 300,
      height: 300,
      //color: Colors.greenAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: 30),


          GestureDetector(
            onTap: () async {
                
              XFile? image = await picker.pickImage(source: ImageSource.gallery);
              
              setState(() async {

                if (image != null) {
                  _image = File(image!.path);
                  
                  if (user_uid == '') {
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
                  Reference reference = storage.child("/profile_pictures/"+user_uid);                  
                  await reference.putFile(_image!);   

                  String download_url = "";
                  download_url = await reference.getDownloadURL();                  

                  if (download_url != "") {
                    shared_prefs.setString('profile_pic_url', download_url);                                                         //! SHAREED PREFS KEY:    profile_pic_url
                  }

                  //* Used to trigger a redraw of the UI and to update the Profile_Pic displayed locally
                  setState(() {
                    _image = File(image!.path);
                  });

                  Navigator.pop(context);

                } else {
                  image = AssetImage('assets/images/default_dp_2.jpg') as XFile?;
                }
              });

            },
            //* If image selected from gallery IS NOT null, display it
            child: _image != null ? 
            ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image.file(
                _image!,
                width: 200,
                height: 200,
                fit: BoxFit.fitHeight,
                //isAntiAlias: true,
              ),
            )
            : 
            //* If image selected from gallery IS null, display the default icon
            ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image(
                image: AssetImage('assets/images/default_dp_2.jpg'),
                width: 200,
                height: 200,
                fit: BoxFit.fitHeight,
                //isAntiAlias: true,
              ),
            )
          ),


          SizedBox(height: 35),


          Text(
            "Tap to update profile picture",
            style: TextStyle(
              fontFamily: 'Inter-Regular'
            ),
          ),

                


        ],
      ),
    );
  }

}