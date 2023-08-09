// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:login_register/pages/login_page.dart';


class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }

}


class SignUpPageState extends State<SignUpPage> {

  // Controllers:
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();


  // Class Functions:
  void RegisterUser() async {
    //showing the loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
      }
    );

    if (!arePasswordsSame(passwordController.text, confirmPasswordController.text)) {
      //popping the loading circle
      Navigator.pop(context);
      passwordsNotMatchingMessage();

    } else if (!isEmailValid(emailController.text.toLowerCase().trim())) {
      //popping the loading circle
      Navigator.pop(context);
      invalidEmailMessage();

    } else {
      try {
        // Try creating user with email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.toLowerCase().trim(),
          password: passwordController.text,
        );

        //popping the loading circle
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));

      // If exceptions were caught, pass it onto the ExceptionHandler function
      } on FirebaseAuthException catch (e) {
        //popping the loading circle
        Navigator.pop(context);
        ExceptionHandler(e.code);
      }    
    }

  }


  bool isEmailValid(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
  }

  bool arePasswordsSame(String p1, String p2) {
    return p1 == p2;
  }


  void ExceptionHandler(String e) {
    if (e == 'email-already-in-use') {
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
                'Email already in use\ntry signing in instead',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });

    } else if (e == 'weak-password') {
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
                'Password is too weak\n\nTry including numbers and special characters',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
    }

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
  
  void passwordsNotMatchingMessage() {
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
                'Passwords dont match\nplease try again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
      });
  }




  @override
  Widget build(BuildContext context) {
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
                        "Hey,\nHop on board!",
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
                        "Let's get you signed up!",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(150, 70, 70, 70)
                        ),
                      ),
                    ),

                  ],
                ),
        
        
                SizedBox(height: 50),
        
        
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


                SizedBox(height: 20),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: confirmPasswordController,
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
                        hintText: "Confirm Password",
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
        
        
        
                SizedBox(height: 50),

        
        
                //SizedBox(height: 40),
        
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
                              // ! OnPressed called here ---------------------------- //
                              RegisterUser()
                              // ! -------------------------------------------------- //
                            },
                            child: Text(
                              "Sign Up",
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