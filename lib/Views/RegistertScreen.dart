import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HomepageScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final String serverPath = "https://darkgray-hummingbird-925566.hostingersite.com/ryan/";

  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelGreen = const Color(0xFFB5EAD7);
  final Color pastelPink = const Color(0xFFFBC4AB);

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(
          '${serverPath}users/insertUser.php?firstName=${_firstNameController.text}&lastName=${_lastNameController.text}&email=${_emailController.text}&password=${_passwordController.text}'));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to Life Skills')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong, please try again')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageScreen(title: 'Home')),
      );
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    IconData icon;
    if (label.toLowerCase().contains('first') || label.toLowerCase().contains('last')) {
      icon = Icons.person;
    } else if (label.toLowerCase().contains('email')) {
      icon = Icons.email;
    } else {
      icon = Icons.lock;
    }

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: pastelPurple),
        filled: true,
        fillColor: pastelBlue.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: pastelPurple),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(icon, color: pastelPurple),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (label.toLowerCase() == 'email' && !value.contains('@')) return 'Enter a valid email';
        if (label.toLowerCase() == 'password' && value.length < 6) return 'Password too short';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelGreen.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: pastelPurple,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.person_add_alt_1, size: 90, color: pastelPurple),
              const SizedBox(height: 20),
              buildTextField('First Name', _firstNameController),
              const SizedBox(height: 15),
              buildTextField('Last Name', _lastNameController),
              const SizedBox(height: 15),
              buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              buildTextField('Password', _passwordController, isPassword: true),
              const SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator(color: pastelPurple)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pastelPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
