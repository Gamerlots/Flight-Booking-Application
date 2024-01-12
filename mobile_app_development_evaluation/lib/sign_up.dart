import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_development_evaluation/bookings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = GlobalKey<FormState>();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  Future<String> createUser(String email, String password) async {
    const int successResponseCode = 200;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/add-user/'),
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
      throw Exception('Failed to create user.');
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
                "Sign Up",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold
                )
              ),
              const Text(
                "Start traveling today.",
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
                },
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
                    }
                  ),
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
              TextFormField(
                controller: confirmPassword,
                decoration: InputDecoration(
                  label: const Text('Confirm password'),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_hideConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword = !_hideConfirmPassword;
                      });
                    }
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)
                  )
                ),
                obscureText: _hideConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (value != password.text) {
                    return 'The passwords do not match.';
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
                    // Creates a new user document with their email
                    // and password.
                    createUser(email.text, password.text).then(
                      (response) => response == 'SUCCESS'
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const Bookings()
                            )
                          )
                        : print('The user exists.')
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
                child: const Text('Sign Up')
              )
            ]
          )
        )
      )
    );
  }
}
