import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:file_upload_web/profile/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(
                                20.00,
                              ),
                              bottomRight: Radius.circular(
                                20.00,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 132.00,
                                width: 327.00,
                                margin: const EdgeInsets.only(
                                  left: 10.00,
                                  top: 24.00,
                                  right: 10.00,
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    _paths != null
                                        ? Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 100.00,
                                              width: 100.00,
                                              margin: const EdgeInsets.only(
                                                left: 113.00,
                                                top: 10.00,
                                                right: 113.00,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    50.00,
                                                  ),
                                                  image: DecorationImage(
                                                      image: MemoryImage(_paths!
                                                          .first.bytes!))),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: pickFiles,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                height: 30.00,
                                                width: 30.00,
                                                margin: const EdgeInsets.only(
                                                  left: 183.00,
                                                  top: 10.00,
                                                  right: 113.00,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5.00,
                                                  ),
                                                ),
                                                // child: const Icon(
                                                //   Icons.add,
                                                //   size: 80,
                                                //   color: Colors.red,
                                                // ),
                                              ),
                                            ),
                                          ),
                                    // InkWell(
                                    //   onTap: pickFiles,
                                    //   child: Align(
                                    //     alignment: Alignment.bottomCenter,
                                    //     child: Container(
                                    //       height: 30.00,
                                    //       width: 30.00,
                                    //       margin: const EdgeInsets.only(
                                    //         left: 200.00,
                                    //         top: 200.00,
                                    //         right: 200.00,
                                    //       ),
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.white70,
                                    //         borderRadius: BorderRadius.circular(
                                    //           5.00,
                                    //         ),
                                    //       ),
                                    //       child: const Icon(
                                    //         Icons.download_done,
                                    //         size: 80,
                                    //         color: Colors.blue,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
