//Got this class from the text_messenger demo

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/workout_items.dart';

import 'package:mutex/mutex.dart';

const int ourPort = 8888;
//const int ourPort = 35119 got an error with this port on student
//const int ourPort = 35123; //got an error with this port on IOT - keeps chaning port that error originates from
final m = Mutex();

class Friends extends Iterable<String> {
  Map<String, Friend> _names2Friends = {};
  Map<String, Friend> _ips2Friends = {};

  void addFriend(String name, String ip) {
    Friend f = Friend(ipAddr: ip, name: name);
    _names2Friends[name] = f;
    _ips2Friends[ip] = f;
  }

  String? ipAddr(String? name) => _names2Friends[name]?.ipAddr;

  Friend? getFriend(String? name) => _names2Friends[name];

  void receiveFrom(String ip, String mess) {
    print("receiveFrom($ip, $mess)");
    if (!_ips2Friends.containsKey(ip)) {
      String newFriend = "Friend${_ips2Friends.length}";
      print("Adding new friend");
      addFriend(newFriend, ip);
      print("added $newFriend!");
    }

    //_ips2Friends[ip]!.receive(Message(author: mess,content: Workout(name: mess, reps: '0', sets: '0').toJson()));
    _ips2Friends[ip]!.receive(mess);
  }

  @override
  Iterator<String> get iterator => _names2Friends.keys.iterator;
}

class Friend extends ChangeNotifier {
  final String ipAddr;
  final String name;
  final List<Workout> _messages = [];

  Friend({required this.ipAddr, required this.name});

  Future<void> send(String message) async {
    Socket socket = await Socket.connect(ipAddr, ourPort);
    socket.write(message);
    socket.close();
    //await _add_message("Me", message);
  }

  Future<void> receive(String message) async {
    Map<String, dynamic> workout = jsonDecode(message);
    Workout recovered = Workout.fromJson(workout);
    return _add_message(name, recovered);
  }

  //message was originally a String, now contains a Workout = Message
  Future<void> _add_message(String name, Workout message) async {
    await m.protect(() async {
      _messages.add(message);
      //_messages.add(Message(author: name, content: message));

      notifyListeners();
    });
  }

  /*
  String history() => _messages
      .map((m) => m.transcript)
      .fold("", (message, line) => message + '\n' + line);
  */
}

class Message {
  //late Map<String, dynamic> content;
  String content;
  final String author;

  //const Message({required this.author, required this.content});
  Message({required this.author, required this.content});

  String get transcript => '$author: $content';
}
