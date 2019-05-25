import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String idCol = '_id';
final String useridCol = 'userid';
final String nameCol = 'name';
final String ageCol = 'age';
final String passCol = 'pass';
final String quoteCol = 'quote';

class User {
  int id;
  String userid;
  String name;
  String age;
  String pass;
  String quote;

  User();
  User.formMap(Map<String, dynamic> map){
    this.id = map[idCol];
    this.userid = map[useridCol];
    this.name = map[nameCol];
    this.age = map[ageCol];
    this.pass= map[passCol];
    this.quote = map[quoteCol];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      useridCol: userid,
      nameCol: name,
      ageCol: age,
      passCol: pass,
      quoteCol: quote,
    };
    if (id != null) {
      map[idCol] = id; 
    }
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "id : ${this.id} \nuserid : ${this.userid}\nname: ${this.name}\nage:${this.age}\npass:${this.pass}\nquote:${this.quote}";
  }
}

class UserUtils {
  Database db;

  Future open(String path) async{
    db = await openDatabase(path, version : 1, onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $idCol integer primary key autoincrement,
        $useridCol text not null unique,
        $nameCol text not null,
        $ageCol text not null,
        $passCol text not null,
        $quoteCol text
      )
      ''');
    });
  }
  Future<User> insertUser(User user) async {
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(userTable,
    columns: [idCol, useridCol, nameCol, ageCol, passCol, quoteCol],
    where: '$idCol =  ?',
    whereArgs:[id]);
    maps.length > 0 ? new User.formMap(maps.first) : null;
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(userTable, where: '$idCol = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    return await db.update(userTable, user.toMap(), where: '$idCol = ?', whereArgs: [user.id]);
  }

  Future<List<User>> getAllUser() async{
    await this.open("user.db");
    var res = await db.query(userTable, columns: [idCol, useridCol, nameCol, ageCol, passCol, quoteCol]);
    List<User> userList = res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}