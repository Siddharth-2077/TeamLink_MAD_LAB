// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_register/components/details_tile.dart';
import 'package:login_register/components/select_image_tile.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EnterDetailsPage extends StatefulWidget {
  final String Title;
  const EnterDetailsPage({
    super.key,
    required this.Title
  });
  @override
  State<StatefulWidget> createState() {
    return EnterDetailsPageState();
  }
}



class EnterDetailsPageState extends State<EnterDetailsPage> {

  // Firestore and Firebase-Storage DB instances
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // The sharedprefs reference
  late SharedPreferences shared_prefs;
  String user_uid = '';
  String email_id = '';

  // Class members:
  final TextEditingController name_controller = new TextEditingController();
  final TextEditingController college_controller = new TextEditingController();
  final TextEditingController email_controller = new TextEditingController();
  final TextEditingController phone_number_controller = new TextEditingController();
  final TextEditingController linkedin_controller = new TextEditingController();
  final TextEditingController website_controller = new TextEditingController();

  // Shared Preferences:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
    if (shared_prefs != null) {
      user_uid = shared_prefs.getString('user_uid') ?? '';
      email_id = shared_prefs.getString('email_id') ?? '';
    }
  }

  // Class methods:
  bool VerifyEssentialsDetailsEntered() {
    // If the essential fields are filled by the user:
    if (name_controller.text.toString().trim() != "" &&
        college_controller.text.toString().trim() != "" &&
        email_controller.text.toString().trim() != "") {
      // Verified
      return true;
    }
    return false;
  }

  void InvalidDetailsMessage() {
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
                'Please enter the mandatory fields marked with \'*\'',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }

  void ERROR_TryAgainMessage() {
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
                'Oops! Seems like an error on our end. Please try again later',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }

  void ERROR_FailedToSaveMessage() {
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
                'Failed to save your details! Please try again later',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }


  void SUCCESS_AddingToDbMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            icon: Icon(Icons.check_circle_rounded),
            iconColor: Colors.white,
            backgroundColor: Colors.black,
            titlePadding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
            title: Center(
              child: Text(
                'Your details were saved successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }

  

  void PushDetailsToFirestoreDB() async {
    firestore = FirebaseFirestore.instance;

    //* Get the download url of the profile pic from shared_prefs
    String profile_pic_download_url = '';
    if (shared_prefs.containsKey('profile_pic_url')) {
      profile_pic_download_url = shared_prefs.getString('profile_pic_url') ?? '';
    } else {
      profile_pic_download_url = '';
    }

    //* The data to be pushed to firestore
    final user_data = <String, dynamic> {
      'name': name_controller.text.toString().trim(),
      'college': college_controller.text.toString().trim(),
      'email': email_controller.text.toString().trim(),
      'phone': phone_number_controller.text.toString().trim(),
      'linkedin': linkedin_controller.text.toString().trim(),
      'webpage': website_controller.text.toString().trim(),
      'timestamp': Timestamp.now(),
      'profile_pic_url': profile_pic_download_url.trim()
    };
    

    //* User's uid wasn't loaded properly from the shared prefs instance
    if (user_uid == '') {
      ERROR_TryAgainMessage();
      return;
    }

    //* Push to Firestore, with user's UID as the document-id
    firestore.collection("users").doc(user_uid).set(user_data);
    
    // Loading Circle
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


    //* Check if the doc got added to the db:
    await firestore.collection("users").doc(user_uid).get().then((doc) {

      if(doc.exists) {
        // Pop the loading circle
        Navigator.pop(context);
        SUCCESS_AddingToDbMessage();

        //! SHARED PREFERENCES KEYS INTRODUCED HERE: -------- name, college, college_email, contact_number, linkedin_url, website_url ----------
        //* Push all entered (and blank) data to Shared Preferences:
        setState(() {
          shared_prefs.setString('name', name_controller.text.toString().trim());
          shared_prefs.setString('college', college_controller.text.toString().trim());
          shared_prefs.setString('college_email', email_controller.text.toString().trim());
          shared_prefs.setString('contact_number', phone_number_controller.text.toString().trim());
          shared_prefs.setString('linkedin_url', linkedin_controller.text.toString().trim());
          shared_prefs.setString('website_url', website_controller.text.toString().trim());          
        });
        
        //! SHARED PREFERENCES KEY INTRODUCED HERE: ------------ data_set ---------
        setState(() {
          shared_prefs.setBool('profile_completed', true);     // Indicates whether the user data is entered or not          
        });


        // TODO: Transition to page to add 'interest tags' of the user ------------------------------------- //
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => DummyPage()));
        
      } else {
        // Pop the loading circle
        Navigator.pop(context);
        ERROR_FailedToSaveMessage();

      }
    });   


  }


  @override
  Widget build(BuildContext context) {

    // Get reference to shared preferences instance
    InitializeSharedPreferences();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          widget.Title
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 69, 193, 141),
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () async {
          
          if (VerifyEssentialsDetailsEntered() == true) {
            PushDetailsToFirestoreDB();
            
          } else {
            // todo: show a popup message saying invalid
            InvalidDetailsMessage();
          }

        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 90, left: 10, right: 10),
          //* add padding if needed
          child: Column(
            children: [
            
              SelectImageTile(),
              SizedBox(height: 20),

              DetailsTile(title_string: "* Name", controller: name_controller),
              SizedBox(height: 20),

              DetailsTile(title_string: "* College", controller: college_controller),
              SizedBox(height: 20),

              DetailsTile(title_string: "* College Email", inputType: TextInputType.emailAddress, controller: email_controller),
              SizedBox(height: 20),

              DetailsTile(title_string: "Contact No.", inputType: TextInputType.phone, controller: phone_number_controller),
              SizedBox(height: 20),

              DetailsTile(title_string: "LinkedIn Profile", inputType: TextInputType.url, controller: linkedin_controller),
              SizedBox(height: 20),

              DetailsTile(title_string: "Personal Website", inputType: TextInputType.url, controller: website_controller),
              SizedBox(height: 20),

            ],
          ),
        )
      )
    );
  }


}