import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyTextHomeWork3(),
    );
  }
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: '${json['name']['first']} ${json['name']['last']}',
      email: json['email'],
    );
  }
}

Future<User> fetchUser() async {
  final response = await http.get(
    Uri.parse('https://randomuser.me/api/?inc=name,email'),
  );
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];
    return User.fromJson(results[0] as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load user');
  }
}

class MyTextHomeWork3 extends StatefulWidget {
  const MyTextHomeWork3({super.key});

  @override
  State<MyTextHomeWork3> createState() => _MyTextHomework3();
}

class _MyTextHomework3 extends State<MyTextHomeWork3> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PSM Homework#3'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Cambria',
                        color: Colors.green,
                      ),
                      children: [
                        const TextSpan(
                          text: '\nName: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        TextSpan(text: snapshot.data?.name ?? ""),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Email: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(text: snapshot.data?.email ?? ""),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            return const Text('No user data.');
          },
        ),
      ),
    );
  }
}
