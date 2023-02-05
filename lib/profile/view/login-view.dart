import 'dart:convert';

import 'package:file_upload_web/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_captcha/local_captcha.dart';

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

  final _captchaFormKey = GlobalKey<FormState>();
  final _configFormKey = GlobalKey<FormState>();
  final _localCaptchaController = LocalCaptchaController();
  final _configFormData = ConfigFormData();

  var _inputCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Captcha Example'),
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
                  TextField(
                    controller: _email,
                    decoration:
                        const InputDecoration(hintText: 'plz enter email'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'plz enter password'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      print(email + password);
                      await login(password: password, userName: email);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => ProfileScreen())));
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Login'),
                  ),
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
                          return '* Code must be length of ${_configFormData.length}.';
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
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_captchaFormKey.currentState?.validate() ?? false) {
                          _captchaFormKey.currentState!.save();

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Code: "$_inputCode" is valid.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text('Validate Code'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _localCaptchaController.refresh(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      child: const Text('Refresh'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(),
                  ),
                  // _configForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
      // body: LocalCaptcha(),
    );
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
