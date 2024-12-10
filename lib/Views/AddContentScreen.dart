import 'package:final_project/Views/HomePageScreen.dart';
import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Utils/Utils.dart';
import '../Utils/db.dart';

class Addcontentscreen extends StatefulWidget {
  const Addcontentscreen({super.key, required this.title});

  final String title;

  @override
  State<Addcontentscreen> createState() => AddContentPageState();
}

class AddContentPageState extends State<Addcontentscreen> {
  final _txttopic = TextEditingController();
  final _txtcategory = TextEditingController();


  void Insertchannelfunc() {
    if (_txttopic.text != ""||_txtcategory.text != "") {
      
      
      
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
    // TODO: implement build
    throw UnimplementedError();
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
  }*/
}
