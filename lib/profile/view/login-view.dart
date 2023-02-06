import 'dart:convert';
import 'dart:html';

import 'package:file_upload_web/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:local_captcha/local_captcha.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  final _captchaFormKey = GlobalKey<FormState>();

  final _localCaptchaController = LocalCaptchaController();
  final _configFormData = ConfigFormData();
  var _inputCode = '';
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _localCaptchaController.refresh();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 300.0,
            child: Form(
              key: _captchaFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter email',
                      hintText: 'Enter email',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_email.text.isEmpty) {
                        return '* Required field.';
                      }
                    },
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter password',
                      hintText: 'Enter password',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_password.text.isEmpty) {
                        return '* Required field.';
                      }
                    },
                    controller: _password,
                  ),
                  const SizedBox(height: 16.0),
                  LocalCaptcha(
                    key: ValueKey(_configFormData.toString()),
                    controller: _localCaptchaController,
                    height: 150,
                    width: 300,
                    backgroundColor: Colors.grey[100]!,
                    chars: _configFormData.chars,
                    length: _configFormData.length,
                    fontSize: _configFormData.fontSize > 0
                        ? _configFormData.fontSize
                        : null,
                    caseSensitive: _configFormData.caseSensitive,
                    codeExpireAfter: _configFormData.codeExpireAfter,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter code',
                      hintText: 'Enter code',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != _configFormData.length) {
                          _localCaptchaController.refresh();

                          return '* wrong code.';
                        }

                        final validation =
                            _localCaptchaController.validate(value);

                        switch (validation) {
                          case LocalCaptchaValidation.invalidCode:
                            return '* Invalid code.';
                          case LocalCaptchaValidation.codeExpired:
                            return '* Code expired.';
                          case LocalCaptchaValidation.valid:
                          default:
                            return null;
                        }
                      }

                      return '* Required field.';
                    },
                    onSaved: (value) => _inputCode = value ?? '',
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await checkCreds(context);
                      },
                      child: const Text('Validate and login'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    // child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkCreds(BuildContext context) async {
    final email = _email.text;
    final password = _password.text;

    if (_captchaFormKey.currentState?.validate() ?? false) {
      _captchaFormKey.currentState!.save();

      Response res = await login(password: password, userName: email);
      Map<String, dynamic> loginRes = jsonDecode(res.body);
      if (loginRes['token'] != null &&
          loginRes['token'].toString().isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => ProfileScreen())));
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Alert  Box"),
            content: const Text("token is null"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(14),
                  child: const Text("ok"),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}

class ConfigFormData {
  String chars = 'abdefghnryABDEFGHNQRY3468';
  int length = 5;
  double fontSize = 0;
  bool caseSensitive = false;
  Duration codeExpireAfter = const Duration(minutes: 10);

  @override
  String toString() {
    return '$chars$length$caseSensitive${codeExpireAfter.inMinutes}';
  }
}
