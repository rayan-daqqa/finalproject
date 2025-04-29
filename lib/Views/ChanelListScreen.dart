import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Channel.dart';
import 'package:http/http.dart' as http;
import '../Utils/CliendConfing.dart';
import 'ChannelDetailsScreen.dart';





class ChanellistScreen extends StatefulWidget {
  const ChanellistScreen({super.key, required this.title});


  final String title;

  @override
  State<ChanellistScreen> createState() => _ChanelListScreen();
}

class _ChanelListScreen extends State<ChanellistScreen> {

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  Future getchanels() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastCategoryID = prefs.getInt('lastCatID');


    var url = "chanels/getChanels.php?categoryID=" + lastCategoryID.toString();
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Channel> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Channel.fromJson(i));
    }

    return arr;
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getchanels(),
        builder: (context, projectSnap) {
          if (projectSnap.hasData) {
            if (projectSnap.data.length == 0) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('אין תוצאות',
                        style: TextStyle(fontSize: 23, color: Colors.black))),
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
                          Channel project = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () async {
                                  final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setInt(
                                      'lastchannelID', project.channelID);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChannelDetailsScreen(
                                          title: project.channelName,
                                        )),
                                  );
                                },
                                title: Text(
                                  project.channelName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ), // Icon(Icons.timer),

                                trailing: Image.network(
                                  project.ImageURL,
                                ),
                                // trailing: Container(
                                //   decoration: const BoxDecoration(
                                //     color: Colors.blue,
                                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 12,
                                //     vertical: 4,
                                //   ),
                                //   child: Text(
                                //     project.totalHours!,   // + "שעות "
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                //   ),
                                // ),

                                isThreeLine: false,
                              ));
                        },
                      )),
                ],
              );
            }
          } else if (projectSnap.hasError) {
            print(projectSnap.error);
            return Center(
                child: Text('שגיאה, נסה שוב',
                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
          }
          return Center(
              child: new CircularProgressIndicator(
                color: Colors.red,
              ));
        },
      ),
    );
  }
}