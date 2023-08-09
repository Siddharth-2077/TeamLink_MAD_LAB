// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:login_register/pages/home_page.dart';
import 'package:login_register/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_pages/password_recovery_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}


class LoginPageState extends State<LoginPage> {

  late SharedPreferences shared_prefs;

  // Controllers:
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();


  // Login functions:
  bool isEmailValid(String email) {
    // Return true if its a valid email address
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
  }


  void SignUserIn() async {

    // Showing the loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Colors.amberAccent,           
            ),
          );
    });

    try {    

      // Check if email is valid, if it isnt then return  
      if (!isEmailValid(emailController.text.toLowerCase().trim())) {
        //popping the loading circle
        Navigator.pop(context);
        invalidEmailMessage();
        return;
      }

      // Password field left blank
      if (passwordController.text == "") {
        //popping the loading circle
        Navigator.pop(context);
        blankPasswordMessage();
        return;
      }

      // Wait for firebase to authenticate the user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
      );


      //! SHARED_PREFERENCES OPERATION
      //* If successfully logged in, Get UID of the user and store in shared_prefs
      final User? user = FirebaseAuth.instance.currentUser;

      String user_uid = (user != null ? user.uid : "nil");
      String email_id = (user != null ? emailController.text.toLowerCase().trim() : "nil");
                                    
      //* Add the user's uid to the shared_prefs
      shared_prefs.setString("user_uid", user_uid);                                             //! NOTE shared_prefs key: 'user_uid'
      shared_prefs.setString("email_id", email_id);                                             //! NOTE shared_prefs key: 'email_id'


      // Popping the loading circle and routing to HomePage (Upon Success / No exceptions caught)
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));

    } on FirebaseAuthException catch (e) {
      // Popping the loading circle
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else if (e.code == 'user-disabled') {
        userDisabledMessage();
      }
    }

  }


  //function for wrong email exception
  void wrongEmailMessage() {
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
                'Email does not exist\nCreate a new account instead',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }

  void invalidEmailMessage() {
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
                'Invalid Email Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }

  //function for wrong password exception
  void wrongPasswordMessage() {
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
                'Wrong password\nplease try again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }


  //function for blank password exception
  void blankPasswordMessage() {
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
                'Please enter the password\nto proceed',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }


  void userDisabledMessage() {
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
                'This account has been disabled',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }



  // Transitioning functions:
  void GoToHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DummyPage()                                     //! Change this transition from "DummyPage" to "HomePage" when ready
      ),
    );
  } 

  void GotoCreateNew() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpPage()
      ),
    );
  }

  void GotoRecoveryEmailPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EnterRecoveryEmailPage()
      ),
    );
  }




  // Shared Preferences:
  void InitializeSharedPreferences() async {
    shared_prefs = await SharedPreferences.getInstance();
  }



  @override
  Widget build(BuildContext context) {
    
    // Do some initialization tasks:
    InitializeSharedPreferences();


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea (
          child: Center(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
        
                SizedBox(height: 150),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Hey,\nLogin now.",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Inter-Bold',
                          color: Colors.black//Color.fromARGB(255, 70, 70, 70)
                        ),
                      ),
                    ),
                  ],
                ),
        
                SizedBox(height: 30),
        
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
        
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "If you are new /",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(150, 70, 70, 70)
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 10),

                    GestureDetector(
                      // * On tap, go to the SignUp page //
                      onTap: () {
                        GotoCreateNew();
                      },
                      child: Text(
                        "Create New",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Bold',
                          color: Color.fromRGBO(0, 0, 0, 0.8)//Color.fromARGB(150, 70, 70, 70)
                        ),
                      ),
                    )
        
                  ],
                ),
        
        
                SizedBox(height: 60),
        
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20, left: 25),
                        suffixIcon: Icon(Icons.mail_outlined),
                        suffixIconColor: Color.fromRGBO(0, 0, 0, 0.75),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        fillColor: Color(0xffFDCE84),
                        filled: true,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31) 
                        )
                    ),
                    style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 18
                    ),
                  )
                ),
        
        
                SizedBox(height: 20),
        
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20, left: 25),
                        suffixIcon: Icon(Icons.password),
                        suffixIconColor: Color.fromRGBO(0, 0, 0, 0.75),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0)),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        fillColor: Color.fromARGB(255, 240, 240, 240),
                        filled: true,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(50, 31, 31, 31) 
                        )
                    ),
                    style: const TextStyle(
                      color: Color(0xff1f1f1f),
                      fontFamily: 'Inter-Bold',
                      fontSize: 18
                    ),
                  )
                ),
        
        
        
                SizedBox(height: 40),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
        
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Forgot Password? /",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(150, 70, 70, 70)
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 10),

                    GestureDetector(
                      onTap: () {
                        GotoRecoveryEmailPage();
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Bold',
                          color: Color.fromRGBO(0, 0, 0, 0.8)//Color.fromARGB(150, 70, 70, 70)
                        ),
                      ),
                    )
        
                  ],
                ),
        
        
                SizedBox(height: 60),
        
                Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll<double>(1.5),
                                backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff8ACAC0)),
                                foregroundColor: MaterialStatePropertyAll<Color>(Color(0xffffffff)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),
                                )
                              )
                            ),
                            onPressed: () => {
                              // ! Navigating to a dummy page: ---------------------- //
                              SignUserIn()
                              // ! -------------------------------------------------- //
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Inter-Bold'
                              ),
                            )
                        ),
                      ),
                  )
                
        
              ],
            ),
          ),
        ),
    );
  }

}