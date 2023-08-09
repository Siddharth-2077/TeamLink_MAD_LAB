// ignore_for_file: prefer_const_constructors, unnecessary_new, curly_braces_in_flow_control_structures, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../dummy.dart';



class EnterRecoveryEmailPage extends StatefulWidget {

  const EnterRecoveryEmailPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return RecoveryPageState();
  }  

}


class RecoveryPageState extends State<EnterRecoveryEmailPage> {

  // Class members:
  final emailController = new TextEditingController();

  // Class methods:
  bool isEmailValid(String email) {
    // Return true if its a valid email address
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
  }


  void SendRecoveryLink() async {
    if (isEmailValid(emailController.text.toLowerCase().trim()) == false)
      return;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toLowerCase().trim());
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
                        "Oops!\nWe'll help you.",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Inter-Bold',
                          color: Colors.black//Color.fromARGB(255, 70, 70, 70)
                        ),
                      ),
                    ),
                  ],
                ),
        
                SizedBox(height: 60),
        
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
        
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Enter your recovery email",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter-Bold',
                          color: Color.fromARGB(150, 70, 70, 70)
                        ),
                      ),
                    ),
        
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
        
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "You'll receive a recovery link in your inbox",
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
                    //controller: emailController,
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
                        hintText: "Recovery Email",
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
        
        
                SizedBox(height: 70),
        
        
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DummyPage()),
                              )
                              // ! -------------------------------------------------- //
                            },
                            child: Text(
                              "Send Code",
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