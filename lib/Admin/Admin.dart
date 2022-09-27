
import 'package:flutter/material.dart';

import 'AdminFlight.dart';
import 'ViewFlights.dart';
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title:Text("Admin Dashboard"),

      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                SizedBox(height: 100,),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFlights(name: "Madhav mishra",)),
                  ),
                  child:  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: const SizedBox(
                      width: 300,
                      height: 100,
                      child: Center(child: Text('Add Flights',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewFlights()),
                  ),
                  child:  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: const SizedBox(
                      width: 300,
                      height: 100,
                      child: Center(child: Text('View/Edit Flight Details',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}