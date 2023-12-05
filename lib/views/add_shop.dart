import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ShopCreate extends StatefulWidget {
  const ShopCreate({super.key});

  @override
  State<ShopCreate> createState() => _ShopCreateState();
}

class _ShopCreateState extends State<ShopCreate> {
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
    );
  }
}
