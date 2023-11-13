import 'package:doenertop/components/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/responsive_text.dart';
import 'navigation.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _pushNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Navigation(),
      ),
    );
  }

  void _pushProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: _pushNavigation,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 30,
            height: 30,
            child: SvgPicture.asset(
              "assets/icons/list.svg",
              width: 20,
              height: 20,
            ),
          ),
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
      body: GetUserName(_auth.currentUser!.uid),
    );
  }
}
