import 'package:flutter/material.dart';

import 'package:store_and_lock/helper/helper_funs.dart';
import 'package:store_and_lock/screens/auth/passcode/enter_passcode.dart';
import 'package:store_and_lock/screens/auth/passcode/set_passcode.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  bool setPasscode = false;

  @override
  void initState() {
    getPasscodeStatus();
    super.initState();
  }

  getPasscodeStatus() async {
    HelperFunctions.getSavedPasscodeStatus().then((value) {
      if (value != null) {
        setState(() {
          setPasscode = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return setPasscode ? const EnterPasscode() : const SetPasscode();
  }
}
