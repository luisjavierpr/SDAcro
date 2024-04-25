import 'package:chatui/pages/events_page.dart';
import 'package:chatui/pages/home_page.dart';
import 'package:chatui/pages/profile_page.dart';
import 'package:chatui/pages/resources_page.dart';
import 'package:chatui/pages/settings_page.dart';
import 'package:chatui/pages/user_page.dart';
import 'package:chatui/services/auth/auth_gate.dart';
import 'package:chatui/firebase_options.dart';
import 'package:chatui/pages/themes/light_mode.dart';
import 'package:chatui/services/auth/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
      routes: {
        '/home': (context) => HomePage(),
        '/chat': (context) => UserPage(),
        '/ resources': (context) => ResourcesPage(),
        '/events': (context) => EventsPage(),
        '/profile': (context) =>  ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/login_or_register': (context) => const LoginOrRegister(),
      },
    );
  }
}
