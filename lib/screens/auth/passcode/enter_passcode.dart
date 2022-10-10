import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:store_and_lock/helper/helper_funs.dart';
import 'package:store_and_lock/screens/home_screen.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class EnterPasscode extends StatefulWidget {
  const EnterPasscode({super.key});

  @override
  State<EnterPasscode> createState() => _EnterPasscodeState();
}

class _EnterPasscodeState extends State<EnterPasscode> {
  @override
  void initState() {
    getPasscode();
    super.initState();
  }

  dynamic passcode;
  Future getPasscode() async {
    await HelperFunctions.getSavedPasscode().then((value) {
      setState(() {
        passcode = value!;
      });
    });
    print(passcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: passcode == null
          ? const CircularProgressIndicator()
          : ScreenLock(
              correctString: passcode,
              digits: passcode.length,
              maxRetries: 3,
              retryDelay: const Duration(seconds: 3),
              delayBuilder: (context, delay) =>
                  Text('Cannot be entered for ${(delay.inSeconds)} seconds'),
              keyPadConfig: const KeyPadConfig(
                clearOnLongPressed: true,
              ),
              didCancelled: () {
                print(passcode.length);
              },
              didUnlocked: () {
                removeAndReplace(context, const HomeScreen());
              }),
    );
  }
}
