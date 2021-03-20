import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isVisibleStationSelector = true;
  bool isVisibleDateSelector = false;
  bool isVisibleTimeSelector = true;
  DateTime selectedDate = DateTime.now();

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
                            isVisibleDateSelector = !isVisibleDateSelector;
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime(2222));
                          });
                        },
                        child: Text('Go to date')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
