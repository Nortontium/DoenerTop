import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../views/home.dart';
import '../views/login.dart';

class GetUserInfo extends StatelessWidget {
  final String documentId;

  GetUserInfo(
    this.documentId, {
    super.key,
  });

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    //user logged out and returning to login page
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  "You are logged in as\n${data['name']}",
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 26,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _logout,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Center(
          child: LoadingAnimationWidget.waveDots(
            color: Colors.black,
            size: 50,
          ),
        );
      },
    );
  }
}

class CheckLogin extends StatelessWidget {
  const CheckLogin({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        //zu user homepage weiterleiten
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
            fullscreenDialog: true,
          ),
        );
      }
      if (user == null) {
        //kein user angemeldet
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
            fullscreenDialog: true,
          ),
        );
      }
    });
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.waveDots(
          color: Colors.black,
          size: 50,
        ),
      ),
    );
  }
}
