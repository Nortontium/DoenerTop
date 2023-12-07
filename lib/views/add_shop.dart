import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';

class ShopCreate extends StatefulWidget {
  const ShopCreate({super.key});

  @override
  State<ShopCreate> createState() => _ShopCreateState();
}

class _ShopCreateState extends State<ShopCreate> {
  final storage = FirebaseStorage.instance;
  File? _image;
  final _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      child: _image != null
                          ? Image.file(_image!,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.95)
                          : const Icon(
                              Icons.add,
                              size: 80,
                            )),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _openImagePicker();
                      },
                      child: const Text("Select an image"),
                    ),
                  ),
                  const SizedBox(height: 35),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                    style: const TextStyle(
                      fontFamily: "Roboto",
                    ),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                    style: const TextStyle(
                      fontFamily: "Roboto",
                    ),
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      final address = _addressController.text.trim();

                      var storageRef = storage
                          .ref()
                          .child("images/${name.replaceAll(" ", "_")}.jpg");

                      if (_image == null) {
                        print("Select an image");
                        return;
                      }

                      var uploadTask = storageRef.putFile(_image!);
                      //TODO: loading ui
                      uploadTask.snapshotEvents
                          .listen((TaskSnapshot taskSnapshot) {
                        switch (taskSnapshot.state) {
                          case TaskState.running:
                            final progress = 100.0 *
                                (taskSnapshot.bytesTransferred /
                                    taskSnapshot.totalBytes);
                            print("Upload is $progress% complete.");
                            break;
                          case TaskState.paused:
                            print("Upload is paused.");
                            break;
                          case TaskState.canceled:
                            print("Upload was canceled");
                            return;
                          case TaskState.error:
                            print("Upload error");
                            return;
                          case TaskState.success:
                            final firestoreRef =
                                firestore.collection('doenershops');
                            firestoreRef.add({
                              'name': name,
                              'address': address,
                              'favorites': [],
                              'image':
                                  "images/${name.replaceAll(" ", "_")}.jpg",
                            });

                            BrowseController.notifyBrowseChanged();
                            FavoritesController.notifyFavoritesChanged();

                            Navigator.pop(context);
                            break;
                        }
                      });
                    },
                    child: const Text("Add shop"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
