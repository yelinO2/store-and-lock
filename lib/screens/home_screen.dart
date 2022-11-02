// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store_and_lock/screens/audio/upload_audio.dart';
import 'package:store_and_lock/screens/auth/login_screen.dart';
import 'package:store_and_lock/screens/doc/upload_doc.dart';
import 'package:store_and_lock/screens/image/upload_image.dart';
import 'package:store_and_lock/screens/video/upload_vd.dart';
import 'package:store_and_lock/services/auth_service.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Select Category'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => nextScreen(context, const UploadImage()),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.3,
                      width: size.width * 0.4,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Image.asset('images/photo.png'),
                    ),
                    const Text(
                      'Images',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => nextScreen(context, const UploadVideos()),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.3,
                      width: size.width * 0.4,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Image.asset('images/vd.png'),
                    ),
                    const Text(
                      'Videos',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => nextScreen(context, const UploadAudio()),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.3,
                      width: size.width * 0.4,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Image.asset('images/mp3.png'),
                    ),
                    const Text(
                      'Audios',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => nextScreen(context, const UploadDoc()),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.3,
                      width: size.width * 0.4,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Image.asset('images/doc.png'),
                    ),
                    const Text(
                      'Documents',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                width: size.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await AuthService().signOut();
                                removeAndReplace(context, const Login());
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
