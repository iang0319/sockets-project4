import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/workout_items.dart';
import 'package:flutter_application_1/connection.dart';
import 'package:flutter_application_1/text.dart';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

import 'connections_list.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(), // becomes the route named '/'
      routes: <String, WidgetBuilder>{
        '/join': (BuildContext context) =>
            JoinPage(title: 'Join Page'), //Join Page
        '/build': (BuildContext context) => ToDoList(), //Build Page
        '/home': (BuildContext context) =>
            HomePage(title: 'Leveler'), //Home Page
      },
    ),
  );
}

//Test comment

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movement Pro App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 213, 107, 19),
            ), //button color
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.black,
            ),
          ),
        ),
      ),
      home: const HomePage(title: 'Movement Pro'),
    );
  }
}

//Build Homepage Here
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  // onPressed move to these states/pages
  void _openBuild() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ToDoList(),
      ),
    );
  }

  void _openJoin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JoinPage(title: 'Join Page'),
      ),
    );
  }

//Homesceen
  Widget build(BuildContext context) {
    // TODO: implement build
    //things
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        //top banner colors
        backgroundColor: Color.fromARGB(255, 213, 107, 19),
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/MP.pnc.jpeg',
              width: 500,
              height: 300,
            ),
            Container(
              width: 300,
              height: 100,
            ),
            Container(
              width: 300, // <-- Your width
              height: 100,
              child: ElevatedButton(
                key: const Key('BButton'),
                onPressed: _openBuild,
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 25,
                    shadowColor: Color.fromARGB(255, 118, 118, 118)),
                child: const Text('Build a Workout'),
              ),
            ),
            Container(
              width: 300,
              height: 100,
            ),
            Container(
              width: 300, // <-- Your width
              height: 100,
              child: ElevatedButton(
                key: const Key('JButton'),
                onPressed: _openJoin,
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 25,
                    shadowColor: Color.fromARGB(255, 118, 118, 118)),
                child: const Text('Join a Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Build Join Page Here
class JoinPage extends StatefulWidget {
  const JoinPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _JoinPageState();
}

//page needs an alert Dialogue first for password authentication
//Then needs to display workout sent from server
class _JoinPageState extends State<JoinPage> {
  String? _ipaddress = "Loading...";
  bool _isObscure = true;
  late StreamSubscription<Socket> server_sub;
  late Friends _friends;
  late List<DropdownMenuItem<String>> _friendList;
  late TextEditingController _nameController,
      _ipController,
      _passwordController;

  @override
  void initState() {
    super.initState();
    _friends = Friends();
    _nameController = TextEditingController();
    _ipController = TextEditingController();
    _passwordController = TextEditingController();
    _setupServer();
    _findIPAddress();
  }

  Future<void> _setupServer() async {
    try {
      ServerSocket server =
          await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server_sub = server.listen(_listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  void _listenToSocket(Socket socket) {
    socket.listen((data) {
      setState(() {
        _handleIncomingMessage(socket.remoteAddress.address, data);
      });
    });
  }

  void _handleIncomingMessage(String ip, Uint8List incomingData) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    _friends.receiveFrom(ip, received);
  }

  void addNew() {
    setState(() {
      _friends.add(_nameController.text, _ipController.text);
    });
  }

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 25,
      shadowColor: Color.fromARGB(255, 118, 118, 118),
      backgroundColor: Colors.green);

  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      elevation: 25,
      shadowColor: Color.fromARGB(255, 118, 118, 118),
      backgroundColor: Colors.red);

  //Get IP Address of device
  Future<void> _findIPAddress() async {
    // Thank you https://stackoverflow.com/questions/52411168/how-to-get-device-ip-in-dart-flutter
    String? ip = await NetworkInfo().getWifiIP();
    setState(() {
      _ipaddress = "My IP: " + ip!;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    _nameController.text = "";
    _ipController.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add A Friend'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextEntry(
                    width: 200,
                    label: "Name",
                    inType: TextInputType.text,
                    controller: _nameController),
                TextEntry(
                    width: 200,
                    label: "IP Address",
                    inType: TextInputType.number,
                    controller: _ipController),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    addNew();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  //Found out how to make password icon at https://www.kindacode.com/article/flutter-show-hide-password-in-textfield-textformfield/
  Future<void> _enterPassword(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Password Here"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    )),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    addNew();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _viewConnections() async {
    return showDialog(
        context: context,
        builder: (context) {
          return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: _friends.map((name) {
                return FriendListItem(
                  friend: _friends.getFriend(name)!,
                  //onListTapped: _handleChat,
                  //onListEdited: _handleEditFriend,
                );
              }).toList());
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                key: const Key("Connection"),
                onPressed: () async {
                  await _displayTextInputDialog(context);
                },
                child: const Text("Make connection")),
            ElevatedButton(
              key: const Key("Password"),
              child: const Text('Enter Password'),
              onPressed: () async {
                await _enterPassword(context);
              },
            ),
            ElevatedButton(
                key: const Key("View Connections"),
                onPressed: () async {
                  await _viewConnections();
                },
                child: const Text("View Connections"))
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: double.infinity,
              child: Text(
                _ipaddress!,
                textAlign: TextAlign.center,
              ))),
    );
  }
}

//Workout or Build page, based on ToDoList App
class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final Key key1 = const Key("Exercise");
  final Key key2 = const Key("Sets");
  final Key key3 = const Key("Reps");
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Color.fromARGB(255, 213, 107, 19));
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Color.fromARGB(255, 213, 107, 19));

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add exercise'),
            content: Column(children: <Widget>[
              Text("Exercise"),
              TextField(
                key: Key('exKey'),
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _inputController,
                decoration: const InputDecoration(hintText: "type"),
              ),
              Text("Sets"),
              TextField(
                key: Key('setsKey'),
                keyboardType: TextInputType.number,
                onChanged: (value2) {
                  setState(() {
                    sets = value2;
                  });
                },
                controller: _setsController,
                decoration: const InputDecoration(hintText: "type"),
              ),
              Text("Reps"),
              TextField(
                key: Key('repsKey'),
                keyboardType: TextInputType.number,
                onChanged: (value3) {
                  setState(() {
                    reps = value3;
                  });
                },
                controller: _repsController,
                decoration: const InputDecoration(hintText: "type"),
              )
            ]),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OkButton"),
                style: yesStyle,
                child: const Text('Add'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText, sets, reps);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  String sets = "";

  String reps = "";

  static final List<Workout> workouts = [
    Workout(name: "Example", reps: "5", sets: "3")
  ];

  static final _workoutSet = <Workout>{};

  void _handleListChanged(Workout workout, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      workouts.remove(workout);
      if (!completed) {
        print("Completing");
        _workoutSet.add(workout);
        workouts.add(workout);
      } else {
        print("Making Undone");
        _workoutSet.remove(workout);
        workouts.insert(0, workout);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
    });
  }

  void _handleNewItem(String itemText, String set, String rep) {
    setState(() {
      print("Adding new item");
      Workout workout_base = Workout(name: itemText, reps: rep, sets: set);
      workouts.insert(0, workout_base);
      _inputController.clear();
      _setsController.clear();
      _repsController.clear();
    });
  }

  // no idea what return type this is
  _sendW(List<Workout> workouts, String loc) {
    //takes in workout list then loops through each movement
    //converts each to json then sends message

    Friend f = Friend(ipAddr: loc, name: 'self');
    for (int i = 0; i < workouts.length; i++) {
      Map<String, dynamic> x = workouts[i].toJson();
      Message message = Message(author: valueText, content: x);
      f.send(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Creator'),
          backgroundColor: Color.fromARGB(255, 213, 107, 19),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: workouts.map((workout) {
            return ToDoListItem(
              workout: workout,
              completed: _workoutSet.contains(workout),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  //i see this producing a bug
                  //recipient is hard coded as ourself rn
                  onPressed: _sendW(workouts, '$ourPort'),
                  child: const Text(
                    "Send Workout",
                    textAlign: TextAlign.center,
                  ))
            ])),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}
