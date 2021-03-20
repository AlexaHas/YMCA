import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park+Rail',
      home: MyHomePage(title: 'Park+Rail'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isVisibleStationSelector = true;
  bool isVisibleDateSelector = false;
  bool isVisibleTimeSelector = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Visibility(
                    visible: isVisibleStationSelector,
                    //maintainState: true,
                    child: Column(
                      children: [
                        new SizedBox(
                          width: 10.0,
                          height: 70.0,
                        ),
                        // Search for Station Input Field
                        new SizedBox(
                          width: 300.0,
                          height: 200.0,
                          child: TextField(
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              //const EdgeInsets.all(8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              hintText: 'Search for a station',
                            ),
                          ),
                        ),
                        // Submit station input
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () {
                              setState(() {
                                isVisibleStationSelector =
                                    !isVisibleStationSelector;
                                isVisibleDateSelector = !isVisibleDateSelector;
                              });
                            },
                            child: Text('Search')),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isVisibleDateSelector,
                    //maintainState: true,
                    child: Column(
                      children: [
                        // Search for Station Input Field
                        //Text("${selectedDate.toLocal()}".split(' ')[0]),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            _selectDate(context);
                            isVisibleDateSelector = !isVisibleDateSelector;
                            isVisibleTimeSelector = !isVisibleTimeSelector;
                          },
                          child: Text('Select date'),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isVisibleTimeSelector,
                    //maintainState: true,
                    child: Column(
                      children: [
                        // Search for Station Input Field
                        //Text("${selectedTime.toLocal()}".split(' ')[0]),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Text('Select hour'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height: 450.0,
              width: 350.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1.0, 1.0),
                      blurRadius: 1.0,
                      spreadRadius: 0.5,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
