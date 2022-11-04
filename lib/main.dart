import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/firebase_options.dart';
import 'package:insta_closachin/state/auth/providers/auth_state_provider.dart';
import 'package:insta_closachin/state/auth/providers/is_logged_in_provider.dart';
import 'package:insta_closachin/state/providers/is_loading_provider.dart';
import 'package:insta_closachin/views/components/loading/loading_screen.dart';
import 'package:insta_closachin/views/login/Login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
      home: Consumer(
        builder: (context, ref, child) {
          //Take care of displaying loading screen
          ref.listen<bool>(isLoadingProvider, (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });

          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}

//When you are logged in
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hello world"),
        ),
        body: Consumer(builder: (context, ref, child) {
          return TextButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).logOut();
            },
            child: const Text('Log Out'),
          );
        }));
  }
}

// When you are not logged in
// class LoginView extends ConsumerWidget {
//   const LoginView({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login View"),
//       ),
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
//             //   () async {
//             //   final result = await const Authenticator().loginWithGoogle();
//             //   // ignore: avoid_print
//             //   print(result);
//             //  },
//             child: const Text('sign in with Google'),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           TextButton(
//             onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,

//             //  () async {
//             //   final result = await const Authenticator().loginWithFacebook();
//             //   // ignore: avoid_print
//             //   print(result);
//             // },
//             child: const Text("sign in With Facebook"),
//           ),
//         ],
//       ),
//     );
//   }
// }
