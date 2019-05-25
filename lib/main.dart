import 'package:flutter/material.dart';
import 'ui/login.dart';
import 'ui/home.dart';
import 'ui/profile.dart';
import 'ui/friend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './auth/loginuser.dart';

void main() => runApp(MyApp());

// Map<int, Color> color = {
//   50: Color.fromRGBO(111, 111, 111, .1),
// };
// MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);


// const color = const Color(0xff111111);
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  String username;
  islogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') != null) {
      LoginUser.ID = prefs.getInt('id');
      LoginUser.USERID = prefs.getString('userid');
      LoginUser.NAME = prefs.getString('name');
      LoginUser.AGE = prefs.getString('age');
      LoginUser.QUOTE = prefs.getString('quote');
      return prefs;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // primaryColor: color
      ),
      initialRoute: "/",
      routes: {
        "/": (context) =>  Login(),
        "/home": (context) => Home(),
        "/profile": (context) => Profile(),
        "/friend": (context) => AllFriend(),
      },
    );
  }
}

// https://medium.com/@manojvirat457/turn-any-color-to-material-color-for-flutter-d8e8e037a837