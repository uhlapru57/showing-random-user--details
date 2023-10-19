import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomUserList(),
    );
  }
}

class RandomUserList extends StatefulWidget {
  @override
  _RandomUserListState createState() => _RandomUserListState();
}

class _RandomUserListState extends State<RandomUserList> {
  late List<dynamic> users;

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=10'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Users'),
      ),
      body: users == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title:
                      Text(user['name']['first'] + ' ' + user['name']['last']),
                  subtitle: Text(user['email']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(user: user),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final dynamic user;

  UserDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user['name']['first']} ${user['name']['last']}'),
            Text('Email: ${user['email']}'),
            Text('Phone: ${user['phone']}'),
            Text('Location: ${user['location']['country']}'),
          ],
        ),
      ),
    );
  }
}
