import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stockgram/bloc/auth/auth_bloc.dart';
import 'package:stockgram/presentation/widgets/bottombar.dart';
import 'package:stockgram/util/toast.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  createUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "jaitest@gmail.com",
        password: "Jai@1234",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordCotroller = TextEditingController();
  AuthBloc authBloc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  width: MediaQuery.of(context).size.width * 0.55,
                ),
              ),
            ),
            BlocConsumer<AuthBloc, AuthState>(
              bloc: authBloc,
              listener: (context, state) {
                if (state is AuthLoginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomBar(),
                    ),
                  );
                }
                if (state is AuthLoginFailed) {
                  CustomToast.showErroMessage(state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      const Text(
                        "Please signin to continue",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email, size: 24),
                          ),
                          controller: userNameController,
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock_rounded, size: 24),
                          ),
                          controller: passwordCotroller,
                          onChanged: (value) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // _signInWithEmailAndPassword();
                              authBloc.add(
                                AuthLoginEvent(
                                  email: userNameController.text,
                                  password: passwordCotroller.text,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              height: 40,
                              width: 140,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right_alt_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Dont\'t have an account?",
                      ),
                      TextSpan(
                        text: " Sign up",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
