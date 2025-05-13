import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({Key? key}) : super(key: key);

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  String? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  File? selectedMedia;
  String? selectedType;

  final picker = ImagePicker();

  // ألوان الباستيل
  final pastelBlue = const Color(0xFFA8DADC);
  final pastelPink = const Color(0xFFFBC4AB);
  final pastelPurple = const Color(0xFFE0BBE4);
  final pastelGreen = const Color(0xFFB5EAD7);

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = File(pickedFile.path);
        selectedType = "Image";
      });
    }
  }

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = File(pickedFile.path);
        selectedType = "Video";
      });
    }
  }

  void showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Review Content'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: $selectedCategory'),
              Text('Title: ${_titleController.text}'),
              Text('Content Type: $selectedType'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pastelGreen,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Widget buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: pastelBlue,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelPurple.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Add Content'),
        backgroundColor: pastelPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (selectedCategory == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Category:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        buildCategoryButton('Health'),
                        buildCategoryButton('Cars'),
                        buildCategoryButton('Cooking'),
                        buildCategoryButton('Home'),
                        buildCategoryButton('Money Management'),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Enter Title',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Choose Content Type:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: pickImage,
                          style: ElevatedButton.styleFrom(backgroundColor: pastelPink),
                          child: const Text('Upload Image'),
                        ),
                        ElevatedButton(
                          onPressed: pickVideo,
                          style: ElevatedButton.styleFrom(backgroundColor: pastelBlue),
                          child: const Text('Upload Video'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String articleText = '';
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Write Article'),
                                  content: TextField(
                                    onChanged: (value) => articleText = value,
                                    maxLines: 5,
                                    decoration: const InputDecoration(hintText: "Enter your article here"),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        print('Saved article: $articleText');
                                        Navigator.of(context).pop();
                                        setState(() {
                                          selectedType = "Article";
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: pastelGreen),
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: pastelPurple),
                          child: const Text('Write Article'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: pastelBlue),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_titleController.text.isNotEmpty && selectedType != null) {
                              showReviewDialog();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all fields')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: pastelGreen),
                          child: const Text('Save'),
                        ),
                      ],
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
