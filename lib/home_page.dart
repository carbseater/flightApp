import 'dart:html';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:appnewui/Search/History.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Search/modal.dart';
import '../Search/search_bar.dart';


import 'Admin/Admin.dart';

class UserPage extends StatefulWidget {


  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Flight> _allResults = [];

  @override
  void initState(){
    print("Init state");
    getNotices();

  }
  getNotices() async {
    List<Flight> list = [];

    final database = FirebaseDatabase.instance.reference();
    var snap = await database.child('flights').once();
    Map<dynamic, dynamic> result = snap.value;
    print("Function started");
    result.forEach((key, value) {
      Map<dynamic, dynamic> map = value;
      list.add(Flight(
          seats:map['Available_seats'],
          flightNumber: map['flightNumber'],
          time: map['scheduled_departure'],
          name: map['name'],
          source: map['source'],
          dest: map['dest'],
          date: map['date'],
          key: key,
          fare: map['fare']
      ));

    });

    setState(() {
      _allResults = list;

    });
    print("Length######## "+ _allResults.length.toString());
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: MyCustomForm(allresult: _allResults,),
      ),
    );
  }
}




class MyCustomForm extends StatefulWidget {
  List<Flight> allresult;
  MyCustomForm({required this.allresult});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  late bool loading;
  @override
  late var user;
  void initstate(){
    super.initState();
    print("Home page initstate");
    timeinput.text = "";
    user=FirebaseAuth.instance.currentUser;


  }


  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.reference();



  DateTime time_slot = DateTime.now();
  String final_selected_time = "";
  String showTime = "";
  DateTime currentDate = DateTime.now();
  String source = "";
  String dest =  "";
  String username="";
  String password="";
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Admin credentials here'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },

              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              ElevatedButton(

                child: Text('Submit'),
                onPressed: () {
                  if(password=="0005"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboard()),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong Credentials')));
                  }
                }
              ),

            ],
          );
        });
  }


  Future<void> _selectDate(BuildContext context) async {
    print("Time selected#############");
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null)
      setState(() {

        time_slot = pickedDate;
        showTime = DateFormat('yyyy-MM-dd').format(time_slot);
      });
  }

  TextEditingController timeinput = TextEditingController();
  //text editing controller for text field
  TextEditingController timeinput2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text("Flight Booking"),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Increase volume by 10',
            onPressed: () {
              _displayTextInputDialog(context);

            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Increase volume by 10',
            onPressed: () =>FirebaseAuth.instance.signOut(),




          ),

        ],
      ),
      body:ListView(
        children:[ Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("Search Flights here !",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child:  Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            TextFormField(
                              decoration: const InputDecoration(
                                icon: const Icon(Icons.person),
                                labelText: 'Source',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }

                                source=value;
                              },
                              onChanged: (val) {
                                setState(() {
                                  source = val;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                icon: const Icon(Icons.phone),

                                labelText: 'Destination',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid Flight Number';
                                }
                                dest=value;
                              },
                              onChanged: (val) {
                                setState(() {
                                  dest = val;
                                });
                              },
                            ),

                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          _selectDate(context);
                                        },
                                        icon: Icon(
                                          Icons.calendar_today,
                                          color: Colors.purple,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                        ),
                                        child: Text(
                                          (showTime != "")
                                              ? showTime
                                              : "Select Date",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            TextField(
                              controller: timeinput, //editing controller of this TextField
                              decoration: InputDecoration(
                                  icon: Icon(Icons.timer), //icon of text field
                                  labelText: "Scheduled Departure Time" //label text of field
                              ),
                              readOnly: true,  //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime =  await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );

                                if(pickedTime != null ){
                                  print(pickedTime.format(context));   //output 10:51 PM
                                  DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                                  //converting to DateTime so that we can further format on different pattern.
                                  print(parsedTime); //output 1970-01-01 22:53:00.000
                                  String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                                  print(formattedTime); //output 14:59:00
                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                  setState(() {
                                    timeinput.text = formattedTime; //set the value of text field.
                                  });
                                }else{
                                  print("Time is not selected");
                                }
                              },
                            ),

                            ElevatedButton(
                                onPressed: (){
                                  print(source+dest+"##########");
                                  Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => SearchBar(
                                        allresult : widget.allresult,
                                        test: "Madhav mishras",
                                        source: source,
                                        dest: dest,
                                        time: timeinput.text,
                                        date: showTime,

                                      )));
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(50),
                                    primary: Colors.blueGrey
                                ),
                                child: Text("     Submit     "))


                          ],
                        ),
                      ),

                    ),
                  ),

                ),
              ),
              SizedBox(height: 20),
              Text("Your Booked Flights Here",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
              SizedBox(height: 20),
              ElevatedButton(onPressed: ()=>{

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                ),
              },
                  style: ElevatedButton.styleFrom(
                      //minimumSize: Size.fromHeight(50),
                      primary: Colors.blueGrey
                  ),
                  child: Text("--Look your booked Flights --"))

              // Container(
              //   color: Colors.blueGrey,
              //   child: Column(
              //
              //     children: <Widget>[
              //       Flexible(
              //         child:  FirebaseAnimatedList(
              //             query: FirebaseDatabase.instance
              //                 .reference().child("users"),
              //
              //
              //             padding: EdgeInsets.all(8.0),
              //             reverse: false,
              //             itemBuilder: (_, DataSnapshot snapshot,
              //                 Animation<double> animation, int x) {
              //               return Card(
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                   elevation: 10,
              //
              //                   child:Container(
              //
              //                     height: 220,
              //                     alignment:Alignment.centerLeft,
              //                     child: Column(
              //
              //                       children: [
              //                         ListTile(
              //
              //                           title:  Center(child: Text("Flight Name : "+snapshot.value['name'].toString())),
              //                           subtitle: Center(child: Text("Soure: "+snapshot.value['source'].toString()+" Destination:  "+snapshot.value['dest'].toString())),
              //                         ),
              //                         Text("Flight Number: "+snapshot.value['flightNumber'].toString()),
              //                         Text("Scheduled Departure: "+snapshot.value['scheduled_departure'].toString()),
              //                         Text("Fare: "+snapshot.value['fare'].toString()),
              //                         SizedBox(
              //                           height: 50,
              //                         ),
              //                         ElevatedButton(
              //
              //                             onPressed: ()=>{
              //                               FirebaseDatabase.instance
              //                                   .reference().child("flights").child(snapshot.key!).remove()
              //
              //
              //                             },
              //                             child: Text("Remove")
              //                         )
              //
              //                       ],
              //                     ),
              //                   )
              //               );
              //             }
              //         ),
              //       ),
              //     ],
              //   ),
              // ),


            ],
          ),
        ),
    ]
      )
    );
  }
}