import 'package:flutter/material.dart';
import 'register.dart';
// import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/userdb.dart';
import '../auth/loginuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return LoginState();
  }
}

class LoginState extends State {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usercontrol = TextEditingController();
  TextEditingController passcontrol = TextEditingController();
  UserUtils user = UserUtils();

  @override
  void initState(){
    super.initState();
    isLogin();
  }

  Future<void> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      LoginUser.ID = prefs.getInt('id');
      LoginUser.USERID = prefs.getString('userid');
      LoginUser.NAME = prefs.getString('name');
      LoginUser.AGE = prefs.getString('age');
      LoginUser.QUOTE = prefs.getString('qoute');
    });
    print(prefs.getString('userid'));
    if (LoginUser.ID != null){
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future getuser(userid) async {
    await user.open('user.db');
    Future<List<User>> allUser = user.getAllUser();
    var list = await allUser;
  }

  TextFormField username() {
    return TextFormField(
      controller: usercontrol,
      decoration: InputDecoration(
          hintText: "Username",
          labelText: "Username",
          icon: Icon(Icons.perm_identity)),
      keyboardType: TextInputType.emailAddress,
    );
  }

  TextFormField password() {
    return TextFormField(
      controller: passcontrol,
      decoration: InputDecoration(
          hintText: "password", labelText: "Password", icon: Icon(Icons.lock)),
      keyboardType: TextInputType.text,
      obscureText: true,
    );
  }

  RaisedButton login() {
    bool isUser = false;
    return RaisedButton(
      child: Text("Login", style: TextStyle(color: Colors.white)),
      elevation: 4.0,
      color: Theme.of(context).accentColor,
      splashColor: Theme.of(context).accentColor,
      onPressed: () async {
        Future<List<User>> all = user.getAllUser();
        Future isUserValid(String userid, String password) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var userlist = await all;
          print(111111);
          for (int i = 0; i < userlist.length; i++) {
            print(userlist[i].userid);
            if (usercontrol.text == userlist[i].userid &&
                passcontrol.text == userlist[i].pass) {
              LoginUser.ID = userlist[i].id;
              LoginUser.USERID = userlist[i].userid;
              LoginUser.NAME = userlist[i].name;
              LoginUser.AGE = userlist[i].age;
              LoginUser.QUOTE = userlist[i].quote;
              await prefs.setInt('id', LoginUser.ID);
              await prefs.setString('userid', LoginUser.USERID);
              await prefs.setString('name', LoginUser.NAME);
              await prefs.setString('age', LoginUser.AGE);
              await prefs.setString('qoute', LoginUser.QUOTE);
              isUser = true;
              break;
            }
          }
        }

        if (usercontrol.text == '' || passcontrol.text == '') {
          Fluttertoast.showToast(
              msg: "Please fill out this form.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          await isUserValid(usercontrol.text, passcontrol.text);
          if (isUser) {
            Fluttertoast.showToast(
                msg: "Login!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.pushReplacementNamed(context, "/home");
          } else {
            Fluttertoast.showToast(
                msg: "Invalid user or password",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      },
    );
  }

  FlatButton register() {
    return FlatButton(
      child: Text(
        "Register New Account",
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            shrinkWrap: true,
            children: <Widget>[
              Image.asset(
                "images/logo.png",
                height: 200,
              ),
              username(),
              password(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                ),
                child: login(),
              ),
              register(),
            ],
          ),
        ),
      ),
    );
  }
}
