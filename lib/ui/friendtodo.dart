import 'package:flutter/material.dart';
// import '../db/friendmodel.dart';
import 'dart:convert';
import '../db/todomodel.dart';
import 'package:http/http.dart' as http;
import './friend.dart';
// import './friendPage.dart';

Future<List<Todo>> todos(int id) async {
  var response =
      await http.get("https://jsonplaceholder.typicode.com/todos?userId=$id");
  List<Todo> todolist = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      Todo item = Todo.fromJson(body[i]);
      if (item.userid == id) {
        todolist.add(item);
      }
      // print(todolist[i].name);
    }
    return todolist;
  } else {
    throw Exception('error getting API');
  }
}

FutureBuilder list(int id) {
  return FutureBuilder(
    future: todos(id),
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
                  child: Text("Back", style: TextStyle(color: Colors.white),),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllFriend(
                                )));
                  },
                ),
                Expanded(
                  child: friendtodo(context, snapshot),
                ),
              ],
            );
          }
      }
    },
  );
}

ListView friendtodo(BuildContext context, AsyncSnapshot snapshot) {
  return ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
      Todo todo = snapshot.data[index];
      return Card(
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ListTile(
              //   leading: Text('${todo.id}'),
              //   title: Text(todo.title),
              //   subtitle: Text("${todo.userid}"),
              //   trailing: Text(todo.completed),
              // ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(child: Text("${todo.id}", style: TextStyle(fontSize: 20),)),
                    Container(child: Text("${todo.title}")),
                    Container(
                        child: Text(
                      "${todo.completed}",
                      style: TextStyle(color: Colors.green),
                    )),
                  ],
                ),
              )
            ],
          ),
          onTap: () {},
        ),
      );
    },
  );
}

class FriendTodo extends StatefulWidget {
  int id;
  FriendTodo({Key key, @required int this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FriendTodoState(id: id);
  }
}

class FriendTodoState extends State {
  int id;
  FriendTodoState({@required int this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        automaticallyImplyLeading: false,
      ),
      body: list(id),
    );
  }
}
