
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'modal.dart';


class SearchBar extends StatefulWidget {
  final List<Flight> allresult;
  final String dest;
  final String source;
  final String time;
  final String date;
  final String test;

  const SearchBar({Key? key,required this.test,required this.dest,required this.date, required this.source, required this.time, required this.allresult}): super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState( );
}

class _SearchBarState extends State<SearchBar> {

  late bool loading;
 late final user;

late List<Flight> filterList;

  @override
  void initState() {
    super.initState();
    user=FirebaseAuth.instance.currentUser;
    print("Search bar#############" + user.uid);
    print(widget.test+" "+widget.source+" "+widget.dest);
    setState(() {
      loading = true;
    });
    filter();
    print("Search bar file "+filterList.length.toString());
    loading = false;
  }

  void filter(){
    List<Flight>filter = [];
    print("kjhkjhj#############################"+widget.allresult.length.toString());
    for(var flight in widget.allresult){

      if(flight.source.contains(widget.source) && flight.dest.contains(widget.dest) && flight.date.contains(widget.date)){
        filter.add(flight);
      }
    }
    setState(() {
      filterList = filter;
    });
  }

 final _database=FirebaseDatabase.instance.reference();

int checker(String ch){
    if(ch=="0") return 0;
    else if(ch=="1") return 1;
    else if(ch=="2") return 2;
    else if(ch=="3") return 3;
    else if(ch=="4") return 4;
    else if(ch=="5") return 5;
    else if(ch=="6") return 6;
    else if(ch=="7") return 7;
    else if(ch=="8") return 8;
    else if(ch=="9") return 9;










    return 0;
}

int sol(String num){
    int ans=0;
    for(int i=0;i<num.length;i++){
      ans=ans*10 + checker(num[i]);
    }

    return ans;
}



  Widget buildNotice(Flight book) =>  Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,

      child:Container(



        alignment:Alignment.centerLeft,
        child: Column(

          children: [
            ListTile(

              title:  Center(child: Text("Flight Name : "+book.name)),
              subtitle: Center(child: Text("Soure: "+book.source+" Destination:  "+book.dest)),
            ),
            Text("Flight Number: "+book.flightNumber),
            Text("Scheduled Departure: "+book.time),
            Text("Fare: "+book.fare),
            Text("Available Seats: "+book.seats),
           // Text(book.key),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(

                onPressed: ()async{
                  // int ans=sol(book.seats);
                  // if(ans==0){
                  //   print("jfbg");
                  //
                  // }
                  // else{
                  //   ans--;
                  //   await _database.child("flights").child(book.key).update(
                  //       {'Available_seats':ans.toString()}).whenComplete(() async {
                  //     await _database.child("users").child(user.uid).push().update({
                  //       'name':book.name,
                  //       'flightNumber':book.flightNumber,
                  //       'source':book.source,
                  //       'dest':book.dest,
                  //       'date':book.date,
                  //       'time':book.time
                  //     });
                  //   });

                   // }
                  await _database
                      .child('flights/${book.key}/')
                      .once()
                      .then((DataSnapshot snapshot) async  {
                       // print("##################"+snapshot.value['name'].toString())
                    // ;
                    await _database.child("flights").child(book.key).update(
                              {'Available_seats':(int.parse(snapshot.value['Available_seats'])-1).toString()}).whenComplete(() async {
                            await _database.child("users").child(user.uid).push().update({
                              'name':book.name,
                              'flightNumber':book.flightNumber,
                              'source':book.source,
                              'dest':book.dest,
                              'date':book.date,
                              'time':book.time

                            }).whenComplete(() => {

                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Booked Flight Tickets'))


                            )
                            });
                          });
                  });





                },
                child: Text("Book Flight"),


            ),
            SizedBox(height: 20,)

          ],
        ),
      )
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text("Search"),
          ),
          body: loading
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          )
              : Container(
            color: Colors.blueGrey,
                child: Column(
            children: <Widget>[

                Expanded(
                    child: ListView.builder(
                      itemCount: filterList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildNotice(filterList[index]),
                    )),
            ],
          ),
              ),
        ));
  }
}
