import 'package:doenertop/components/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/responsive_text.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: ResponsiveText(
          text: "Profil",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontFamily: "DelaGothicOne",
          ),
        ),
      ),
      body: GetUserInfo(_auth.currentUser!.uid),
    );
  }
}
