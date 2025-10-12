import 'package:flutter/material.dart';

void main() {
  runApp(MiCardApp_RowCol());
}

class MiCardApp_RowCol extends StatelessWidget {
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
              SizedBox(height: 10),
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

              // PhoneNumber
              _buidlItems(
                icon: Icons.phone,
                text: '+៨៥៥ ១១ ៧៦​ ៥៥ ៨៦',
                fontFamily: 'KhmerOSMuolPali',
              ),

              // Email
              _buidlItems(
                icon: Icons.email,
                text: 'symonpum@gmail.com',
                fontFamily: 'Krasar-Regular',
              ),

              // Telegram_inf
              _buidlItems(
                icon: Icons.telegram,
                text: 't.me/symonpum',
                fontFamily: 'Krasar-Regular',
              ),

              // Facebook_Info
              _buidlItems(
                icon: Icons.facebook,
                text: 'facebook.com/symonpum',
                fontFamily: 'Krasar-Regular',
              ),

              // Location_info
              _buidlItems(
                icon: Icons.location_on,
                text: '#២៤ បុរីពិភពថ្មី១ រាជធានីភ្នំពេញ',
                fontFamily: 'KhmerOSMuolPali',
                fontSize: 16.0,
              ),
              // Add one more item
              _buidlItems(
                icon: Icons.web_asset,
                text: 'www.symonpum.com',
                fontFamily: 'Krasar-Regular',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Item Functions
  Widget _buidlItems({
    required IconData icon,
    required String text,
    required String fontFamily,
    double fontSize = 20.0,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.teal,
              size: 28,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.teal.shade900,
                  fontFamily: fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
