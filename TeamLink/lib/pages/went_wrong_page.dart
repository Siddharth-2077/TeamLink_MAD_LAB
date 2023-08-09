// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


class SomethingWentWrong extends StatefulWidget {

  const SomethingWentWrong({super.key});

  @override
  State<StatefulWidget> createState() {
    return SomethingWentWrongState();
  }

}


class SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            
          Text("Oops! Something went wrong...")
    
        ],
      ),
    );
  }



}