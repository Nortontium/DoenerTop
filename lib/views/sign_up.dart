import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doenertop/components/responsive_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ResponsiveText(
                text: "Sign Up",
                style: const TextStyle(
                  fontFamily: "DelaGothicOne",
                  fontSize: 36,
                  color: Colors.green,
                ),
              ),
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
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                style: const TextStyle(
                  fontFamily: "Roboto",
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
                style: const TextStyle(
                  fontFamily: "Roboto",
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                ),
                onPressed: () async {
                  String name = _nameController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  try {
                    await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    final data = <String, dynamic>{
                      "email": email,
                      "name": name,
                    };

                    _firestore
                        .collection("users")
                        .doc(_auth.currentUser?.uid)
                        .set(data);

                    if (!context.mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    //handle signup errors
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
