import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muna_global/dialog_box/dialog_box_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _imageFile;
  bool isUploading = false;
  User? currentUser;
  String postId = const Uuid().v4();

  // handleTakePhoto() async {
  //   Navigator.pop(context);
  //   final picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //       source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
  //   setState(() {
  //     _imageFile = File(image!.path);
  //   });
  // }

  handleChooseFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  // selectImage(parentContext) {
  //   return showDialog(
  //     context: parentContext,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: const Text('Create Post'),
  //         children: [
  //           SimpleDialogOption(
  //             onPressed: handleTakePhoto,
  //             child: const Text('Photo with Camera'),
  //           ),
  //           SimpleDialogOption(
  //             onPressed: handleChooseFromGallery,
  //             child: const Text('Photo with Gallery'),
  //           ),
  //           SimpleDialogOption(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // clearImage() {
  //   setState(() {
  //     _imageFile == null;
  //   });
  // }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? file = Im.decodeImage(_imageFile!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(file!, quality: 85),
      );
    setState(() {
      _imageFile = compressedImageFile;
    });
  }

  Future<String> uploadImage(file) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child("post_$postId.jpg").putFile(file);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  void createPostInFirestore(
      {required String mediaUrl,
      required String location,
      required String description}) {
    // only post if there is something in the textfield
    if (descriptionController.text.isNotEmpty ||
        locationController.text.isNotEmpty) {
      // store in firebase
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('User Posts')
          .doc(user!.email)
          .collection('Posts')
          .add({
        "postId": postId,
        "UserEmail": user.email,
        "Description": descriptionController.text,
        "Location": locationController.text,
        "mediaUrl": mediaUrl,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }
    // clear the textfield
    setState(() {
      descriptionController.clear();
    });
  }

  handleSubmit() async {
    if (descriptionController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        _imageFile != null) {
      setState(() {
        isUploading = true;
      });
      await compressImage();
      String mediaUrl = await uploadImage(_imageFile);
      createPostInFirestore(
        mediaUrl: mediaUrl,
        location: locationController.text,
        description: descriptionController.text,
      );
      descriptionController.clear();
      locationController.clear();
      setState(() {
        _imageFile = null;
        isUploading = false;
        postId = const Uuid().v4();
      });
    } else {
      displayMessage('Add Image, Description and Location');
    }
  }

  // display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Create Product',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isUploading ? linearProgress() : const Text(''),
                ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage:
                  //       CachedNetworkImageProvider(widget.currentUser!.photoUrl),
                  // ),
                  title: Container(
                    width: 250.0,
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Description...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                _imageFile != null
                    ? Container(
                        height: 220.0,
                        width: double.infinity,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(_imageFile!)

                                    //AssetImage('assets/images/Hood.png'),
                                    // (_imageFile != null)
                                    //     ? FileImage(_imageFile!) as ImageProvider
                                    //     : const AssetImage(
                                    //         'assets/images/no_content.jpg'),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const Divider(),
                GestureDetector(
                  onTap: handleChooseFromGallery,
                  child: const ListTile(
                    leading: Icon(Icons.image, color: Colors.blue, size: 35.0),
                    title: Text('Add Image'),
                  ),
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.pin_drop,
                        color: Colors.blue, size: 35.0),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          hintText: "Location...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                MyButton(
                  onTap: handleSubmit,
                  text: 'Upload',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
