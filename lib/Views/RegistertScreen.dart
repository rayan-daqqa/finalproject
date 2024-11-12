import 'package:final_project/Views/HomePageScreen.dart';
import 'package:flutter/material.dart';

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



  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
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

            Text("FirstName:", style: TextStyle(fontSize:20),),
            Container(
            width: 500,
            child: TextField(
              decoration:InputDecoration(
                border:OutlineInputBorder(),
                hintText: 'enter your FirstName',
              ),
             ),
            ),

              Text("LastName:", style: TextStyle(fontSize:20),),
              Container(width: 500,
              child: TextField(
              decoration:InputDecoration(
              border:OutlineInputBorder(),
              hintText: 'enter your LastName',
              ),
              ),
              ),






            Text("email:", style: TextStyle(fontSize:20),),
            Container(width: 500,
              child: TextField(
                decoration:InputDecoration(
                  border:OutlineInputBorder(),
                  hintText: 'email',
                ),
              ),
            ),




            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: ()
              {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'login')),
                );
              },
              child: Text('HomePage'),),

            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                // var uti = new Utils();
                // uti.showMyDialog(context, _txtFirstName.text, _txtFirstName.text);

                insertUser("aa","bb");

              },
              child: Text('Register'),
            ),




          ],
        ),
      ),


    );
  }
}
