import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cloudynotesv3/home.dart';
import 'package:cloudynotesv3/signup.dart';
import 'package:cloudynotesv3/splashscreen.dart';
import 'package:cloudynotesv3/signin.dart';
import 'package:cloudynotesv3/editor.dart';
import 'package:cloudynotesv3/create.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dsolvzckqpvsghfiymrw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRzb2x2emNrcXB2c2doZml5bXJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYwMDYxNTksImV4cCI6MjAzMTU4MjE1OX0.6_SPQeR14up78BI8ExbYz6nACpAERf2vJ74AML_Ws3Y',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudy Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) => const SignUp(),
        '/singin': (context) => const SignIn(),
        '/home': (context) => const HomePage(),
        '/editor': (context) => const EditPage(noteId: ''),
        '/create': (context) => const CreatePage(),
        }
    );
  }
}