import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LinksScreen(),
    );
  }
}

class LinksScreen extends StatefulWidget {
  @override
  _LinksScreenState createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  List<dynamic> links = [];

  @override
  void initState() {
    super.initState();
    fetchLinks();
  }

  // دالة لجلب الروابط من API PHP
  Future<void> fetchLinks() async {
    final response = await http.get(Uri.parse('http://localhost/api.php'));

    if (response.statusCode == 200) {
      // إذا كان الاتصال ناجحًا، نقوم بتحويل JSON إلى قائمة من الروابط
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        links = data;
      });
    } else {
      // في حالة وجود خطأ في الاتصال
      throw Exception('Failed to load the link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display links'),
      ),
      body: links.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          String link = links[index]['link'];
          return ListTile(
            title: Text(link),
            onTap: () {
              // يمكنك إضافة منطق لفتح الرابط عند الضغط عليه
              print('فتح الرابط: $link');
            },
          );
        },
      ),
    );
  }
}
