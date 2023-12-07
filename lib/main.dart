import 'package:doenertop/components/firebase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DoenerTop());
}

class DoenerTop extends StatefulWidget {
  const DoenerTop({super.key});

  @override
  State<StatefulWidget> createState() => _DoenerTopState();
}

class _DoenerTopState extends State<DoenerTop> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoenerTop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: "DelaGothicOne",
      ),
      home: const CheckLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
