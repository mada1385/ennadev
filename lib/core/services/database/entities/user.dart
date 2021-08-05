// import 'package:floor/floor.dart';
//
// @entity
// class UserDB {
//   @primaryKey
//   final int id;
//   final String name;
//   final String email;
//   final String accessToken;
//   final String phone;
//   final String image;
//   final String dateOfBirth;
//
//   UserDB(this.id, this.name, this.accessToken, this.dateOfBirth, this.email,
//       this.image, this.phone);
//   UserDB.fromModel(
//       {this.id,
//       this.name,
//       this.email,
//       this.accessToken,
//       this.phone,
//       this.image,
//       this.dateOfBirth});
// }
//
// @dao
// abstract class UserDao {
//   @Query('SELECT * FROM User')
//   Future<List<UserDB>> findAllUsers();
//
//   @Query('SELECT * FROM User')
//   Stream<List<UserDB>> findAllTasksAsStream();
//
//   @Query('SELECT * FROM User WHERE id = :id')
//   Future<UserDB> findUserById(int id);
//
//   @insert
//   Future<void> insertUser(UserDB user);
//
//   @insert
//   Future<void> insertUsers(List<UserDB> users);
//
//   @update
//   Future<void> updateUser(UserDB user);
//
//   @update
//   Future<void> updateUsers(List<UserDB> users);
//
//   @delete
//   Future<void> deleteUser(UserDB user);
//
//   @delete
//   Future<void> deleteUsers(List<UserDB> users);
// }
