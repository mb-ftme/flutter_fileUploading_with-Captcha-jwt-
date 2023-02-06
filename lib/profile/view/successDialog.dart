import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SimpleDialog(
        title: Text('uploaded successfully'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, ["OK"]);
            },
            child: const Text('OK'),
          ),
        ],
        elevation: 10,
      ),
    );
  }
}
