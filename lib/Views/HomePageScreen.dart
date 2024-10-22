import'package:flutter/material.dart';
import 'EditProfile.dart';
class HomePageScreen extends StatefulWidget{
  const HomePageScreen({super.key,required this.title});
  final String title;
  @override
  State<HomePageScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePageScreen> {

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
            Text("home welcome to:", style: TextStyle(fontSize:20)),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () { },
              child: Icon(Icons.account_circle ),
            )
          ],
        ),
      ),


    );
  }
}
