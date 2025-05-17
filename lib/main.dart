import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Models/checkLoginModel.dart';
import 'Utils/ClientConfing.dart';
import 'Utils/Utils.dart';
import 'Views/HomepageScreen.dart';
import 'Views/RegistertScreen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2B2D42)), // Space Cadet
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'main'),
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const MainLoginScreen(),
    );
  }
}

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({Key? key}) : super(key: key);

  @override
  _MainLoginScreenState createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelGreen = const Color(0xFFB5EAD7);
  final Color pastelPink = const Color(0xFFFBC4AB);



  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showDialog('Missing Fields', 'Please enter both email and password.');
    } else {
      checkLogin(context);
    }
  }



  Future<void> checkLogin(BuildContext context) async {
    checkConction();

    var url = "login/checkLogin.php?Email=" +
        _emailController.text +
        "&Password=" +
        _passwordController.text;
    print(serverPath + url);
    final response = await http.get(Uri.parse(serverPath + url));

    if (checkLoginModel.fromJson(jsonDecode(response.body)).userID == "0") {
      var uti = Utils();
      uti.showMyDialog(context, "Error", "Username or password is wrong");
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', checkLoginModel.fromJson(jsonDecode(response.body)).userID!);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePageScreen(title: 'homepage')),
      );
    }
  }



  Future<void> checkConction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        _showDialog("No Connection", "Please connect to the internet.");
      }
    } on SocketException catch (_) {
      _showDialog("No Connection", "Please connect to the internet.");
    }
  }



  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  Future<void> fillSavedPars()
  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");
    if(email != null && email != "")
      {
        _emailController.text = email;
        _passwordController.text = password!;
      }

  }




  @override
  Widget build(BuildContext context) {

    fillSavedPars();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: pastelPurple),
              const SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: pastelPurple,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Log in to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: pastelBlue,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: pastelPurple),
                  prefixIcon: Icon(Icons.email_outlined, color: pastelGreen),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: pastelPurple),
                  prefixIcon: Icon(Icons.lock_outline, color: pastelGreen),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Log In', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pastelPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
                child: const Text('Create New Account', style: TextStyle(fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: pastelBlue,
                  side: BorderSide(color: pastelBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
