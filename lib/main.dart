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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MainLoginScreen(), // تعيين صفحة تسجيل الدخول
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

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showDialog('Missing Fields', 'Please enter both email and password.');
    } else {
      checkLogin(context);
    }
  }

  Future<void> checkLogin(BuildContext context) async {
    checkConction(); // فحص الاتصال بالإنترنت

    var url = "login/checkLogin.php?Email=" + _emailController.text + "&Password=" + _passwordController.text;
    final response = await http.get(Uri.parse(serverPath + url));

    if (checkLoginModel.fromJson(jsonDecode(response.body)).userID == "0") {
      var uti = new Utils();
      uti.showMyDialog(context, "Error", "Username or password is wrong");
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', checkLoginModel.fromJson(jsonDecode(response.body)).userID!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'homepage')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Color(0xFF333366)),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF333366)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Log in to your account',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
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
                  prefixIcon: const Icon(Icons.lock_outline),
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
                  backgroundColor: const Color(0xFF333366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
                child: const Text('Create New Account', style: TextStyle(fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF333366),
                  side: const BorderSide(color: Color(0xFF333366)),
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
