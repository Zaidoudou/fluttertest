// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/screen/home.dart';
import 'dart:convert';

const String serverUrl = 'http://localhost:8080';
const String authToken = 'aaTHi9gvqjEZQ72rocA4kX9TJJwkzgQkX5SL3aWxot2yoAKAZJ';

void main() {
  runApp(const MyApp());
}

//api interaction are not recurrent so we can afford to use http.get and http.post instead of using a client
Future<int> userCredentials(String action, String username, String password) async {
  switch (action) {
    case 'user':
    final response = await http.delete(
      Uri.parse('$serverUrl/$action'),
      headers: {
        'authorization': authToken,
      },
    ).timeout(const Duration(seconds: 10));
    return response.statusCode;

    default:
    final response = await http.post(
      Uri.parse('$serverUrl/$action'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': authToken,
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));
    return response.statusCode; //
    }
}

//We're using showDialog a lot so I used a function to cut down on the code.
void _showDialog(String pop, BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              switch(pop) {
                case 'pop':
                  Navigator.pop(context);
                  break;
                case 'popUntil':
                  Navigator.popUntil(context, (route) => route.isFirst);
                  break;
                default:
                  Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Login/Register Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FrontPage(),
    );
  }
}

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to register screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int status = await userCredentials('user', 'null', 'null');
                switch(status) {
                  case 200:
                    _showDialog('pop', context, 'Success', 'User Deleted');
                    break;
                  default:
                    _showDialog('pop', context, 'Error', 'Failed to Delete User');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Uknown error : Server Unreachable'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                }
              },
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Login user
              final username = usernameController.text;
              final password = passwordController.text;
              int status = await userCredentials('login',username, password);
              if (status == 200) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              } else if (status == 408) {
                _showDialog('pop', context,'Error', 'Request Timed Out');
              } else if (status == 401){
                _showDialog('pop', context,'Error', 'Invalid Username or Password');
              } else {
                _showDialog('pop', context,'Error', 'Failed to Login');
              }
            },
            child: const Text('Login'),
          ),
        ],
        )
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                // Register user
                final username = usernameController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;
                if (password == confirmPassword) {
                  int status = await userCredentials('register',username, password);
                  if (status == 200) {
                    _showDialog('popUntil', context, 'Success', 'User Registered');
                  } else if (status == 408) {
                    _showDialog('pop', context, 'Error', 'Request Timed Out');
                  } else if (status == 400){
                    _showDialog('pop', context, 'Error', 'Invalid Username or Password');
                  } else {
                    _showDialog('pop', context, 'Error', 'Failed to Register');
                  }

                } else {
                  _showDialog('pop', context, 'Error', 'Password Mismatch');
                  }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
