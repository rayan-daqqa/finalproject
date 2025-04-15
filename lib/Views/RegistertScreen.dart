import 'package:final_project/Views/AddContentScreen.dart';
import 'package:final_project/Views/HomepageScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import '../Models/User.dart';
import '../Utils/CliendConfing.dart';
import '../Utils/Utils.dart';
import 'package:http/http.dart' as http;


class RegistertScreen extends StatefulWidget {
  const RegistertScreen({super.key, required this.title});

  final String title;

  @override
  State<RegistertScreen> createState() => RegistertPageState();
}



class RegistertPageState extends State<RegistertScreen> {
  final _txtFirstName = TextEditingController();
  final _txtlasttName = TextEditingController();
  final _txtPassword = TextEditingController();
  final _txtEmail = TextEditingController();

  Future insertUser(BuildContext context, User us) async {

    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "users/insertUser.php?firstName=" + us.firstName + "&lastName=" + us.lastName;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() { });
    Navigator.pop(context);
  }

  void InsertUserFunc() {

      if (_txtEmail.text != ""||_txtPassword.text!=""||_txtFirstName.text != "" ) {
        User us = new User();
        us.firstName = _txtFirstName.text;
        us.lastName = _txtlasttName.text;
        us.Password = _txtPassword.text;
        us.email = _txtEmail.text;
        insertUser(context, us);
      }
      else {
        var uti = new Utils();
        uti.showMyDialog(context, "Required", "Please insert your information");
      }

    }





      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "FirstName*:",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 500,
                  child: TextField(
                    controller: _txtFirstName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'enter your FirstName',
                    ),
                  ),
                ),
                Text(
                  "LastName:",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 500,
                  child: TextField(
                    controller: _txtlasttName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'enter your LastName',
                    ),
                  ),
                ),
                Text(
                  "email*:",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 500,
                  child: TextField(
                    controller: _txtEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'enter your email',
                    ),
                  ),
                ),
                Text(
                  "password*:",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 500,
                  child: TextField(
                    controller: _txtPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'enter your password',
                    ),
                  ),
                ),
               /* TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const RegistertScreen(title: 'regester')),
                    );
                  },
                  child: Text('go back'),
                ),*/
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue),
                  ),
                  onPressed: () {
                    if (_txtFirstName.text != ""||_txtEmail.text != "" || _txtPassword.text != '' ||
                        _txtEmail.text != '') {

                        User us = new User();
                        us.firstName = _txtFirstName.text;
                        us.lastName = _txtlasttName.text;
                        us.Password = _txtPassword.text;
                        us.email = _txtEmail.text;
                        insertUser(context, us);
                      }
                      else {
                        var uti = new Utils();
                        uti.showMyDialog(
                            context, "Required", "Please insert first name");
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'homepage')),
                      );
                    }, child: Text('creat'),
                ),
              ],
            ),
          ),
        );
      }


}