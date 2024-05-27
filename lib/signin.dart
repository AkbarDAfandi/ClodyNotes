import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloudynotesv3/home.dart';

final supabase = Supabase.instance.client;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late bool _obscureText;
  late bool _showErrorMessage;
  late String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _obscureText = false;
    _showErrorMessage = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login Into Your Account',
                  style: GoogleFonts.roboto(
                    height: 1.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0), // Add horizontal padding
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add horizontal padding
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: passwordController,
                      obscureText: !_obscureText,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add horizontal padding
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final authResponse =
                              await supabase.auth.signInWithPassword(
                            password: passwordController.text,
                            email: emailController.text,
                          );

                          setState(() {
                            _errorMessage = '';
                            _showErrorMessage = false;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } on AuthException catch (e) {
                          setState(() {
                            _errorMessage = e.message;
                            _showErrorMessage = true;
                          });
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                ),
                Visibility(
                  visible: _showErrorMessage,
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
