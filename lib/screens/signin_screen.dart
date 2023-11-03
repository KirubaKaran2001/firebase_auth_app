// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  UserCredential? userCredential;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In',
          ),
        ),
        body: (!loading)
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              signIn(emailController.text,
                                  passwordController.text);
                            },
                            child: const Text(
                              'Login',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const Center(child: LoadingScreen()),
      ),
    );
  }

  //sigIn
  Future signIn(String emailController, String passwordController) async {
    if (formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        const LoadingScreen();
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController,
          password: passwordController,
        );
        Navigator.pushNamed(context, '/userDetailsScreen');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            loading = false;
            const snackBar = SnackBar(
                content: Text(
              'User not located. Please verify the details and try again',
            ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            print('No user found for that email.');
          });
        } else if (e.code == 'wrong-password') {
          return null;
        }
      }
    } else {
      const LoadingScreen();
    }
  }
}
