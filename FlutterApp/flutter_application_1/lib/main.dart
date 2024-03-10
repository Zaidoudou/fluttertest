import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_application_1/screen/home.dart';

const String serverUrl = 'http://192.168.1.32:8080';

void main() {
  runApp(const MyApp());
}

Future<int> userCredentials(String action, String username, String password) async {
  switch (action) {
    case 'user':
    final response = await http.delete(
      Uri.parse('$serverUrl/$action'),
    ).timeout(const Duration(seconds: 10));
    return response.statusCode;

    default:
    final response = await http.post(
      Uri.parse('$serverUrl/$action'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));
    return response.statusCode; //
    }
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('We are sad to see you go.'),
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
                    break;
                  default:
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
          ElevatedButton(
            onPressed: () async {
              // Login user
              final username = usernameController.text;
              final password = passwordController.text;
              int status = await userCredentials('login',username, password);
              if (status == 200) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              } else if (status == 408) {
                showDialog(
                  context: context, 
                  builder:(BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Request Timed Out'),
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
              } else if (status == 400){
                showDialog(
                  context: context,
                   builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Invalid Username or Password'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
              });
              } else {
                showDialog(
                  context: context
                  , builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Failed to Login'),
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
                    showDialog(
                      context: context, 
                      builder:(BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Successfully Registered'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.popUntil(context, (route) => route.isFirst);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                      );
                  } else if (status == 408) {
                    showDialog(
                      context: context, 
                      builder:(BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Request Timed Out'),
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
                  } else if (status == 400){
                    showDialog(
                      context: context,
                       builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Invalid Username or Password'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                  });
                  } else {
                    showDialog(
                      context: context
                      , builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Failed to Register'),
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

                } else {
                  showDialog(
                    context: context,
                     builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Passwords do not match'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                });}
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
