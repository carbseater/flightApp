import 'dart:io';
 import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFlights extends StatefulWidget {
  String name;
  AddFlights({required this.name});

  @override
  _AddFlightsState createState() => _AddFlightsState();
}

class _AddFlightsState extends State<AddFlights> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: MyCustomForm(),
      ),
    );
  }
}




class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  TextEditingController timeinput = TextEditingController();
  //text editing controller for text field
  TextEditingController timeinput2 = TextEditingController();
  final _database = FirebaseDatabase.instance.reference();
  Future<void> _inputUserEventData() async {
    final nextEvent = <String, dynamic>{
      'name':name,
      'flightNumber':flightNumber,
      'fare':fare,
      'date':showTime,
      'scheduled_departure':timeinput,
      'scheduled_arrival':timeinput2

    };

    //pushing pending events

     await _database.child("/flights").push().update(nextEvent);

  }


  DateTime time_slot = DateTime.now();
  String source="";
  String dest="";

  String selected_slot = "C";
  String final_selected_time = "";
  String showTime = "";
  DateTime currentDate = DateTime.now();

  bool already_slot_exist = false;
  String fare="";
  String name="";
  String flightNumber="";

  String seats="";





  Future<void> _selectDate(BuildContext context) async {
    print("Time selected#############");
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null)
      setState(() {
        already_slot_exist = false;
        time_slot = pickedDate;
        showTime = DateFormat('yyyy-MM-dd').format(time_slot);
      });
  }




  @override
  void initState() {

    timeinput.text = "";
    timeinput2.text = "";
    //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: Text("Add New Flights Here"),
      ),
      body: ListView(
        children:[ Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your full name',
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }

                    },
                    onChanged: (val){
                      setState(() {
                        name=val;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Flight Number',
                      labelText: 'Flight Number',
                    ),


                    onChanged: (val){
                      setState(() {
                        flightNumber=val;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.location_city),
                      hintText: 'Source point',
                      labelText: 'Source',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }

                    },
                    onChanged: (val){
                      setState(() {
                        source=val;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.location_disabled),
                      hintText: 'Destination Point',
                      labelText: 'Destination',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }

                    },
                    onChanged: (val){
                      setState(() {
                        dest=val;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.access_time_filled),
                      hintText: 'Total Seats ',
                      labelText: 'Total Seats',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter valid Flight Number';
                      }

                    },
                    // keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        seats=val ;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.monetization_on),
                      hintText: 'Fare ',
                      labelText: 'Fare',
                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter valid date';
                      }

                    },
                    onChanged: (val){
                      setState(() {
                        fare=val;
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
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          await _database.child("/flights").push().update({
                            'name':name,
                            'flightNumber':flightNumber,
                            'fare':fare,
                            'date':showTime,
                            'scheduled_departure':timeinput.text,
                            'source':source,
                            'dest':dest,
                            'total_seats':seats,
                            'Available_seats':seats


                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),

                          );
                        }

                      },
                      child: Text("Submit"))


                ],
              ),
            ),
          ),
        ),
    ]
      ),
    );
  }
}