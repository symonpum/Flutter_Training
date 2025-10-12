import 'package:flutter/material.dart';

void main() {
  runApp(MiCardApp());
}

class MiCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Mi Card Exercise"),
          backgroundColor: Colors.teal,
        ),
        backgroundColor: Colors.cyan.shade800,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.6),
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/symonpum.png'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ពុំ ស៊ីមន',
              style: TextStyle(
                fontFamily: 'KhmerOSMuolPali',
                fontSize: 36.0,
                color: Colors.orangeAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'The Oldest Student in Flutter Class',
              style: TextStyle(
                fontFamily: 'Krasar-Regular',
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
              width: 150.0,
              child: Divider(
                color: Colors.orangeAccent.shade400,
                thickness: 1.5,
              ),
            ),
            Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.teal,
                  ),
                  title: Text(
                    '+៨៥៥ ១១ ៧៦​ ៥៥ ៨៦',
                    style: TextStyle(
                      color: Colors.teal.shade900,
                      fontFamily: 'KhmerOSMuolPali',
                      fontSize: 22.0,
                    ),
                  ),
                )),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.teal,
                ),
                title: Text(
                  'symonpum@gmail.com',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.teal.shade900,
                      fontFamily: 'Karasar-Regular'),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.telegram,
                  color: Colors.teal,
                ),
                title: Text(
                  't.me/symonpum',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Krasar-Regular',
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.facebook,
                  color: Colors.teal,
                ),
                title: Text(
                  'facebook.com/symonpum',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Krasar-Regular',
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.teal,
                ),
                title: Text(
                  '#២៤ បុរីពិភពថ្មី១ រាជធានីភ្នំពេញ',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'KhmerOSMuolPali',
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
