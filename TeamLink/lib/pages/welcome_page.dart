// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:login_register/pages/login_page.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});  
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}




class WelcomePageState extends State<WelcomePage> {

  bool canShowAgain = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [

              SizedBox(height: 50),

              Image(
                image: AssetImage("assets/images/login_design.png"),
                height: 500,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter-Bold',
                        color: Color.fromARGB(150, 70, 70, 70)
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      //"The platform for you\nto turn your ideas\ninto reality.",
                      "Millions of people use\nto turn their ideas\ninto reality.",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Inter-Bold',
                        color: Colors.black//Color.fromARGB(255, 70, 70, 70)
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Dont Show Again",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Inter-Regular',
                          color: Color.fromARGB(255, 70, 70, 70)
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: SizedBox(
                      width: 125,
                      height: 45,
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
                                builder: (context) => LoginPage()),
                            )
                            // ! -------------------------------------------------- //
                          },
                          child: Text(
                            "Next",
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
              )

            ],
          ),
        ),
      ),
    );
    
  }
}