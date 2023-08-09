// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_register/pages/view_opening_page.dart';
import 'package:login_register/pages/went_wrong_page.dart';

class FeedsPage extends StatefulWidget {

  //* According to firestore documentation:
  @override
  FeedsPageState createState() => FeedsPageState();

}


class FeedsPageState extends State<FeedsPage> {

  // QUERY to Firestore DB
  final Stream<QuerySnapshot> streamQuery = FirebaseFirestore.instance.collection('feed').orderBy('timestamp', descending: true).snapshots();

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
          backgroundColor: Color.fromARGB(255, 223, 241, 245),
          appBar: null, /*AppBar(
            automaticallyImplyLeading: false,
            leading: Icon(Icons.home),
            toolbarHeight: 80,
            backgroundColor: Colors.greenAccent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: Text(
              "Feed Page"
            ),
          ),*/
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {

                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              //* IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  data['image_url'],
                                  fit: BoxFit.cover,
                                )
                              ),

                              SizedBox(height: 15),

                              //* CAPTION
                              Text(
                                data['caption'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Inter-Bold'
                                ),
                              ),

                              SizedBox(height: 15),

                              Text(
                                data['description'],
                                maxLines: 5,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Inter-Regular'
                                ),
                              ),

                              SizedBox(height: 15),

                            ],
                          ),                          
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