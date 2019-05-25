import 'package:flutter/material.dart';
import '../auth/loginuser.dart';
import '../db/userdb.dart';
import 'dart:convert';
import 'dart:async';
import '../db/friendmodel.dart';
// import './friendPage.dart';
import './friendtodo.dart';
import 'package:http/http.dart' as http;

class AllFriend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FriendState();
  }
}

Future<List<Friend>> friends() async {
  var response = await http.get("https://jsonplaceholder.typicode.com/users");
  List<Friend> allfriend = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      allfriend.add(Friend.fromJson(body[i]));
      // print(allfriend[i].name);
    }
    return allfriend;
  } else {
    throw Exception('error getting API');
  }
}

ListView friendname(BuildContext context, AsyncSnapshot snapshot) {
  return ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
      Friend friend = snapshot.data[index];
      return Card(
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Center(child: Text('${friend.id} : ${friend.name}')),
                // subtitle: Text(friend.email),
                // trailing: Text(friend.website),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(friend.email),
                    ),
                    Container(
                      child: Text(friend.phone),                      
                    ),
                    Container(
                      child: Text(friend.website),
                    ),
                  ],
                ),
              )
            ],
          ),
          onTap: () {
            print('${friend.id}:${friend.name}');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendTodo(
                          id: friend.id,
                        )));
          },
        ),
      );
    },
  );
}

FutureBuilder list() {
  return FutureBuilder(
    future: friends(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            return Column(
              children: <Widget>[
                FlatButton(
                  child: Text("Back", style: TextStyle(color: Colors.white,)),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).pop('/home');
                  },
                ),
                Expanded(
                  child: friendname(context, snapshot),
                ),
              ],
            );
          }
      }
    },
  );
}

class FriendState extends State {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Friend"),
          automaticallyImplyLeading: false,
        ),
        body: list());
  }
}
