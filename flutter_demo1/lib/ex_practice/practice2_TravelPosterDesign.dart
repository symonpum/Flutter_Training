import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyTravelPosterDesign()));
}

class MyTravelPosterDesign extends StatelessWidget {
  const MyTravelPosterDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Practice#2: Travel Poster Design'),
        centerTitle: false,
      ),
      body: Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox(
            width: 400,
            height: 520,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/sunriseAngkor.jpg",
                    width: 400,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 220,
                  left: 20,
                  child: Text(
                    "សមរាត្រីអង្គរវត្ត",
                    style: TextStyle(
                      fontFamily: 'KhmerOSMuolPali',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 270,
                  left: 20,
                  child: Text(
                    "ស្អាតជាងគេបំផុតលើពិភពលោក",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'Krasar',
                      color: Colors.white,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 330,
                  left: 40,
                  child: Row(
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.teal,
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/symonpum1x1.png",
                            width: 62,
                            height: 62,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Symon Pum",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Posted 2 days ago",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: "This was the most ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800,
                        letterSpacing: 1.0,
                      ),
                      children: [
                        TextSpan(
                          text: "breath-taking sunrise\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        TextSpan(
                          text:
                              "I have ever seen in my life. This colors were\njust magical. Highly recommended to visit\nAngkor Wat at least once in your lifetime!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
