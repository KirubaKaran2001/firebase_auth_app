import 'package:firebase_auth_app/screens/signin_screen.dart';
import 'package:firebase_auth_app/screens/signup_screen.dart';
import 'package:firebase_auth_app/screens/user_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBW1i4gSbpTj_N56622FwePhhZZEg2J9o0",
      appId: "1:639013180908:web:da6525aeeb81a560a65cc9",
      messagingSenderId: "639013180908",
      projectId: "fir-auth-b95bf",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
      onGenerateRoute: (RouteSettings settings) {
        debugPrint('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/signUpScreen': (BuildContext context) => const SignUpScreen(),
          '/signInScreen': (BuildContext context) => const SignInScreen(),
          '/userDetailsScreen': (BuildContext context) =>
              const UserDetailsScreen(),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(
          builder: (ctx) => builder(ctx),
        );
      },
    );
  }
}
