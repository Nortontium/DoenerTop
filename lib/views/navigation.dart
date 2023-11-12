import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

import 'package:flutter/material.dart';

import 'login.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  void push() {
    Navigator.pop(context);
  }

  void _pushHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
        fullscreenDialog: true,
      ),
    );
  }

  void _pushProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
        fullscreenDialog: true,
      ),
    );
  }

  void _pushSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
        fullscreenDialog: true,
      ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    //logged out and returning to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            TextButton(
              onPressed: _pushHome,
              child: const Text(
                "Home",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _pushProfile,
              child: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 28),
            TextButton(
              onPressed: _pushSettings,
              child: const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 28),
            TextButton(
              onPressed: _logout,
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
