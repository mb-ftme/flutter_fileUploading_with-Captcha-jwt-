import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  void register({String? password, String? userName}) async {
    http.Response res = await http.post(
      Uri.parse('http://localhost:8080/api/v1/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String?, String?>{
        'userName': userName,
        'password': password,
      }),
    );
    print(res);
    print(jsonDecode(res.body));
  }

  // void senddataforregister() async {
  //   print("function is ok");
  //   http.Response res = await http.post(
  //     Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'title': 'aut',
  //     }),
  //   );
  //   print(res);
  //   print(jsonDecode(res.body));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
            register(password: password, userName: email);
          },
          child: const Text('Register'),
        ),
      ]),
    );
  }
}
