import 'dart:convert';
import 'dart:io';
import 'package:final_project/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/main.dart';
import 'package:final_project/Views/SavedList.dart';
import 'package:http/http.dart' as http;

import '../Utils/ClientConfing.dart';



class ProfileScreen extends StatefulWidget {
  final String category;

  const ProfileScreen({Key? key, required this.category}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfileScreen> {
  String username = "Username";
  File? _profileImage;
  final picker = ImagePicker();

  // Pastel Colors
  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelGreen = const Color(0xFFB5EAD7);
  final Color pastelPink = const Color(0xFFFBC4AB);

  late User _currUser;


  Future<void> getMyDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = "Profile/getProfileDetails.php?userID=" + token!;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    _currUser = User.fromJson(json.decode(response.body));
    setState(() {
      // _isLoading = false;
    });
  }




  @override
  Widget build(BuildContext context) {


    getMyDetails();


    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      appBar: AppBar(
        backgroundColor: pastelPurple,
        title: const Text('My Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "Category: ${widget.category}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: pastelPurple,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _showChangePictureOptions,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: pastelPink.withOpacity(0.5),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/profile.jpg') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, size: 20, color: pastelPurple),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _showEditNameDialog,
                child: Text(
                  _currUser.firstName!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _buildButton(
                icon: Icons.bookmark,
                label: 'Saved Videos',
                onPressed: _navigateToSavedList,
              ),
              const SizedBox(height: 20),
              // ElevatedButton.icon(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   ),
              //   onPressed: _confirmDeleteAccount,
              //   icon: const Icon(Icons.delete),
              //   label: const Text('Delete Account', style: TextStyle(fontSize: 16)),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: pastelBlue),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onPressed,
      ),
    );
  }

  void _showEditNameDialog() {
    TextEditingController _controller = TextEditingController(text: username);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter new username",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                var url = "users/UpdateUser.php";
                setState(() {
                  username = _controller.text.trim();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangePictureOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                var url = "users/UpdateUser.php";
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Picture'),
              onTap: () {
                var url = "users/UpdateUser.php";
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete account'),
          content: const Text('Are you sure you want to delete this account?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'main')),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSavedList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavedList()),
    );
  }
}
