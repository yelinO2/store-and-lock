import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const uploadSpinkit = SpinKitPouringHourGlassRefined(
  color: Colors.amberAccent,
  size: 60,
);

const loadingSpinkit = SpinKitFadingCircle(
  color: Colors.amberAccent,
);

const uploadingText = Text(
  'Uploading.....',
  style: TextStyle(color: Colors.white, fontSize: 16),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void removeAndReplace(context, page) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

// for login signup field
const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 2),
  ),
);

// for message input field
var chatTextInputDecoration = InputDecoration(
  labelStyle: const TextStyle(
    color: Colors.white,
    fontSize: 16,
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(50)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(50)),
  filled: true,
  fillColor: Colors.grey,
);

Color getColor(String word) {
  Color color;
  if (word == 'a') {
    color = Colors.red;
  } else if (word == 'b') {
    color = Colors.yellow;
  } else if (word == 'c') {
    color = Colors.green;
  } else if (word == 'd') {
    color = Colors.blue;
  } else if (word == 'e') {
    color = Colors.purple;
  } else if (word == 'f') {
    color = Colors.pink;
  } else if (word == 'g') {
    color = Colors.amber;
  } else if (word == 'h') {
    color = Colors.orange;
  } else if (word == 'i') {
    color = Colors.cyanAccent;
  } else if (word == 'j') {
    color = Colors.teal;
  } else if (word == 'k') {
    color = Colors.limeAccent;
  } else if (word == 'l') {
    color = Colors.indigoAccent;
  } else if (word == 'm') {
    color = Colors.blueGrey;
  } else if (word == 'n') {
    color = Colors.lightGreen;
  } else if (word == 'o') {
    color = Colors.lightBlue;
  } else if (word == 'p') {
    color = Colors.purpleAccent;
  } else if (word == 'q') {
    color = Colors.blueGrey;
  } else if (word == 'r') {
    color = Colors.lightBlue;
  } else if (word == 's') {
    color = Colors.deepPurpleAccent;
  } else if (word == 't') {
    color = Colors.limeAccent;
  } else if (word == 'u') {
    color = Colors.orangeAccent;
  } else if (word == 'v') {
    color = Colors.blue;
  } else if (word == 'w') {
    color = Colors.teal;
  } else if (word == 'x') {
    color = Colors.blueAccent;
  } else if (word == 'y') {
    color = Colors.redAccent;
  } else if (word == 'z') {
    color = Colors.pinkAccent;
  } else {
    color = Colors.black;
  }
  return color;
}
