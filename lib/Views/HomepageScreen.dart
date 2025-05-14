import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/Models/Channel.dart';
import 'package:final_project/Views/AddContentScreen.dart';
import 'package:final_project/Views/ProfileScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/ClientConfing.dart';
import 'ChanelListScreen.dart';
import 'package:http/http.dart' as http;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});
  final String title;

  @override
  State<HomePageScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelPink = const Color(0xFFFBC4AB);
  final Color pastelPurple = const Color(0xFFE0BBE4);
  final Color pastelGreen = const Color(0xFFB5EAD7);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<Channel>> getMyCategories() async {
    var url = "chanels/getChanels.php";
    final response = await http.get(Uri.parse(serverPath + url));
    List<Channel> arr = [];
    for (Map<String, dynamic> i in json.decode(response.body)) {
      arr.add(Channel.fromJson(i));
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: pastelPurple,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Channel>>(
        future: getMyCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Results', style: TextStyle(fontSize: 20)),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Channel project = snapshot.data![index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      onTap: () async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('lastChannelID', project.channelID);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChanellistScreen(title: project.channelName)),
                        );
                      },
                      title: Text(
                        project.channelName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: project.ImageURL,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data', style: TextStyle(fontSize: 18)),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      drawer: Drawer(
        backgroundColor: pastelPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: pastelPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome 👋',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose from the list below',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Content'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddContentScreen()));
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Channel'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen(category: '')));
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                _onItemTapped(3);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Main')),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
