import 'package:flutter/material.dart';
import '../auth/loginuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State {
  String quote = '';

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    readlocalquote();
  }

  Future<String> get getdir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get getfile async {
    final path = await getdir;
    return File('$path/data.txt');
  }

  Future<File> clear() async {
    final file = await getfile;
    await file.writeAsString('');
    print("clear complete");
  }

  Future<String> readlocalquote() async {
    try {
      final file = await getfile;
      String localqoute = await file.readAsString();
      this.quote = localqoute;
      print('quote: $quote');
      return this.quote;
    } catch (e) {
      return 'Error';
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String wait ;
    setState(() {
      readlocalquote();
      wait = this.quote;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(30),
          children: <Widget>[
            Text(
              "Hello ${LoginUser.NAME}",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
                "${this.quote == null ? '' : wait}"),
            RaisedButton(
              child: Text(
                "PROFILE SETUP",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/profile");
              },
              color: Theme.of(context).accentColor,
            ),
            RaisedButton(
              child: Text("MY FRIENDS",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                Navigator.of(context).pushNamed('/friend');
              },
              color: Theme.of(context).accentColor,
            ),
            RaisedButton(
              child: Text(
                "SIGN OUT",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(await prefs.getString('userid'));
                LoginUser.NAME = "";
                LoginUser.AGE = "";
                LoginUser.PASS = "";
                LoginUser.QUOTE = "";
                LoginUser.USERID = "";
                LoginUser.ID = null;
                await prefs.setInt('id', LoginUser.ID);
                await prefs.setString('userid', LoginUser.USERID);
                await prefs.setString('name', LoginUser.NAME);
                await prefs.setString('age', LoginUser.AGE);
                await prefs.setString('qoute', LoginUser.QUOTE);
                await clear();
                Fluttertoast.showToast(
                    msg: "Sign out",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).pushReplacementNamed('/');
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
