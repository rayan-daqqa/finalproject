import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('http://192.168.148.25/login/register.php'); // عدل الرابط حسب حالتك
      var response = await http.post(url, body: {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('welcome to life skills')),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('somthing went wrong pleas try again')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('creat account'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.person_add_alt_1, size: 100, color: Colors.deepPurple),
              SizedBox(height: 20),
              buildTextField('first name', _firstNameController),
              SizedBox(height: 15),
              buildTextField('last name', _lastNameController),
              SizedBox(height: 15),
              buildTextField('email', _emailController, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 15),
              buildTextField('password', _passwordController, isPassword: true),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator(color: Colors.deepPurple)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: isPassword
            ? Icon(Icons.lock, color: Colors.deepPurple)
            : Icon(Icons.person, color: Colors.deepPurple),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please enter $label';
        }
        if (label == 'email' && !value.contains('@')) {
          return 'please enter a correct email';
        }
        if (label == 'password' && value.length < 6) {
          return 'the password should at least 6 digits';
        }
        return null;
      },
    );
  }
}