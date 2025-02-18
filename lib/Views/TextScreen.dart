import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        throw Exception("Failed to load articles");
      }
    } catch (e) {
      setState(() => _loading = false);
      print("Error: $e");
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
                : Expanded(
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return ListTile(
                    title: Text(article["title"] ?? "بدون عنوان"),
                    subtitle: Text(article["source"]["name"] ?? "مصدر غير معروف"),
                    onTap: () {
                      // فتح المقالة في المتصفح عند النقر عليها
                      print("فتح الرابط: ${article["url"]}");
                    },
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