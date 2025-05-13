import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SavedList extends StatefulWidget {
  @override
  _SavedListState createState() => _SavedListState();
}

class _SavedListState extends State<SavedList> {
  List<dynamic> _videos = [];
  bool _loading = true;

  final String url = 'https://yourdomain.com/content/GetContentDetails.php'; // <-- غيّر الرابط هنا

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _videos = data;
          _loading = false;
        });
      } else {
        print("فشل في التحميل: ${response.statusCode}");
        setState(() => _loading = false);
      }
    } catch (e) {
      print("خطأ: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color pastelBackground = Color(0xFFF0F4EF);
    final Color pastelCard = Color(0xFFFBEAFF);
    final Color pastelText = Color(0xFF6C63FF);

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
          ? const Center(child: Text('لا يوجد فيديوهات محفوظة'))
          : ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final item = _videos[index];
          return Card(
            color: pastelCard,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  Text('📎 الرابط: ${item['link']}', style: TextStyle(color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('📝 المحتوى: ${item['content']}', style: TextStyle(color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('📺 القناة: ${item['channelID']}', style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
