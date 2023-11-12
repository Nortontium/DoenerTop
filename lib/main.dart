import 'package:doenertop/views/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DoenerTop());
}

class DoenerTop extends StatelessWidget {
  const DoenerTop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoenerTop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: "DelaGothicOne",
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
