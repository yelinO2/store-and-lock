import 'package:flutter/material.dart';
import 'package:store_and_lock/screens/audio/upload_audio.dart';
import 'package:store_and_lock/screens/doc/upload_doc.dart';
import 'package:store_and_lock/screens/image/upload_image.dart';
import 'package:store_and_lock/screens/video/upload_vd.dart';
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
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: size.width,
              height: size.height * 0.3,
              color: Colors.blueGrey,
              child: const Center(
                child: Text(
                  'Select Category',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              children: [
                InkWell(
                  onTap: () => nextScreen(context, const UploadImage()),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Image.asset('images/photo.png'),
                  ),
                ),
                InkWell(
                  onTap: () => nextScreen(context, const UploadVideos()),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Image.asset('images/vd.png'),
                  ),
                ),
                InkWell(
                  onTap: () => nextScreen(context, const UploadAudio()),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Image.asset('images/mp3.png'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    nextScreen(context, const UploadDoc());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Image.asset('images/doc.png'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
