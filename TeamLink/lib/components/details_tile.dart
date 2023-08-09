// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//* TEXT BASED / NUMBER BASED DETAIL-ENTRY TILE *//


class DetailsTile extends StatefulWidget {

  // Constructor parameters:
  String title_string = "";
  String hint_text = "";
  TextInputType inputType = TextInputType.text;
  TextEditingController controller;


  // Constructor
  DetailsTile({
    super.key,
    required this.title_string,
    required this.controller,
    this.hint_text = "",
    this.inputType = TextInputType.text,
  });

  @override
  State<StatefulWidget> createState() {
    return DetailsTileState();
  }

}


class DetailsTileState extends State<DetailsTile> {

  @override
  Widget build(BuildContext context) {

      //* TEXT BASED Return Value
      return Container(
        width: double.infinity,
        height: 100,      
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 235, 235),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [

            SizedBox(height: 15),
            
            
            //* Title Text Prompt
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    widget.title_string,              //* passed parameter                                       
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Inter-Regular',
                      color: Colors.black
                    ),
                  )
                ],
              ),
            ),

            //* Text Field
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: widget.controller,        //* passed parameter
                keyboardType: widget.inputType,       //* passed parameter
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter-Bold',
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint_text,         //* passed parameter
                  hintStyle: TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 14,
                    color: Colors.grey
                  )
                  
                ),
            
              ),
            )


          ],
        ),
      );
    
  }

}