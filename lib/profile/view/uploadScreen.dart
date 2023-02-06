import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:file_upload_web/profile/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class uploadScreen extends StatefulWidget {
  const uploadScreen({super.key});

  @override
  State<uploadScreen> createState() => _uploadScreenState();
}

class _uploadScreenState extends State<uploadScreen> {
  List<PlatformFile>? _paths;

  void pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['xls', 'xlsx', 'csv'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('looooooooooooooooooooooooooooooooooooooooooq');
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      if (_paths != null) {
        //passing file bytes and file name for API call
        ApiClient.uploadFile(_paths!.first.bytes!, _paths!.first.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData x = MediaQuery.of(context);
    return Container(
      child: InkWell(
        onTap: pickFiles,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: x.size.height * 0.2,
            width: x.size.width * 0.5,
            margin: const EdgeInsets.only(
              left: 183.00,
              top: 10.00,
              right: 113.00,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(
                8.00,
              ),
            ),
            child: const Icon(
              Icons.file_upload,
              size: 80,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
