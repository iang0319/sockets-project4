import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Workout workout, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({
    required this.workout,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteItem,
  }) : super(key: ObjectKey(workout));

  Workout workout;
  bool completed;
  ToDoListChangedCallback onListChanged;
  ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.none,
    );
  }

  Future<void> _displayWorkoutInfo(BuildContext context) async {
    print("Showing information");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Exercise Info'),
            content: Column(children: [
              Text("Exercise: ${workout.name}"),
              Text("Sets: ${workout.sets}"),
              Text("Reps: ${workout.reps}"),
            ]),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("Leave"),
                child: const Text('Leave'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _displayWorkoutInfo(context);
      },
      onLongPress: () {
        onListChanged(workout, completed);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(workout.abbrev()),
      ),
      title: Text(
        workout.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

class Workout {
  Workout({required this.name, required this.reps, required this.sets});
  String name;
  String sets;
  String reps;

  String abbrev() {
    return name.substring(0, 1);
  }

  //got this from the test messenger example app
// found here: https://github.com/ethan-thomas0223/text_messenger/blob/master/lib/serializer.dart

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
      };

  Workout.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        sets = json['title'],
        reps = json['workout'];
}
