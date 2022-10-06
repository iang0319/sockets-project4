//got this from the test messenger example app
// found here: https://github.com/ethan-thomas0223/text_messenger/blob/master/lib/serializer.dart

import 'package:flutter_application_1/workout_items.dart';

class User {
  String _name;
  String _title;
  Workout _workout;

  User(this._name, this._title, this._workout);

  bool operator ==(Object other) =>
      other is User &&
      other.name == name &&
      other.title == title &&
      other.workout == workout;

  String get name => _name;
  String get title => _title;
  Workout get workout => _workout;

  Map<String, dynamic> toJson() => {
        'name': _name,
        'title': _title,
        'workout': _workout,
      };

  User.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _title = json['title'],
        _workout = json['workout'];
}

class UserStampedMessage {
  String _message;
  User _user;

  UserStampedMessage(this._message, this._user);

  bool operator ==(Object other) =>
      other is UserStampedMessage &&
      other.message == message &&
      other.user == user;

  String get message => _message;
  User get user => _user;

  Map<String, dynamic> toJson() =>
      {'message': _message, 'user': _user.toJson()};

  UserStampedMessage.fromJson(Map<String, dynamic> json)
      : _message = json['message'],
        _user = User.fromJson(json['user']);
}
