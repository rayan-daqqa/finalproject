import 'package:final_project/Views/HomepageScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Utils/Utils.dart';
import '../Utils/db.dart';

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

  void InsertUserFunc() {
    if (_txtFirstName.text != "") {
      User us = new User();
      us.firstName = _txtFirstName.text;
      us.lastName = _txtlasttName.text;
      us.Password = _txtPassword.text;
      us.email = _txtEmail.text;

      void InsertfirstFunc() {
        if (_txtEmail.text != "") {
          first f1 = new first();
          f1.email = _txtEmail.text;
          f1.Password = _txtPassword.text;


          insertUser(us);
          /*
      var uti=new Utils();
      uti.showMyDialog(context, "success", "you registed successfully");
      _txtFirstName.text="";
      _txtlasttName.text="";
      _txtPassword.text="";
      */
        } else {
          var uti = new Utils();
          uti.showMyDialog(context, "Required", "Please insert first name");
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
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const HomePageScreen(title: 'login')),
                    );
                  },
                  child: Text('HomePage'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue),
                  ),
                  onPressed: () {
                    // var uti = new Utils();
                    // uti.showMyDialog(context, _txtFirstName.text, _txtFirstName.text);

                    InsertUserFunc();
                  },
                  child: Text('creat'),
                ),
              ],
            ),
          ),
        );
      }
    }


    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}