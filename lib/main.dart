import 'package:final_project/Views/HomePageScreen.dart';
import 'package:final_project/Views/RegistertScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LIFE SKILLS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            Text("Email:", style: TextStyle(fontSize:20),),
        Container(
          width: 500,
          child:TextField(
              decoration:InputDecoration(
                border:OutlineInputBorder(),
                hintText: 'enter your email',
              ), ),),


            Text("password:", style: TextStyle(fontSize:20),),
            Container(
              width: 500,
              child:TextField(
                decoration:InputDecoration(
                  border:OutlineInputBorder(),
                  hintText: 'enter your password ',
                ), ),),

            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'homepage')),
                );

              },
              child: Text('Login'),
            ),


            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistertScreen(title: 'Creat account')),
                );

              },
              child: Text('Create new account'),
            )




          ],
        ),
      ),


    );
  }
}
