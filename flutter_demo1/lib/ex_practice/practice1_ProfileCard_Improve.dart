import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyProfileCard()));
}

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Practice#1: Profile Card'),
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
            height: 500,
            child: Stack(
              children: [
                _buildCoverImage(),
                _buildCircleProfileImage(),
                _buildName_Username(
                  name: 'Symon PUM',
                  username: '@symonpum',
                ),
                _buildProfileBio(),
                _buildFollows(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Following & Followers
Positioned _buildFollows() {
  return Positioned(
    bottom: 20,
    left: 20,
    right: 20,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '1.6M',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 6),
        Text(
          'Following',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 18,
          ),
        ),
        SizedBox(width: 24),
        Text(
          '3.5M',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 6),
        Text(
          'Followers',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}

//profile Bio
Positioned _buildProfileBio() {
  return Positioned(
    bottom: 80,
    left: 20,
    right: 20,
    child: RichText(
      text: TextSpan(
        text: 'Profile Card Design Practice ',
        style: TextStyle(fontSize: 16, color: Colors.black87),
        children: [
          TextSpan(
            text: '@Flutter.Com.\n',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          TextSpan(
            text: 'Design Beautiful App to practice your Idea\n',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          TextSpan(
            text: 'using Code into Reality!',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}

//Name & Username
Positioned _buildName_Username({
  required String name,
  required String username,
}) {
  return Positioned(
    bottom: 180,
    left: 20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          username,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    ),
  );
}

//cirlce profile image
Positioned _buildCircleProfileImage() {
  return Positioned(
    bottom: 260,
    left: 20,
    child: CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 46,
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(
          'https://www.khmerbeverages.com/wp-content/uploads/2021/01/Hea-Petter.png',
          //assetimage('assets/images/symonpum1x1.png'),
          // Error handling for image loading
        ),
        onBackgroundImageError: (exception, stackTrace) {
          // Handle image loading error
        },
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

//Cover Image
Image _buildCoverImage() {
  return Image.network(
    'https://www.krones.com/media/images/KHB_Product_Family_20230102_1240x826px.jpg',
    height: 250,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.grey,
        ),
      );
    },
  );
}
