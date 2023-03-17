import 'dart:io';

import 'package:communityapp/services/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final UserService _userService = UserService();
  File? _profileImage;
  File? _bannerImage;
  final picker = ImagePicker();
  String name = '';

  // Future pickImage() async {
  //     try {
  //       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  // if(image == null) return;
  // final imageTemp = File(image.path);
  // setState(() => this.image = imageTemp);
  //     } on PlatformException catch(e) {
  //       print('Failed to pick image: $e');
  //     }
  //   }

  Future getImage(int type) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null && type == 0) {
        _profileImage = File(pickedFile.path);
      }
      if (pickedFile != null && type == 1) {
        _bannerImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () async {
                await _userService.updateProfile(
                    File(_bannerImage!.path), File(_profileImage!.path), name);
                Navigator.pop(context);
              },
              child: const Text('Save'))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () => getImage(0),
              child: _profileImage == null
                  ? const Icon(Icons.person)
                  : Image.file(
                      File(_profileImage!.path),
                      height: 100,
                    ),
            ),
            ElevatedButton(
              onPressed: () => getImage(1),
              child: _bannerImage == null
                  ? const Icon(Icons.person)
                  : Image.file(
                      File(_bannerImage!.path),
                      height: 100,
                    ),
            ),
            TextFormField(
              onChanged: (val) => setState(() {
                name = val;
              }),
            )
          ],
        )),
      ),
    );
  }
}