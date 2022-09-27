

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late final user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user=FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: Text("Your Booked Flights Here"),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(

          children: <Widget>[
            Flexible(
              child:  FirebaseAnimatedList(
                  query: FirebaseDatabase.instance
                      .reference().child("users/${user.uid}")
                      .orderByChild("name"),

                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,

                        child:Container(


                          alignment:Alignment.centerLeft,
                          child: Column(

                            children: [
                              ListTile(

                                title:  Center(child: Text( snapshot.value['name'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),),
                                subtitle: Center(child: Text("Source: "+snapshot.value['source'].toString()+"  <-->  Destination:  "+snapshot.value['dest'].toString())),
                              ),
                              Text("Flight Number: "+snapshot.value['flightNumber'].toString()),
                              Text("Scheduled Departure: "+snapshot.value['date'].toString()),
                             // Text("Fare: "+snapshot.value['fare'].toString()),
                             // Text("Available Seats: "+snapshot.value['Available_seats'].toString()),
                              SizedBox(
                                height: 50,
                              ),

                              SizedBox(height: 20,)

                            ],
                          ),
                        )
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
