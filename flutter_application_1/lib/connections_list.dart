import 'package:flutter/material.dart';
import 'package:flutter_application_1/connection.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/workout_items.dart';

typedef FriendListChatCallback = Function(Friend item);
typedef FriendListEditCallback = Function(Friend item);

class FriendListItem extends StatelessWidget {
  FriendListItem({
    required this.friend,
    //required this.onListTapped,
    //required this.onListEdited,
  }) : super(key: ObjectKey(friend));

  final Friend friend;
  //final FriendListChatCallback onListTapped;
  //final FriendListEditCallback onListEdited;

  Future<void> testConnection(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Exercise Info'),
            content: SizedBox(
              width: 100,
              height: 250,
              child: Column(children: [
                Text("Workout for the day: ${friend.getMessages()}"),
                /*
                ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: friend.getWorkouts().map((workout) {
                    return ToDoListItem(
                      workout: workout,
                      completed: friend.getWorkouts().contains(workout),
                      //onListChanged: friend.getWorkouts().contains(workout),
                      //onDeleteItem: friend.getWorkouts().contains(workout),
                    );
                  }),
                ),
                */
                //ToDoListItem(
                //workout: friend.getW().first,
                //workout: friend.getMessages(),
                //completed: false,
                //onDeleteItem: ((item) => Navigator.pop(context)),
                //onListChanged: (workout, completed) => true,
                //)
              ]),
            ),
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
    return Card(
        child: ListTile(
      onTap: () {
        //onListTapped(friend);
        //trying to get on tap to pull up messages/workouts received from said friend
        //friend.receive(Message(author: friend.name, content: ));
        testConnection(context);
      },
      onLongPress: () {
        // onListEdited(friend);
      },
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(friend.name[0].toUpperCase()),
      ),
      title: Text(
        friend.name,
      ),
      subtitle: Text(friend.ipAddr),
    ));
  }
}
