import 'dart:convert';

import 'package:file_upload_web/profile/view/login-view.dart';
import 'package:file_upload_web/profile/view/profile_screen.dart';
import 'package:file_upload_web/profile/view/register-view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'app',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      // primarySwatch: Colors.green,
    ),
    home: LoginView(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Future<http.Response> loginReturnsFuture(
  //     {String? password, String? userName}) async {
  //   return http.post(
  //     Uri.parse('http://localhost:4558/api/v1/auth/login'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String?, String?>{
  //       'userName': userName,
  //       'password': password,
  //     }),
  //   );
  // }

  // Future<http.Response?> loginReturnsHTTPResponse(
  //     {String? password, String? userName}) async {
  //   return http.post(
  //     Uri.parse('http://localhost:4558/api/v1/auth/login'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String?, String?>{
  //       'userName': userName,
  //       'password': password,
  //     }),
  //   );
  // }

  // fake future for future users like ?
  // futurebuilder widgets
  Future<num> waitForSeconds() {
    return Future.delayed(Duration(seconds: 4), (() {
      return 11111111111;
    }));
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapar'),
      ),
    );
    // body: Column(children: [
    //   SizedBox(
    //     height: 40.0,
    //     width: 100,
    //     child: ElevatedButton(
    //       onPressed: () async {
    //         Navigator.of(ctx).push(MaterialPageRoute(
    //             builder: ((context) => const LoginView())));
    //       },
    //       style: ElevatedButton.styleFrom(
    //         primary: Colors.blueGrey,
    //       ),
    //       child: const Text('Login'),
    //     ),
    //   ),
    //   const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 16.0),
    //     child: Divider(),
    //   ),
    //   // TextButton(
    //   //   onPressed: () async {
    //   //     Navigator.of(ctx).push(MaterialPageRoute(
    //   //         builder: ((context) => const RegisterView())));
    //   //   },
    //   //   child: const Text('tap to register'),

    //   // body: FutureBuilder(
    //   //     // future: loginReturnsFuture(userName: 'fm', password: '123'),
    //   //     future: waitForSeconds(),
    //   //     builder: ((ctx, snapshot) {
    //   //       switch (snapshot.connectionState) {
    //   //         case ConnectionState.done:
    //   //           print(snapshot.data!);
    //   //           // Navigator.of(ctx).pop();
    //   //           return const LoginView();
    //   //         default:
    //   //           // Navigator.of(context).push(
    //   //           //     MaterialPageRoute(builder: (context) => const LoginView()));
    //   //           return const Text("Loading waiting for number ");
    //   //       }
    //   //     })),
    //   // )
    // ]));
  }
}
