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
  String? selectedType; // "Image", "Video", "Article"

  final picker = ImagePicker();

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

  void writeArticle() {
    setState(() {
      selectedType = "Article";
    });
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
            TextButton(
              onPressed: () {
                // احفظ المحتوى في قاعدة بياناتك أو بالذاكرة
                Navigator.pop(context);
                Navigator.pop(context); // رجع للمستخدم على البروفايل
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Content'),
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
                    const Text('Select Category:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
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
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Enter Title'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Choose Content Type:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: pickImage,
                          child: const Text('Upload Image'),
                        ),
                        ElevatedButton(
                          onPressed: pickVideo,
                          child: const Text('Upload Video'),
                        ),
                        ElevatedButton(
                          onPressed: writeArticle,
                          child: const Text('Write Article'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
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

  Widget buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Text(category),
    );
  }
}
