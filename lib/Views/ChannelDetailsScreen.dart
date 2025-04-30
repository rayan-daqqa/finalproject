import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Channel.dart';
import '../Utils/CliendConfing.dart';



// final String recipeID;

class ChannelDetailsScreen extends StatefulWidget {
  const ChannelDetailsScreen({super.key, required this.title});

  final String title;
  // final String recipeID;

  @override
  State<ChannelDetailsScreen> createState() => ChannelPageState();
}


class ChannelPageState extends State<ChannelDetailsScreen> {


  final _txtUserName = TextEditingController();

  // late final String recipeID;
  late Channel _currChannel;


  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastProductID = prefs.getInt('lastProductID');

    var url = "chanels/getChanelDetails.php?channelID=$lastProductID";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    // Map<String, dynamic> i in json.decode(response.body)
    _currChannel = Channel.fromJson(json.decode(response.body));
    setState(() {

    });
  }



  Future insertpagetofollowinglist(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("userID");
    var url = "carts/insertpagetoSavedlist.php?userID=" +
        userID! +
        "&channelID=" +
        _currChannel.channelID.toString();
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to saved list!')),
    );

  }


  @override
  Widget build(BuildContext context) {
    getDetails();


    return Scaffold(
      appBar: AppBar(
        title: Text("New life skills", style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,


              children: [


                Center(
                  child:
                  Image.network(_currChannel.ImageURL),

                ),


                const SizedBox(height: 20),
                Text(
                  _currChannel.channelName, style: const TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w300, color: Colors.blueGrey),
                ),


                const SizedBox(height: 10),
                const Text("Links: ",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),


                Text(_currChannel.channelLinks.toString()),

                const SizedBox(height: 10),
                Divider(thickness: 1, color: Colors.grey.shade400),
                const SizedBox(height: 10),

                // Add to Cart Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart logic here
                      insertpagetofollowinglist(context);
                    },

                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to saved list'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
