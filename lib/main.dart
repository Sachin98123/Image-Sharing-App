import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_closachin/firebase_options.dart';
import 'package:insta_closachin/state/auth/backend/authenticator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello world"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              final result = await Authenticator().loginWithGoogle();
              print(result);
            },
            child: const Text('sign in with Google'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              final result = await Authenticator().loginWithFacebook();
              print(result);
            },
            child: const Text("sign in With Facebook"),
          ),
        ],
      ),
    );
  }
}
