import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyTravelPosterDesign()));
}

// Helper class for poster description text spans
class TextStyleFormat {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final String? fontFamily;
  final double? letterSpacing;

  TextStyleFormat({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.color,
    this.fontFamily,
    this.letterSpacing,
  });
}

class MyTravelPosterDesign extends StatelessWidget {
  const MyTravelPosterDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.red,
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
                _postCoverImage(
                    coverUrl:
                        'https://www.areacambodia.com/wp-content/uploads/2023/09/Experiencing-the-Magical-Equinox-Sunrise-at-Angkor-Wat-A-Must-See-in-Cambodia-2023.jpg'
                    // imagePath: "assets/images/sunriseAngkor.jpg", if local image
                    ),
                _postTitles(
                  title: "សមរាត្រីអង្គរវត្ត",
                  subtitle: "ស្អាតជាងគេបំផុតលើពិភពលោក",
                ),
                _PosterInformation(
                  profile_imageUrl:
                      "https://www.nylabone.com/-/media/project/oneweb/nylabone/images/dog101/10-intelligent-dog-breeds/golden-retriever-tongue-out.jpg?h=430&w=710&hash=7FEB820D235A44B76B271060E03572C7",
                  name: "Symon PSM",
                  status: "Posted 1 hour ago",
                ),
                _buildRichTextDescription(
                  posterDescription: [
                    TextStyleFormat(text: "This was the most "),
                    TextStyleFormat(
                        text: "breath-taking sunrise\n",
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.red),
                    TextStyleFormat(
                      text:
                          "I have ever seen in my life. The colors were just magical. Highly recommended to visit Angkor Wat at least once in your lifetime!",
                      color: Colors.blue,
                    ),
                  ],
                  right: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Flexible Rich Text Description method for Poster Description
  Positioned _buildRichTextDescription({
    required List<TextStyleFormat> posterDescription,
    double bottom = 20,
    double left = 20,
    double? right,
  }) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: RichText(
        text: TextSpan(
          children: posterDescription.map((desc) {
            return TextSpan(
              text: desc.text,
              style: TextStyle(
                fontSize: desc.fontSize ?? 16,
                fontWeight: desc.fontWeight ?? FontWeight.w400,
                fontStyle: desc.fontStyle,
                color: desc.color ?? Colors.grey.shade800,
                fontFamily: desc.fontFamily,
                letterSpacing: desc.letterSpacing ?? 1.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  //Poster Information method: Name, Post Status, and Profile Avatar
  Positioned _PosterInformation({
    required String profile_imageUrl,
    required String name,
    required String status,
  }) {
    return Positioned(
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
              child: Image.network(
                profile_imageUrl,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                //Error builder if image no found
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 62,
                    height: 62,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                status,
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
    );
  }

  //Post Cover Image method
  Positioned _postCoverImage({
    required String coverUrl,
  }) {
    return Positioned(
      top: 0,
      left: 0,
      child: Image.network(
        coverUrl ??
            'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/6b/27/58/caption.jpg?w=1200&h=-1&s=1',
        width: 400,
        height: 300,
        fit: BoxFit.cover,
        //Error builder if image no found
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 400,
            height: 300,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  //Post Titles and Subtitles method
  Positioned _postTitles({required String title, required String subtitle}) {
    return Positioned(
      top: 200,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
          SizedBox(height: 8),
          Text(
            subtitle,
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
        ],
      ),
    );
  }
}

/*
  Note:
//Poster Information method: Name, Post Status, and Profile Avatar
Positioned _PosterInformation({
  required String name,
  required String status,
}) {
  return Positioned(
    top: 330,
    left: 40,
    child: Row(
      children: [
        CircleAvatar(
          radius: 33,
          backgroundColor: Colors.grey[400],
          child: CircleAvatar(
            radius: 31,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
              'https://www.nylabone.com/-/media/project/oneweb/nylabone/images/dog101/10-intelligent-dog-breeds/golden-retriever-tongue-out.jpg?h=430&w=710&hash=7FEB820D235A44B76B271060E03572C7',
            ),
            onBackgroundImageError: (exception, stackTrace) {},
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              status,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey,  // ✅ Changed from grey.shade600
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
*/
