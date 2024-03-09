import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:printUsers,
        ),
    );
  }
  void fetchUsers() async {
    print('Fetching users...');
    final response = await http.get(Uri.parse('http://192.168.1.32:8080/user'));
    final body = response.body;
    print(body);
  }
  void printUsers() async {
    print('Printing users...');
    final response = await http.post(
      Uri.parse('http://192.168.1.32:8080/register'),
      headers:{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': 'user1',
        'password': 'password1',
      }),
    );
    if (response.statusCode == 200) {
      print('Successfully Registered');
    } else {
      print('Failed to print users');
      print(response.body);
    }
  }
}