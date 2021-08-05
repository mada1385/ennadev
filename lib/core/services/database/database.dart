// import 'dart:convert';
// import 'dart:io';
// import 'package:enna/core/models/user.dart';
// // import 'package:dart_json/dart_json.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final _databaseName = "userDB.db";
//   // Increment this version when you need to change the schema.
//   static final _databaseVersion = 1;

//   // database table and column names
//   final String tableUser = 'user';
//   // this will hold the json of user info
//   final String columnToken = 'token';
//   final String columnUserId = 'userId';

//   // Make this a singleton class.
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // Only allow a single open connection to the database.
//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _initDatabase();
//     return _database;
//   }

//   // open the database
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = documentsDirectory.path + _databaseName;

//     print("Database path : $path}");

//     return await openDatabase(path,
//         version: _databaseVersion, onCreate: _onCreate);
//   }

//   // SQL string to create the database
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//               CREATE TABLE $tableUser (
//                 $columnToken TEXT NOT NULL,
//                 $columnUserInfo TEXT NOT NULL)
//               ''');
//   }

//   // Database helper methods:

//   Future<int> insert(User user) async {
//     Database db = await database;
//     int id = await db.insert(
//       tableUser,
//       {/* 'user': Json.serialize(user.user), */ 'token': user.token},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return id;
//   }

//   Future<User> queryUser() async {
//     Database db = await database;
//     List<Map> maps = await db.query(tableUser);
//     if (maps.length > 0) {
//       print(maps[0]['user']);

//       // print(temp);

//       // String token = maps[0]['token'];
//       // UserInfo userInfo = UserInfo.fromJson(codec.decode(maps[0]['user']));

//       // User user = User.fromJson(maps.first);
//       // User user = User(
//       //     token: maps.first['token'], user: Json.deserialize(maps[0]['user']));

//       // User user = User.fromJson({
//       //   'token': maps[0]['token'],
//       //   'user': {maps[0]['user']}
//       // });

//       // return user;
//     }

//     return null;
//   }

//   Future<void> clearTable() async {
//     Database db = await instance.database;
//     return await db.rawQuery("DELETE FROM $tableUser");
//   }

// // TODO: queryAllWords()
// // TODO: delete(int id)
// // TODO: update(Word word)
// }
