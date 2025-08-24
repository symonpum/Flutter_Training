import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> args) {
  runApp(Material());
}

class User {
  final String name;
  final String email;
  User({required this.name, required this.email});
  factory User.fromJson(Map<String, dynamic> json){
    return User({
      name:'${json['name']['first']} ${json['name']['last']}',
      email: json['email']);
  }
}

Future<User> fetchUser async {
  //POS, GET, PUT, DELETE , PATCH,
  final respone = await http.get(Uri.parse("https://randomuser.me/api/?inc=name,email"));
  if(respone.statusCode == 200){
    final jsonData = json.decode(respone.body);
    final List<dynamic> results = jsonData['results'];
    return User.fromJson(results[0] as Map<String, dynamic>);
  }else {
    throw Exception("Failed to Load User");
  }
}

class AdvancedTextExample extends StatefulWidget{
  const AdvancedTextExample({super.key});
  @override
  // TODO: implement key
  State<AdvancedTextExample> createState() => _AdvancedTextEXampleState();
}
class _AdvancedTextEXampleState extends State<AdvancedTextExample> {
  late Future<User> futureUser;

  @override
  void iniState(){
    super.initState();
    futureUser = fetchUser();
  }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                          fontSize: 18.0, color: Colors.black87),
                      children: [
                        const TextSpan(
                          text: 'Name: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: snapshot.data?.name ?? "",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('${snapshot.data?.name}');
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.black87),
                      children: [
                        const TextSpan(
                          text: 'Email: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: snapshot.data?.email ?? "",
                        ),
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

