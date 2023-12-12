import 'package:doenertop/components/responsive_text.dart';
import 'package:doenertop/views/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Shop extends StatefulWidget {
  Map<String, dynamic> data;
  Shop({super.key, required this.data});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  File? _image;
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> loadImage() async {
    if (widget.data['image'] == null) {
      setState(() {});
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute.path}/${widget.data['image']}";
    _image = File(filePath);

    final downloadTask =
        storageRef.child(widget.data['image']).writeToFile(_image!);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          //print("Download is $progress% complete.");
          break;
        case TaskState.paused:
          print("Download is paused.");
          break;
        case TaskState.canceled:
          print("Download was canceled");
          break;
        case TaskState.error:
          print("Download error");
          break;
        case TaskState.success:
          setState(() {});
          break;
      }

      setState(() {});
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ResponsiveText(
          text: widget.data['name'],
          style: const TextStyle(
            fontFamily: 'DelaGothicOne',
            color: Colors.green,
            fontSize: 24,
          ),
        ),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              width: MediaQuery.of(context).size.width * 0.95,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: _image != null
                  ? Image.file(_image!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.95)
                  : Center(
                      child: LoadingAnimationWidget.twoRotatingArc(
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            ResponsiveText(
              text: "Address: ${widget.data['address']}",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            ResponsiveText(
              text: "Price: ${widget.data['price']}€",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
