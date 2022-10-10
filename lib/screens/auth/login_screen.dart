// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:store_and_lock/widgets/widgets.dart';
import '../../constant/text.dart';
import '../../helper/helper_funs.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../home_screen.dart';
import 'register_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService authService = AuthService();
  bool isLoading = false;
  bool hidePassword = true;

  dynamic email;
  dynamic password;

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.loggedIn(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          await HelperFunctions.saveUserLoggedinStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUsername(snapshot.docs[0]['fullName']);
          removeAndReplace(context, const HomeScreen());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  height: size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff283048),
                        Color(0xff859398),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      ClipRRect(
                        child: Image.asset(
                          'images/lock.png',
                          height: size.height * 0.3,
                          width: size.width,
                        ),
                      ),
                      Container(
                        height: size.height * 0.65,
                        decoration: const BoxDecoration(
                          color: Color(0xff283048),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Spacer(),
                              const ModifiedText(
                                text: 'Welcome back!',
                                size: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              const Spacer(),
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: textInputDecoration.copyWith(
                                  labelText: 'Please enter your email address',
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Email can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const Spacer(),
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                obscureText: hidePassword,
                                decoration: textInputDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    child: Icon(
                                      hidePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  labelText: 'password',
                                ),
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Password can't be empty";
                                  } else if (value.length < 6) {
                                    return "Password must have 6 characters minimum";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () async {
                                  login();
                                },
                                child: const Text('Log in'),
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  text: 'New to here?  ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                        text: 'Creat account',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreen(context, const SignUp());
                                          }),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
