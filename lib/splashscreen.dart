import 'dart:async';

import 'package:cloudynotesv3/home.dart';
import 'package:flutter/material.dart';
import 'package:cloudynotesv3/signin.dart';
import 'package:cloudynotesv3/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    }
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/NotesIMG.png',
              width: 320,
              height: 320,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 30,),
            Text('Welcome to',
              style: GoogleFonts.roboto(
                  height: 1.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
              ),
            ),
            Text('Cloudy Notes',
              style: GoogleFonts.roboto(
                height: 1.0,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text('A note taking app with',
              style: GoogleFonts.roboto(
                height: 1.0,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text('Cloud Synchornization',
              style: GoogleFonts.roboto(
                height: 1.0,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child: Text('Sign Up',
                  style: GoogleFonts.inter(
                    height: 1.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 200),
                      reverseTransitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SignUp();
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8), // Add some spacing between buttons
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child:  Text('Sign In',
                  style: GoogleFonts.inter(
                    height: 1.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 200),
                      reverseTransitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SignIn();
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

