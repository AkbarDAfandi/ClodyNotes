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
    url: '<SUPABASE_URL>',
    anonKey: '<SUPABASE_ANONKEY>',
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