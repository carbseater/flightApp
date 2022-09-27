

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ViewFlights extends StatefulWidget {
  const ViewFlights({Key? key}) : super(key: key);

  @override
  State<ViewFlights> createState() => _ViewFlightsState();
}

class _ViewFlightsState extends State<ViewFlights> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: Text("All Operating Flights Here"),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(

          children: <Widget>[
             Flexible(
              child:  FirebaseAnimatedList(
                  query: FirebaseDatabase.instance
                      .reference().child("flights")
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
                            Text("Scheduled Departure: "+snapshot.value['scheduled_departure'].toString()),
                            Text("Fare: "+snapshot.value['fare'].toString()),
                            Text("Available Seats: "+snapshot.value['Available_seats'].toString()),
                            SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(


                                onPressed: ()=>{
                                  FirebaseDatabase.instance
                                      .reference().child("flights").child(snapshot.key!).remove()


                                },
                                child: Text("Remove"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey
                              ),
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
