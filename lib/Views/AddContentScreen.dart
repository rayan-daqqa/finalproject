import 'package:final_project/Views/HomepageScreen.dart';
import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Utils/Utils.dart';
import '../Utils/db.dart';

class AddContentScreen extends StatefulWidget {
  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  // Controllers للتحكم في النصوص المدخلة
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _channelTypeController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  // دالة لحفظ البيانات
  void _saveContent() {
    final String title = _titleController.text.trim();
    final String channelType = _channelTypeController.text.trim();
    final String link = _linkController.text.trim();

    if (title.isEmpty || channelType.isEmpty || link.isEmpty) {
      // إذا في حقل فارغ، يظهر رسالة تحذير
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى ملء جميع الحقول!')),
      );
    } else {
      // هنا يمكن إرسال البيانات للسيرفر أو حفظها في قاعدة البيانات
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إضافة المحتوى بنجاح!')),
      );

      // تفريغ الحقول بعد الحفظ
      _titleController.clear();
      _channelTypeController.clear();
      _linkController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة محتوى جديد'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل العنوان
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // حقل نوع القناة
            TextField(
              controller: _channelTypeController,
              decoration: InputDecoration(
                labelText: 'نوع القناة',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // حقل الرابط
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'رابط المحتوى',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url, // لتسهيل إدخال الروابط
            ),
            SizedBox(height: 24),

            // زر الحفظ
            ElevatedButton(
              onPressed: _saveContent,
              child: Text('حفظ المحتوى'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  /*const Addcontentscreen({super.key, required this.title});

  final String title;

  @override
  State<Addcontentscreen> createState() => AddContentPageState();
}

class AddContentPageState extends State<Addcontentscreen> {
  final _txttopic = TextEditingController();
  final _txtcategory = TextEditingController();


  void Insertchannelfunc() {
    if (_txttopic.text != ""||_txtcategory.text != "") {
      
      
      
      /*
      var uti=new Utils();
      uti.showMyDialog(context, "success", "you registed successfully");
      _txtFirstName.text="";
      _txtlasttName.text="";
      _txtPassword.text="";
      */
    } else {
      var uti = new Utils();
      uti.showMyDialog(context, "Required", "Please insert first name");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "FirstName*:",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _txtFirstName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'enter your FirstName',
                ),
              ),
            ),
            Text(
              "LastName:",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _txtlasttName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'enter your LastName',
                ),
              ),
            ),
            Text(
              "email*:",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _txtEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'enter your email',
                ),
              ),
            ),
            Text(
              "password*:",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _txtPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'enter your password',
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const HomePageScreen(title: 'login')),
                );
              },
              child: Text('HomePage'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                // var uti = new Utils();
                // uti.showMyDialog(context, _txtFirstName.text, _txtFirstName.text);

                InsertUserFunc();
              },
              child: Text('creat'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
   */
