import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isVisibleStationSelector = true;
  bool isVisibleDateSelector = true;
  bool isVisibleTimeSelector = true;

  DateTime selectedDate = DateTime.now();

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
    return MaterialApp(
      title: 'Park+Rail',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Park+Rail'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select date'),
              ),
            ],
          ),
        ),

        /*Center(
          child: Column(
            children: [
              Visibility(
                visible: isVisibleStationSelector,
                //maintainState: true,
                child: Column(
                  children: [
                    // Search for Station Input Field
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a search term'),
                    ),
                    // Submit station input
                    ElevatedButton(
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
                child: Column(
                  children: [
                    // Show widget for choosing a date
                    Text('Time picker'),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            //isVisibleDateSelector = !isVisibleDateSelector;
                          });
                        },
                        child: Text('Go to date')),
                  ],
                ),
              ),
            ],
          ),
        ),*/
      ),
    );
  }
}
