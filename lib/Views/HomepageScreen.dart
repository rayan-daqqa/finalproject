import 'dart:convert';
import 'package:final_project/Models/Channel.dart';
import 'package:final_project/Views/AddContentScreen.dart';
import 'package:final_project/Views/ProfileScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Category.dart';
import '../Utils/CliendConfing.dart';
import 'ChanelListScreen.dart';
import 'EditProfileScreen.dart';
import 'package:http/http.dart' as http;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});
  final String title;

  @override
  State<HomePageScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future getMyCategories() async {
    var url = "categories/getCategories.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<category> arr = [];

    for (Map<String, dynamic> i in json.decode(response.body)) {
      arr.add(category.fromJson(i));
    }
    print("arr:" + arr.length.toString());
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getMyCategories(),
        builder: (context, projectSnap) {
          if (projectSnap.hasData) {
            if (projectSnap.data.length == 0) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('אין תוצאות', style: TextStyle(fontSize: 23, color: Colors.black)),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        category project = projectSnap.data[index];

                        return Card(
                          child: ListTile(
                            onTap: () async {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setInt('lastCatID', project.categoryID);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChanellistScreen(title: project.categoryName)),
                              );
                            },
                            title: Text(
                              project.categoryName.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            trailing: Image.network(project.imageCat),
                            isThreeLine: false,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          } else if (projectSnap.hasError) {
            print(projectSnap.error);
            return Center(child: Text('שגיאה, נסה שוב', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
          }
          return Center(child: new CircularProgressIndicator(color: Colors.red));
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Add Content'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddContentScreen()),
                );
                _onItemTapped(0);
              },
            ),
            ListTile(
              title: const Text('My chanel'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(category: '')),
                );
                _onItemTapped(2);
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              selected: _selectedIndex == 3,
              onTap: () async {
                // حذف بيانات المستخدم من SharedPreferences
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // تحديث الحالة وإرجاع المستخدم لصفحة البداية
                _onItemTapped(3);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Main')),
                      (Route<dynamic> route) => false, // تمنع العودة لهذه الصفحة
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
