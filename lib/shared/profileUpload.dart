import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/services/Database.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'loading.dart';

class UploadProfile extends StatefulWidget {
  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  File _imageFile;
  bool _loading = false;
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  Future<String> _startUpload(File file) async {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: "gs://dump-d.appspot.com");
    String filePath = 'images${DateTime.now()}.png';
    StorageReference ref = _storage.ref().child(filePath);
    StorageUploadTask uploadTask = ref.putFile(file);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    final url = dowurl.toString();

    return url;
  }

  _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
        child: _loading == false
            ? Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  //leading: Drawer(child: prefix0.IconButton(icon: Icon(Icons.navigation), onPressed: null),),
                  centerTitle: true,
                  title: Text(
                    'Profile Pic',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    height: context.screenHeight * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        'Upload Profilpic'.text.center.black.xl.makeCentered(),
                        30.heightBox,
                        if (_imageFile != null) ...[
                          Image.file(
                            _imageFile,
                            height: 400,
                          ),
                          30.heightBox,
                          buttonRow(),
                          30.heightBox,
                          Container(
                            width: 359,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _loading = true;
                                });
                                String url = await _startUpload(_imageFile);
                                await userCollection
                                    .document(user.uid)
                                    .updateData({
                                  "profilePic": url,
                                });
                                setState(() {
                                  _loading = false;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: "Update Pic"
                                    .text
                                    .bold
                                    .size(24)
                                    .white
                                    .makeCentered()
                                    .box
                                    .black
                                    .size(359, 50)
                                    .rounded
                                    .makeCentered(),
                              ),
                            ),
                          ),
                          20.heightBox,
                        ],
                        if (_imageFile == null) ...[
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 100,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.camera_outlined,
                                            size: 60,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: () =>
                                              _pickImage(ImageSource.camera)),
                                    ),
                                    10.heightBox,
                                    'Camera'.text.xl.make(),
                                  ],
                                ),
                                40.widthBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 100,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.photo_outlined,
                                            size: 60,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: () =>
                                              _pickImage(ImageSource.gallery)),
                                    ),
                                    10.heightBox,
                                    'Gallery'.text.xl.make(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ))
            : Loading());
  }

  Row buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [FlatButton(onPressed: _clear, child: Icon(Icons.clear))],
    );
  }
}
