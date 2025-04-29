import 'dart:convert';
import 'package:final_project/Models/Channel.dart';
import 'package:final_project/Views/AddContentScreen.dart';
import 'package:final_project/Views/ProfileScreen.dart';
import'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Category.dart';
import '../Utils/CliendConfing.dart';
import 'ChanelListScreen.dart';
import 'EditProfileScreen.dart';
import 'package:http/http.dart' as http;



class HomePageScreen extends StatefulWidget{
  const HomePageScreen({super.key,required this.title});
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

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(category.fromJson(i));
    }
    print("arr:" + arr.length.toString());
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getMyCategories(),
        builder: (context, projectSnap) {
          if (projectSnap.hasData) {
            if (projectSnap.data.length == 0)
            {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('אין תוצאות', style: TextStyle(fontSize: 23, color: Colors.black))
                ),
              );
            }
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                      child:ListView.builder(
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
                                    MaterialPageRoute(builder: (context) =>ChanellistScreen (title: project.categoryName,)),
                                  );

                                },
                                title: Text(project.categoryName.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                                trailing: Image.network(project.imageCat,
                                ),
                                // subtitle: Text(project.categoryName!.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                // trailing: Container(
                                //   decoration: const BoxDecoration(
                                //     color: Colors.blue,
                                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 12,
                                //     vertical: 4,
                                //   ),
                                //
                                // ),

                                isThreeLine: false,
                              ));
                        },
                      )),
                ],
              );
            }
          }
          else if (projectSnap.hasError)
          {
            print(projectSnap.error);
            return  Center(child: Text('שגיאה, נסה שוב', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
          }
          return Center(child: new CircularProgressIndicator(color: Colors.red,));
        },
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
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
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer

              },
            ),
           /* ListTile(
              title: const Text('Edit Profile'),
              selected: _selectedIndex == 1,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>CarsChanelScreen()),
                );
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),*/
            ListTile(
              title: const Text('My chanel'),
              selected: _selectedIndex == 2,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ProfileScreen(category: '',)),
                );
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),

      ),
    );
  }
}



