// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOpening extends StatefulWidget {
  final String title;
  final String description;
  final String secondaryDescription;
  final String url;

  const ViewOpening(
      {super.key,
      required this.title,
      required this.description,
      required this.secondaryDescription,
      required this.url});

  @override
  State<StatefulWidget> createState() {
    return ViewOpeningState();
  }
}

class ViewOpeningState extends State<ViewOpening> {

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(widget.url))) {
      CouldnotLaunchUrlError();
    }
  }

  // ERROR FUNCTIONS:
  void CouldnotLaunchUrlError() {
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
                'Couldn\'t open given URL!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.greenAccent,        // TODO: CHANGE COLOR TO LIST TILE COLOR
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text("View Opening"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 90, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 45,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 30, fontFamily: 'Inter-Bold'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: 30,),

              Divider(),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontFamily: 'Inter-Regular', height: 1.5),
                  overflow: TextOverflow.fade,
                ),
              ),

              SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.secondaryDescription,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontFamily: 'Inter-Regular', height: 1.5),
                  overflow: TextOverflow.fade,
                ),
              ),

              SizedBox(height: 45,),

              Container(
                child: (widget.url == "") ? null : 
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
              
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(200, 68, 137, 255))
                        ),
                        onPressed:  () {
                          //* LAUNCH THE URL GIVEN TO THE POST:
                          _launchUrl();
                        }, 
                        child: Container(
                          width: 120,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("External Link"),
                              Icon(Icons.link),
                          ]),
                        ),
                      ),
                      
                    )
              
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
