import 'package:doenertop/components/responsive_text.dart';
import 'package:doenertop/views/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doenertop/views/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: ResponsiveText(
            text: "loading...",
            style: const TextStyle(
              fontFamily: "DelaGothicOne",
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveText(
                text: "DönerTop",
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.green,
                  fontFamily: "DelaGothicOne",
                ),
              ),
              const SizedBox(height: 20),
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
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (!context.mounted) return;
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user != null) { //zu user homepage weiterleiten
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                      if (user == null) { //kein user angemeldet
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                    });
                    // User successfully logged in
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    // Handle login errors
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
                child: const Text(
                  "No account yet? - Sign up now!",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
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
