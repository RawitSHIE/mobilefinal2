import 'package:flutter/material.dart';
import '../auth/loginuser.dart';
import '../db/userdb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State {
  TextEditingController useridcontrol = TextEditingController();
  TextEditingController usernamecontrol = TextEditingController();
  TextEditingController agecontrol = TextEditingController();
  TextEditingController new_pass = TextEditingController();
  TextEditingController quotecontrol = TextEditingController();

  UserUtils userdb = UserUtils();

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String data) async {
    final file = await localFile;
    await file.writeAsString('${data}');
    print("write complete");
    print(data);
  }

  final _formKey = GlobalKey<FormState>();
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
          return "Please input correct valid userId";
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
        if (value == '' ||
            (int.parse(value) < 10 || int.parse(value) > 80)) {
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
        if (value.length < 6) {
          return "Password length must exceed 6 character.";
        }
        if (value == ''){
          return "password empty";
        }
      },
    );
  }

  TextFormField quote() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Quote",
          hintText: "Explain yourself",
          icon: Icon(Icons.settings_system_daydream,
              size: 40, color: Colors.grey),
        ),
        controller: quotecontrol,
        keyboardType: TextInputType.text,
        maxLines: 5);
  }

  RaisedButton save() {
    return RaisedButton(
      child: Text("save",
          style: TextStyle(
            color: Colors.white,
          )),
      onPressed: () async {
        await userdb.open("user.db");
        bool status = true;
        Future<List<User>> alluser = userdb.getAllUser();
        Future checkexist(String userid) async {
          var userlist = await alluser;
          if (userid != LoginUser.USERID) {
            for (int i = 0; i < userlist.length; i++) {
              if (userid == userlist[i].userid) {
                Fluttertoast.showToast(
                    msg: "Userid Already exist.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                status = false;
                break;
              }
            }
          }else{
            print("userid unchange");
          }
        }

        checkexist(useridcontrol.text);

        if (_formKey.currentState.validate() && status) {
          User update = User();
          update.id = LoginUser.ID;
          LoginUser.USERID = update.userid = useridcontrol.text;
          LoginUser.NAME = update.name = usernamecontrol.text;
          LoginUser.AGE = update.age = agecontrol.text;
          LoginUser.PASS = update.pass = new_pass.text;
          LoginUser.QUOTE = quotecontrol.text;
          writeContent(quotecontrol.text);
          await userdb.updateUser(update);

          Fluttertoast.showToast(
              msg: "Change Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      color: Theme.of(context).accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(40),
          shrinkWrap: true,
          children: <Widget>[
            userid(),
            username(),
            age(),
            password(),
            quote(),
            save(),
          ],
        ),
      ),
    );
  }
}
