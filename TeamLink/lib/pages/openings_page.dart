// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_register/pages/view_opening_page.dart';
import 'package:login_register/pages/went_wrong_page.dart';

class OpeningsPage extends StatefulWidget {

  //* According to firestore documentation:
  @override
  OpeningsPageState createState() => OpeningsPageState();

}


class OpeningsPageState extends State<OpeningsPage> {

  // QUERY to Firestore DB
  final Stream<QuerySnapshot> streamQuery = FirebaseFirestore.instance.collection('openings').orderBy('timestamp', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: streamQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(
            strokeWidth: 6,
            color: Colors.amberAccent, 
          ));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Icon(Icons.work_rounded),
            toolbarHeight: 80,
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: Text(
              "Openings"
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ListTile(
                          minLeadingWidth: 10,
                          tileColor: Color.fromARGB(150, 105, 240, 175),
                          splashColor: Color.fromARGB(130, 255, 255, 255),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //* TITLE
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),                              
                              Text(
                                data['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Inter-Bold'
                                ),
                              )
                            ],
                          ),
                          //* DESCRIPTION
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),                              
                              Text(
                                data['description'],
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter-Regular'
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ViewOpening(
                                  title: data['title'], 
                                  description: data['description'],
                                  secondaryDescription: data['second_description'],
                                  url: data['url'],
                              )),
                            );
                          },
                        ),
                      );

                    })
                    .toList()
                    .cast(),
              ),
            ),
          ),
        );
      },
    );

  }

}