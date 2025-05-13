import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsSearchScreen(),
    );
  }
}

class NewsSearchScreen extends StatefulWidget {
  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _articles = [];
  bool _loading = false;

  Future<void> fetchNews(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('من فضلك أدخل موضوع البحث')),
      );
      return;
    }

    setState(() => _loading = true);

    final apiKey = "YOUR_NEWSAPI_KEY"; // استبدلها بمفتاح API الخاص بك
    final url = "https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _articles = data["articles"];
          _loading = false;
        });
      } else {
        throw Exception("فشل في تحميل المقالات");
      }
    } catch (e) {
      setState(() => _loading = false);
      print("خطأ: $e");
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'لا يمكن فتح الرابط $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("بحث عن المقالات")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "أدخل موضوع البحث",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => fetchNews(_controller.text),
                ),
              ),
            ),
            SizedBox(height: 16),
            _loading
                ? CircularProgressIndicator()
                : _articles.isEmpty
                ? Center(child: Text('لم يتم العثور على نتائج.'))
                : Expanded(
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(article["title"] ?? "بدون عنوان"),
                      subtitle: Text(article["source"]["name"] ?? "مصدر غير معروف"),
                      onTap: () => _launchURL(article["url"]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
