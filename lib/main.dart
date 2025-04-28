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
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MainLoginScreen(), // هون بحط شاشة تسجيل الدخول كـ home
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Missing Fields'),
          content: const Text('Please enter both email and password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'homepage')),
      );
      print('Logging in with: ${_emailController.text}');
      // لما المستخدم يدخل معلوماته بنجاح اعمله navigate لصفحة ثانية
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }

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
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Color(0xFF333366),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333366),
                ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                  // روح على صفحة إنشاء حساب
                },
                child: const Text(
                  'Create New Account',
                  style: TextStyle(fontSize: 15),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF333366),
                  side: const BorderSide(color: Color(0xFF333366)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }


