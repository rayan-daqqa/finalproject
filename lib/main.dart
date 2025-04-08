import 'dart:convert';
import 'dart:io';

import 'package:final_project/Views/HomepageScreen.dart';
import 'package:final_project/Views/RegistertScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/checkLoginModel.dart';
import 'Utils/CliendConfing.dart';
import 'Utils/Utils.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());

}

class first{
  first({
    this.Password="",
    this.email="",

});

  String Password;
  String email;
  factory first. fromJson(Map<String, dynamic>json )=> first(
  Password:json["Password"],
  email:json["email"],
  );
  Map< String, dynamic>tojson()=>{
    "Password":Password,
    "email":email,};

  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  State<HomePageScreen> createState() => HomePageState();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'main'),
    );
  }
}

class HomePageState extends  State<HomePageScreen> {
  final _txtemail = TextEditingController();
  final _txtpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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
  final _txtPassword = TextEditingController();
  final _txtEmail = TextEditingController();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  checkConction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected to internet');// print(result);// return 1;
      }
    } on SocketException catch (_) {
      // print('not connected to internet');// print(result);
      var uti = new Utils();
      uti.showMyDialog(context, "אין אינטרנט", "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה");
      return;
    }
  }



  Future checkLogin(BuildContext context) async {

    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "login/checkLogin.php?Email=" +_txtEmail.text+ "&Password=" +_txtPassword.text;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    // setState(() { });
    // Navigator.pop(context);
    if(checkLoginModel.fromJson(jsonDecode(response.body)).result == "0")
    {
      return 'ת.ז ו/או הסיסמה שגויים';
    }
    else
    {
      // print("SharedPreferences 1");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', checkLoginModel.fromJson(jsonDecode(response.body)).result!);
      // return null;
    }
  }




  @override
  Widget build(BuildContext context) {

    checkConction();

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
