import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_development_evaluation/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = GlobalKey<FormState>();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _hidePassword = true;

  Future<String> verifyUser(String email, String password) async {
    const int successResponseCode = 200;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/verify-user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == successResponseCode) {
      final preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setString('email', email);
      });
      return response.body;
    } else {
      throw Exception('Failed to verify user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold)
              ),
              const Text(
                "Journeys last a lifetime.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500
                )
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(Icons.email),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email.';
                  }
                  return null;
                }
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  label: const Text("Password"),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_hidePassword
                      ? Icons.visibility
                      : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    }),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)
                  )
                ),
                obscureText: _hidePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'The password must be 8 characters long.';
                  }
                  return null;
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Creates a new user document with their email and
                    // password.
                    verifyUser(email.text, password.text).then(
                      (response) => {
                        if (response == 'SUCCESS') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const MainPage()
                            )
                          )
                        } else if (response == 'USER_DOES_NOT_EXIST') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0
                                    ),
                                    child: Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.white
                                    ),
                                  ),
                                  Text('The email is not registered.'),
                                ]
                              ),
                              backgroundColor: Colors.redAccent,
                            )
                          )
                        } else if (response == 'WRONG_PASSWORD') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0
                                    ),
                                    child: Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.white
                                    ),
                                  ),
                                  Text('The password is incorrect.'),
                                ]
                              ),
                              backgroundColor: Colors.redAccent,
                            )
                          )
                        }
                      }
                    );
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0
                    )
                  )
                ),
                child: const Text('Login')
              )
            ]
          )
        )
      )
    );
  }
}
