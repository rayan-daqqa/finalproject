import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Content.dart';
import '../Utils/ClientConfing.dart';



class SavedList extends StatefulWidget {
  @override
  _SavedListState createState() => _SavedListState();
}

class _SavedListState extends State<SavedList> {
  List<dynamic> _videos = [];
  bool _loading = true;

  // final String url ="content/GetContentDetails.php";

  @override
  void initState() {
    super.initState();
    // fetchVideos();
    getMySavedContent();
  }




  Future<List<Content>> getMySavedContent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? token = prefs.getInt('token');

    var url = "savedContent/getMySavedContent.php?userID=${token.toString()}";
    print(serverPath + url);

    final response = await http.get(Uri.parse(serverPath + url));
    List<Content> arr = [];

    for (Map<String, dynamic> i in json.decode(response.body)) {
      arr.add(Content.fromJson(i));
    }
    _videos = arr;
    return arr;
  }






  // Future<void> fetchVideos() async {
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         _videos = data;
  //         _loading = false;
  //       });
  //     } else {
  //       print("Failed to load: ${response.statusCode}");
  //       setState(() => _loading = false);
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     setState(() => _loading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Pastel colors
    final Color pastelBackground = Color(0xFFFFFBFA); // Light Pinkish White
    final Color pastelCard = Color(0xFFFBEAFF);       // Pastel Pink
    final Color pastelText = Color(0xFFE0BBE4);        // Pastel Purple
    final Color pastelSubtitle = Color(0xFF333333);    // Dark text for readability

    return Scaffold(
      backgroundColor: pastelBackground,
      appBar: AppBar(
        title: const Text('Saved Videos'),
        backgroundColor: pastelText,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _videos.isEmpty
          ? const Center(
        child: Text(
          'No saved videos',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final item = _videos[index];
          return Card(
            color: pastelCard,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                item['title'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: pastelText,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '📎 Link: ${item['link']}',
                    style: TextStyle(color: pastelSubtitle),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📝 Content: ${item['content']}',
                    style: TextStyle(color: pastelSubtitle),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📺 Channel: ${item['channelID']}',
                    style: TextStyle(color: pastelSubtitle),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
