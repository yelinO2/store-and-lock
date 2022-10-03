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
      digits: 5,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Set Passcode')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Please set passcode to continue'),
          TextButton(
              onPressed: () {
                setPasscode();
              },
              child: const Text('Set passcode'))
        ],
      ),
    );
  }
}
