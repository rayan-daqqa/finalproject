import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/Content.dart';
import '../Utils/ClientConfing.dart';

class ChannelDetailsScreen extends StatefulWidget {
  const ChannelDetailsScreen({super.key, required this.title});
  final String title;

  @override
  State<ChannelDetailsScreen> createState() => ChannelPageState();
}

class ChannelPageState extends State<ChannelDetailsScreen> {
  late Content _currContent;
  bool _isLoading = true;

  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelPink = const Color(0xFFFBC4AB);
  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelGreen = const Color(0xFFB5EAD7);

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastContentID = prefs.getInt('lastContentID');

    var url = "chanels/getChanelContent.php?contentID=$lastContentID";
    final response = await http.get(Uri.parse(serverPath + url));
    _currContent = Content.fromJson(json.decode(response.body));
    setState(() {
      _isLoading = false;
    });
  }

  Future insertPageToSavedList(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("token");

    var url = "favorites/insertpagetoSavedlist.php?userID=$userID&channelID=${_currContent.contentID}";
    await http.get(Uri.parse(serverPath + url));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to saved list!')),

    );
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        backgroundColor: pastelPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: pastelBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _currContent.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currContent.content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      launch(_currContent.link);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pastelPink,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Open in YouTube", style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: (    {var url = "content/GetContentDetails.php"}) => insertPageToSavedList(context),
                    icon: const Icon(Icons.bookmark_add, color: Colors.black),
                    label: const Text('Add to saved list', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pastelGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
