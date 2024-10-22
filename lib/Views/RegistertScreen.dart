import 'package:final_project/Views/HomePageScreen.dart';
import 'package:flutter/material.dart';



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

            Text("FirstName:", style: TextStyle(fontSize:20)),
            TextField(
              decoration:InputDecoration(
                border:OutlineInputBorder(),
                hintText: 'enter your FirstName',
              ), ),


            Text("lastName:", style: TextStyle(fontSize:20)),
            TextField(
              decoration:InputDecoration(
                border:OutlineInputBorder(),
                hintText: 'enter your lastName',
              ), ),




            Text("Email:", style: TextStyle(fontSize:20)),
            TextField(
              decoration:InputDecoration(
                border:OutlineInputBorder(),
                hintText: 'enter your email',
              ), ),





            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'Register')),
                );
              },
              child: Text('Register'),

            )
          ],
        ),
      ),


    );
  }
}
