import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseScreen extends StatefulWidget {
  const FirebaseScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseScreen> createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker image = ImagePicker();
  XFile? photo;
  String imageUrl = '';

  setImage() async {
    try {
      Reference ref = storage.ref();
      Reference refImage = ref.child('images / ${photo!.name}');

      File image = File(photo!.path);

      await refImage.putFile(image);

      setState(() async {
        imageUrl = await refImage.getDownloadURL();
        debugPrint("File url => $imageUrl");
      });
    } on FirebaseException catch (uri) {
      debugPrint(toString());

      debugPrint(uri.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (photo != null)
              Image.file(
                File(photo!.path),
                height: 300,
                width: 320,
              ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      photo =
                          await image.pickImage(source: ImageSource.gallery);
                      setImage();
                    },
                    child: const Text('Pic Image'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setImage();
                      setState(() {});
                    },
                    child: const Text('Set Storage'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Image.network(height: 300, width: 250, imageUrl),
          ],
        ),
      ),
    );
  }
}
