import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

final supabase = Supabase.instance.client;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  'Create An Account',
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
                            FocusManager.instance.primaryFocus?.unfocus();
                            final authResponse = await supabase.auth.signUp(
                              password: passwordController.text,
                              email: emailController.text,
                              emailRedirectTo:
                              'io.supabase.flutterquickstart://login-callback/',
                            );

                            setState(() {
                              _errorMessage = '';
                              _showErrorMessage = false;
                            });
                          } on AuthException catch (e) {
                            setState(() {
                              _errorMessage = e.message;
                              _showErrorMessage = true;
                            });
                          }
                        },
                        child: const Text('Sign Up')),
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
