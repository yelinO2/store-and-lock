// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../constant/text.dart';
import '../../helper/helper_funs.dart';
import '../../services/auth_service.dart';
import '../../widgets/widgets.dart';
import 'email_verify_screen.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = AuthService();
  dynamic msg;
  bool isLoading = false;
  bool hidePassword = true;
  dynamic userName;
  dynamic email;
  dynamic password;

  signup() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .registerUser(userName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedinStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUsername(userName);

          nextScreenReplace(context, const VerifyEmailScreen());
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(),
                              const Center(
                                child: ModifiedText(
                                  text: "Let's Get Started",
                                  size: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              const Center(
                                child: ModifiedText(
                                  text: "Secure your files",
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              TextFormField(
                              style: const TextStyle(color: Colors.white),
                                decoration: textInputDecoration.copyWith(
                                  labelText: 'Please enter your username',
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    userName = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Username can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
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
                                  signup();
                                },
                                child: const Text('Sign up'),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const ModifiedText(
                                    text: 'Already have an account?',
                                    color: Colors.white,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      nextScreen(context, const Login());
                                    },
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: const ModifiedText(
                                      text: 'Sign in here.',
                                    ),
                                  ),
                                ],
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
