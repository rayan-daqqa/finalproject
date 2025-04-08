// import 'package:mysql1/mysql1.dart';
import '../Models/User.dart';

var _conn;
/*
Future<void> connect() async {
  var settings = new ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'rayan12'
  );
  _conn = await MySqlConnection.connect(settings);
}




Future<void> showUsers() async {

  connect();

  // Query the database using a parameterized query
  var results = await _conn.query(
    'select * from users',);
  for (var row in results) {
    print('userID: ${row[0]}, firstName: ${row[1]} lastName: ${row[2]}');
  }
}

Future<void> insertUser(User user) async {

  connect();

  var result = await _conn.query(
      'insert into users (firstName, lastName,password,email) values (?,?,?,?)',
      [user.firstName,user.lastName,user.Password,user.email ]);
  print('Inserted row id=${result.insertId}');

  //////////


  // Finally, close the connection
  await _conn.close();

}
 */