import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(DatePickerTask());

class DatePickerTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.amber,
          ),
          child: Builder(
            builder: (c) => FloatingActionButton(
                child: Icon(Icons.date_range),
                onPressed: () => _handleDatePicker(c)),
          ),
        ),
        appBar: AppBar(title: Text('Date Picker Example')),
        body: Center(
            child: Builder(
          builder: (con) => RaisedButton(
            textColor: Theme.of(context).accentTextTheme.display1.color,
            color: Theme.of(context).primaryColor,
            child: Text('Choose a starting date'),
            onPressed: () => showDatePicker(
              context: con,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(days: 30)),
              lastDate: DateTime.now().add(Duration(days: 30)),
            ),
          ),
        )),
      ),
    );
  }

  Future<Null> _handleDatePicker(BuildContext floatContext) async {
    final dateResult = await showDatePicker(
        context: floatContext,
        firstDate: DateTime.now(),
        initialDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now().add(Duration(days: 60)));

    //prints the chosen date from the picker
    print(dateResult);
  }
}
