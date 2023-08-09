// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_register/components/home_bottom_navbar.dart';
import 'package:login_register/pages/dummy.dart';
import 'package:login_register/pages/feeds_page.dart';
import 'package:login_register/pages/home%20pages/profile_page.dart';
import 'package:login_register/pages/openings_page.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}



class HomePageState extends State<HomePage> {

  // Class members:
  int NavbarIndex = 0;
  final List<Widget> pages = [
    FeedsPage(),
    OpeningsPage(),
    const ProfilePage()
  ];

  // Class methods:
  void SetNavbarSelectedIndex(int index) {
    setState(() {
      NavbarIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    
    // Initialization tasks
    
    return WillPopScope(
      // Doesn't allow to go back after entering this page
      onWillPop: ()=> Future.value(false),

      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: HomeBottomNavbar(onTabChange: (index) => SetNavbarSelectedIndex(index)),
        
        body: pages[NavbarIndex]

      ), 
    );
  }

}