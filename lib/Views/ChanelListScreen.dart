import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Content.dart';
import 'package:http/http.dart' as http;
import '../Utils/ClientConfing.dart';
import 'ContentDetailsScreen.dart';

class ChanellistScreen extends StatefulWidget {
  const ChanellistScreen({super.key, required this.title});

  final String title;

  @override
  State<ChanellistScreen> createState() => _ChanelListScreen();
}

class _ChanelListScreen extends State<ChanellistScreen> {
  // ألوان الباستيل
  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelPink = const Color(0xFFFBC4AB);
  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelGreen = const Color(0xFFB5EAD7);

  Future<List<Content>> getchanels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastChannelID = prefs.getInt('lastChannelID');

    var url = "chanels/getChanelDetails.php?channelID=${lastChannelID.toString()}";
    final response = await http.get(Uri.parse(serverPath + url));
    List<Content> arr = [];

    for (Map<String, dynamic> i in json.decode(response.body)) {
      arr.add(Content.fromJson(i));
    }

    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelPurple.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: pastelPurple,
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Content>>(
        future: getchanels(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'אין תוצאות',
                  style: TextStyle(fontSize: 23, color: Colors.black),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Content content = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: pastelBlue.withOpacity(0.3),
                      child: ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('lastContentID', content.contentID);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChannelDetailsScreen(title: content.content),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          content.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: pastelPurple),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'שגיאה, נסה שוב',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.pinkAccent,
            ),
          );
        },
      ),
    );
  }
}
