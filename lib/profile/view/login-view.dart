import 'dart:convert';

import 'package:file_upload_web/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<http.Response> login({String? password, String? userName}) async {
    return http.post(
      Uri.parse('http://localhost:8080/api/v1/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String?, String?>{
        'userName': userName,
        'password': password,
      }),
    );
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.pink,
    duration: Duration(seconds: 5),
    content: const Text('Yay! A SnackBar!'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          decoration: const InputDecoration(hintText: 'plz enter email'),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'plz enter password'),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            print(email + password);
            await login(password: password, userName: email);
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => ProfileScreen())));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Text('Login'),
        ),
      ]),
    );
  }
}
