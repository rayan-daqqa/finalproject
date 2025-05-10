import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/main.dart'; // مهم لاستدعاء MyHomePage

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.teal[100] : Colors.teal[700],
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _showChangePictureOptions,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/profile.jpg') as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _showEditNameDialog,
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildButton(
                icon: Icons.bookmark,
                label: 'Saved Videos',
                onPressed: _navigateToSaved,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _confirmDeleteAccount,
                icon: const Icon(Icons.delete),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Picture'),
              onTap: () {
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
          title: const Text('Delet account'),
          content: const Text('Are you sure you want to delete this account'),
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

  void _navigateToSaved() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedVideosPage()),
    );
  }
}

// صفحة الفيديوهات المحفوظة
class SavedVideosPage extends StatelessWidget {
  const SavedVideosPage({super.key});

  final List<String> savedVideos = const ['Video 1', 'Video 2', 'Video 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Videos')),
      body: ListView.builder(
        itemCount: savedVideos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(savedVideos[index]),
          );
        },
      ),
    );
  }
}
