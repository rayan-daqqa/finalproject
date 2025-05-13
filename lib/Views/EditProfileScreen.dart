import 'package:flutter/material.dart';
import '../Models/User.dart';
import '../Utils/Utils.dart';
import 'HomepageScreen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.title});
  final String title;

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _txtFirstName = TextEditingController();
  final _txtlasttName = TextEditingController();
  final _txtPassword = TextEditingController();
  final _txtEmail = TextEditingController();

  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelPink = const Color(0xFFFBC4AB);
  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelGreen = const Color(0xFFB5EAD7);

  void InsertUserFunc() {
    if (_txtFirstName.text != "") {
      User us = User();
      us.firstName = _txtFirstName.text;
      us.lastName = _txtlasttName.text;
      us.Password = _txtPassword.text;
      us.email = _txtEmail.text;

      // يمكنك هنا إرسال البيانات إلى الخادم

      var uti = Utils();
      uti.showMyDialog(context, "Success", "User profile updated");
    } else {
      var uti = Utils();
      uti.showMyDialog(context, "Required", "Please enter your first name");
    }
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: pastelBlue.withOpacity(0.1),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelPurple.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: pastelPurple,
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField("First Name*", _txtFirstName),
            buildTextField("Last Name", _txtlasttName),
            buildTextField("Email*", _txtEmail),
            buildTextField("Password*", _txtPassword, isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: InsertUserFunc,
              icon: const Icon(Icons.save),
              label: const Text("Save Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: pastelGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageScreen(title: 'HomePage')),
                );
              },
              child: const Text('Back to Home'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
