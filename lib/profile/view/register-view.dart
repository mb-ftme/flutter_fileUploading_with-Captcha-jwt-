// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class RegisterView extends StatefulWidget {
//   const RegisterView({Key? key}) : super(key: key);

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;

//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   void register({String? password, String? userName}) async {
//     http.Response res = await http.post(
//       Uri.parse('http://localhost:8080/api/v1/auth/register'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String?, String?>{
//         'userName': userName,
//         'password': password,
//       }),
//     );
//     print(res);
//     print(jsonDecode(res.body));
//   }

//   // void senddataforregister() async {
//   //   print("function is ok");
//   //   http.Response res = await http.post(
//   //     Uri.parse('https://jsonplaceholder.typicode.com/albums'),
//   //     headers: <String, String>{
//   //       'Content-Type': 'application/json; charset=UTF-8',
//   //     },
//   //     body: jsonEncode(<String, String>{
//   //       'title': 'aut',
//   //     }),
//   //   );
//   //   print(res);
//   //   print(jsonDecode(res.body));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//       ),
//       body: Column(children: [
//         TextField(
//           controller: _email,
//           decoration: const InputDecoration(hintText: 'plz enter email'),
//         ),
//         TextField(
//           controller: _password,
//           obscureText: true,
//           enableSuggestions: false,
//           autocorrect: false,
//           keyboardType: TextInputType.emailAddress,
//           decoration: const InputDecoration(hintText: 'plz enter password'),
//         ),
//         TextButton(
//           onPressed: () async {
//             final email = _email.text;
//             final password = _password.text;
//             print(email + password);
//             register(password: password, userName: email);
//           },
//           child: const Text('Register'),
//         ),
//       ]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// void main() => runApp(const RegisterView());

// class RegisterView extends StatelessWidget {
//   const RegisterView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const title = 'WebSocket Demo';
//     return const MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//       ),
//     );
//   }
// }

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
  });

  @override
  State<RegisterView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RegisterView> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('http://localhost:8080/ws'),
  );
  var topic = "/topic/greetings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
