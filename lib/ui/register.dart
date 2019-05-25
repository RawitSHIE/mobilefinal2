import 'package:flutter/material.dart';
import '../db/userdb.dart';
import '../auth/loginuser.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  TextEditingController useridcontrol = TextEditingController();
  TextEditingController usernamecontrol = TextEditingController();
  TextEditingController agecontrol = TextEditingController();
  TextEditingController new_pass = TextEditingController();
  UserUtils user = UserUtils();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int countspace(String text) {
    int space = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ' ') {
        space++;
      }
    }
    return space;
  }

  TextFormField userid() {
    return TextFormField(
      controller: useridcontrol,
      decoration: InputDecoration(
        labelText: "User Id",
        hintText: "sample",
        icon: Icon(Icons.perm_identity),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.length < 6 || value.length > 12 || value.contains(' ')) {
          return "Please input correct valid userId must be 6 - 12 character";
        }
      },
    );
  }

  TextFormField username() {
    return TextFormField(
      controller: usernamecontrol,
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "JJ Abrums",
        icon: Icon(Icons.perm_identity),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (countspace(value.trim()) != 1) {
          return "A name must contain exactly 1 spacebar";
        }
      },
    );
  }

  TextFormField age() {
    return TextFormField(
      controller: agecontrol,
      decoration: InputDecoration(
        labelText: "Age",
        hintText: "10 - 80 years old",
        icon: Icon(Icons.perm_contact_calendar),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == '' || int.parse(value) < 10 || int.parse(value) > 80) {
          return "Please input correct age value";
        }
      },
    );
  }

  TextFormField password() {
    return TextFormField(
      controller: new_pass,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "more than 6 characters",
          icon: Icon(Icons.lock)),
      obscureText: true,
      validator: (value) {
        if (value.length <= 6 || value == '') {
          return "Password length must exceed 6 character.";
        }
      },
    );
  }

  Future checkexist(User newuser) async {
    await user.open("user.db");
    Future<List<User>> alluser = user.getAllUser();
    var ls = await alluser;
    for (int i = 0; i < ls.length; i++) {
      if (newuser.userid == ls[i].userid) {
        return true;
      }
    }
    return false;
  }

  RaisedButton register() {
    return RaisedButton(
        color: Theme.of(context).accentColor,
        splashColor: Colors.blueGrey,
        child: Text(
          "REGISTER NEW ACCOUNT",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await user.open("user.db");
          if (_formKey.currentState.validate()) {
            User userData = User();
            userData.userid = useridcontrol.text;
            userData.name = usernamecontrol.text;
            userData.age = agecontrol.text;
            userData.pass = new_pass.text;
            userData.quote = null;

            if (!await checkexist(userData)) {
              await user.insertUser(userData);
              Fluttertoast.showToast(
                  msg: "Register Complete",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context);
              print('insertcomplete');
            } else {
              Fluttertoast.showToast(
                  msg: "User already exist",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              print('User Exist');
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                userid(),
                username(),
                age(),
                password(),
                register(),
              ]),
        ));
  }
}
