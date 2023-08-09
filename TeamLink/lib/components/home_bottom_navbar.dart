// ignore_for_file: unnecessary_new, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeBottomNavbar extends StatelessWidget {

  void Function(int)? onTabChange;

  HomeBottomNavbar ({
    super.key,
    required this.onTabChange
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: 
      
      GNav(
        style: GnavStyle.google,
        padding: EdgeInsets.all(20),
        iconSize: 20,
        color: Colors.grey,
        activeColor: Colors.black,
        tabActiveBorder: Border.all(color: Colors.transparent),
        //tabBackgroundColor: Color.fromARGB(200, 138, 202, 192),
        backgroundColor: Colors.white,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //tabBorderRadius: 30,
      
        onTabChange: (value)=> onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            haptic: true,
            text: "  Feed Page",
          ),
          GButton(
            icon: Icons.work_rounded,//Icons.cases_rounded,
            haptic: true,
            text: "  Openings Page",
          ),
          GButton(
            icon: Icons.person,
            haptic: true,
            text: "  Profile Page",
          ),
        ],
      ),

    );
  }

}