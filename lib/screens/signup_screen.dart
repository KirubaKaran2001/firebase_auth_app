// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  UserCredential? userCredential;
  var temp;
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign Up',
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please Enter your email';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                                   validator: (value) {
                              if (value == null) {
                                return 'Please Enter your password';
                              } else {
                                return null;
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              createUserWithEmailAndPassword(
                                emailController.text,
                                passwordController.text,
                              );
                            },
                            child: const Text(
                              'Create Account',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const LoadingScreen(),
      ),
    );
  }

// Firebase Create User
  Future<void> createUserWithEmailAndPassword(
      String emailController, String passwordController) async {
    if (formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        const LoadingScreen();
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.toString(),
                password: passwordController.toString())
            .whenComplete(() {
          FirebaseAuth userCredential = FirebaseAuth.instance;
          FirebaseFirestore.instance.collection('User').doc().set({
            'email': emailController,
            'uid': userCredential.currentUser!.uid,
            'password': passwordController,
            'register_time': FieldValue.serverTimestamp(),
          });
          
        }).whenComplete(() {
          const snackBar = SnackBar(
              content: Text(
            "Your account has been Created",
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        Navigator.pushNamed(context, '/signInScreen');
      } on FirebaseAuthException catch (e) {
        loading = false;
        if (e.code == 'weak-password') {
          loading = false;
          Navigator.pop(context);
          const snackBar = SnackBar(
              content: Text(
            'Your Password too weak,\nPlease make sure your password more than 6 characters',
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'email-already-in-use') {
          Navigator.pop(context);
          const snackBar = SnackBar(
              content: Text(
            'Oh no! It seems like this email is already Registered.',
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        print(e);
      }
    } else {
      const LoadingScreen();
    }
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
