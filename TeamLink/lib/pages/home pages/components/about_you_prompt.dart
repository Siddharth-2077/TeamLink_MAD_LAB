// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:login_register/pages/enter_details_page.dart';

class TellUsAboutYouCard extends StatelessWidget {
  const TellUsAboutYouCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
          width: double.infinity, 
          height: 275,                                  // SET TO 275 ON A21s
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color.fromARGB(240, 255, 188, 81), //Color.fromARGB(255, 255, 187, 77),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 25),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.info,
                          size: 35,
                          color:
                            Colors.black//Color.fromARGB(255, 255, 188, 81),
                          ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Tell us about yourself",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter-Bold',
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 30),
                child: Text(
                  "We just need a few essential details for you to use the app's features.",//"We just need a few essential details about you, before you can proceed using the features of this app...",
                  style: TextStyle(fontSize: 16, fontFamily: 'Inter-Regular'),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 115),
                child: Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStatePropertyAll<double>(1.5),
                      backgroundColor:
                        MaterialStatePropertyAll<Color>(/*Color.fromARGB(255, 115, 206, 195)*/Color(0xff8CCDC5)),
                      foregroundColor:
                        MaterialStatePropertyAll<Color>(Color(0xffffffff)),
                      shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      )
                    ),
                    onPressed: () {
                      //! Button press to go to "Enter Details"page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EnterDetailsPage(Title: "Please fill your information",)
                        ),
                      );
                      //! -----------------------------------------
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          "Proceed",
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'Inter-Bold'),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_circle_right_outlined, size: 30)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
