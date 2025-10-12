import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyProfileCard()));
}

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.teal,
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
      child: const Text(
        'Profile Card Design Practice @Flutter.Com.\n'
        'Design Beautiful App to practice your Idea\n'
        'using Code into Reality!',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, color: Colors.black87),
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
          backgroundImage: AssetImage(
            'assets/images/symonpum1x1.png',
          ),
        ),
      ),
    );
  }

//Cover Image
  Image _buildCoverImage() {
    return Image.asset(
      'assets/images/PreksaCover.jpg',
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

/*
      //child:
  _buildCoverImage(),
      
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            clipBehavior: Clip.none,
            children: [
              // Cover Image
              Image.asset(
                'assets/images/PreksaCover.jpg', // Cover image
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Circular Profile Image
              Positioned(
                bottom: 30,
                left: 20,
                child: CircleAvatar(
                  radius: 50,
                     backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage:
                        AssetImage('assets/images/symonpum1x1.png'),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60), // Space for profile image overlap

          // Name & Username
          const Text(
            'Symon PUM',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            '@symonpum',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          // Bio
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Profile Card Design Practice @Flutter.Com.\n'
              'Design Beautiful App to practice your Idea\n'
              'using Code into Reality!',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          const SizedBox(height: 20),

          // Follower Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Column(
                children: [
                  Text(
                    '1.6M',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Following', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text(
                    '3.5M',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Followers', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
