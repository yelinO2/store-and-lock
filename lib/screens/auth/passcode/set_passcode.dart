import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:store_and_lock/helper/helper_funs.dart';
import 'package:store_and_lock/screens/home_screen.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class SetPasscode extends StatefulWidget {
  const SetPasscode({super.key});

  @override
  State<SetPasscode> createState() => _SetPasscodeState();
}

class _SetPasscodeState extends State<SetPasscode> {
  String passcode = '';

  setPasscode() {
    final inputController = InputController();
    screenLock(
      digits: 6,
      context: context,
      correctString: passcode,
      confirmation: true,
      inputController: inputController,
      didConfirmed: (matchedText) {
        setState(() {
          passcode = matchedText;
        });
        HelperFunctions.savePasscodeStatus(true);
        HelperFunctions.savedPasscode(passcode);
        debugPrint(passcode);
        removeAndReplace(context, const HomeScreen());
      },
      footer: TextButton(
        onPressed: () {
          inputController.unsetConfirmed();
        },
        child: const Text('Reset the password'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                'Welcome !',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ClipRRect(
                child: Image.asset(
                  'images/pin.png',
                  height: size.height * 0.3,
                  width: size.width,
                ),
              ),
              const Spacer(),
              const Text(
                'Please set passcode to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  setPasscode();
                },
                child: const Text(
                  'Set passcode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
