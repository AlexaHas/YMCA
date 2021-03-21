import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'dart:io';
//import 'dart:io';
import 'package:shape_of_view/shape_of_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

class Album {
  final String userId;

  Album({@required this.userId});

  factory Album.fromJson(Map<String, dynamic> json) {
    print("==========");
    //print(json['userId']);
    print("==========");
    //return Album(
    //userId: json['userId'],
    //);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isVisibleStationSelector = true;
  bool isVisibleDateSelector = false;
  bool isVisibleTimeSelector = false;
  bool isVis = false;
  bool isOutputVis = false;

  String output = "test";

  Color theme = Color.fromARGB(255, 235, 0, 0);

  String url = 'localhost:5000  ';
  //String url_2 = "https://jsonplaceholder.typicode.com/posts";

  String choosenStation = "";
  String choosenDate = "";
  String choosenTime = "";

  String output_def = "";

  Color output_C;

  //List<Widget> list = new List<Widget>();
  List<Widget> list = new List(7);

  back(bool from, bool to) {
    setState(() {
      from = !from;
      to = !to;
    });
  }

  //Future<Album>
  fetchAlbum() async {
    final response = await http.get(Uri.http(url, '/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
      // then parse the JSON.
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> classifyStation(String sn, String time) async {
    print(sn);
    print(time);
    var queryParameters = {
      "station_name": sn,
      "time": time,
      //"2020-08-01T04:00:00+02:00"
    };
    var requestUri = Uri.http(url, '/classify', queryParameters);

    final response = await http.get(requestUri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print("Result of classification: " + response.body);
      var classificationResult = response.body;
      output = classificationResult;

      // "free", "little", "medium", "high"
      setState(() {
        switch (output) {
          case "free":
            {
              output_C = Colors.green;
              output_def = "Almost all spaces available";
            }
            break;
          case "little":
            {
              output_C = Colors.yellow;
              output_def = "Most spaces available";
            }
            break;
          case "medium":
            {
              output_C = Colors.orange;
              output_def = "Few spaces available";
            }
            break;
          case "high":
            {
              output_C = Colors.red;
              output_def = "Almost no spaces available";
            }
            break;
        }

        isVis = !isVis;
        isOutputVis = !isOutputVis;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to classify');
    }
  }

  Future<void> searchStation(String input) async {
    var queryParameters = {
      "searchTerm": input,
    };
    var requestUri = Uri.http(url, '/search', queryParameters);

    final response = await http.get(requestUri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print("Result of search: " + response.body);

      var searchResult = response.body;

      try {
        final parsed = json.decode(searchResult);
        //print(parsed);

        print(parsed['Stations']);
        for (String s in parsed['Stations']) {
          print(s);
          ElevatedButton eb =
              new ElevatedButton(onPressed: () {}, child: Text(s));

          list.add(eb);
        }
      } on FormatException catch (e) {
        print("That string didn't look like Json.");
      } on NoSuchMethodError catch (e) {
        print('That string was null!');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed search');
    }
  }

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

  final myController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background shape
          ShapeOfView(
            elevation: 50,
            height: 350,
            shape: DiagonalShape(
                position: DiagonalPosition.Bottom,
                direction: DiagonalDirection.Right,
                angle: DiagonalAngle.deg(angle: 10)),
            child: Container(
              decoration: BoxDecoration(
                color: theme,
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          ///////////////////////

          // Contains the front layout
          Container(
            width: width,
            height: height,

            // widgets are arranged in order
            child: Column(
              children: [
                new SizedBox(
                  width: 10.0,
                  height: 350.0,
                ),
                Visibility(
                  visible: isVisibleStationSelector,
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
                          controller: myController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: theme,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: theme,
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
                            primary: theme,
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            setState(() {
                              //Text("${selectedDate.toLocal()}".split(' ')[0]),
                              choosenStation = myController.text;
                              isVisibleStationSelector =
                                  !isVisibleStationSelector;
                              isVisibleDateSelector = !isVisibleDateSelector;
                              searchStation(choosenStation);
                              //fetchAlbum();
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
                          primary: theme, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          setState(() {
                            _selectDate(context);
                            isVisibleDateSelector = !isVisibleDateSelector;
                            isVisibleTimeSelector = !isVisibleTimeSelector;
                          });
                        },
                        child: Text('Select date'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          setState(() {
                            isVisibleStationSelector =
                                !isVisibleStationSelector;
                            isVisibleDateSelector = !isVisibleDateSelector;
                          });
                        },
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
                          primary: theme, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          setState(() {
                            _selectTime(context);
                            isVisibleTimeSelector = !isVisibleTimeSelector;
                            isVis = !isVis;
                          });
                        },
                        child: Text('Select hour'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          setState(() {
                            isVisibleDateSelector = !isVisibleDateSelector;
                            isVisibleTimeSelector = !isVisibleTimeSelector;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isVis,
                  child: Column(
                    children: [
                      // Search for Station Input Field

                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: theme, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          choosenDate = selectedDate.toString();
                          choosenTime = selectedTime.toString();

                          choosenDate = choosenDate.substring(0, 10);
                          choosenTime =
                              choosenTime.substring(10, choosenTime.length - 1);
                          classifyStation(
                              choosenStation, choosenDate + 'T' + choosenTime);
                        },
                        child: Text('Find'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          setState(() {
                            isVisibleTimeSelector = !isVisibleTimeSelector;
                            isVis = !isVis;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isOutputVis,
                  child: Column(children: [
                    Text('Station: ' + choosenStation),
                    Text('Date: ' + choosenDate),
                    Text('Time: ' + choosenTime),
                    new SizedBox(
                      width: 10.0,
                      height: 150.0,
                    ),
                    new Container(
                      height: 50.0,
                      width: 50.0,
                      color: output_C,
                    ),
                    new SizedBox(
                      width: 10.0,
                      height: 50.0,
                    ),
                    Text(
                      output_def,
                      style: TextStyle(color: Colors.black),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          isVisibleStationSelector = true;
                          isVisibleDateSelector = false;
                          isVisibleTimeSelector = false;
                          isVis = false;
                          isOutputVis = false;
                        });
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
