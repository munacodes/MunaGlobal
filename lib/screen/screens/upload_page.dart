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
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  File? _imageFile;
  bool isUploading = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String postId = const Uuid().v4();
  String? username;

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

  void createPostInFirestore({
    required String mediaUrl,
    required String title,
    required String location,
    required String description,
    required double price,
  }) {
    // only post if there is something in the textfield
    if (descriptionController.text.isNotEmpty ||
        locationController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        titleController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance
          .collection('User Posts')
          // .doc(user!.email)
          // .collection('Posts')
          .add({
        "postId": postId,
        "Name of Product": titleController.text,
        // "UserName": currentUser!.username,
        "UserEmail": currentUser!.email,
        "Description": descriptionController.text,
        "Location": locationController.text,
        "Price": double.parse(priceController.text),
        "mediaUrl": mediaUrl,
        "Timestamp": Timestamp.now(),
        "Likes": [],
      });
    }
    // clear the textfield
    setState(() {
      descriptionController.clear();
      priceController.clear();
      locationController.clear();
      titleController.clear();
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
        title: titleController.text,
        location: locationController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
      );
      descriptionController.clear();
      locationController.clear();
      priceController.clear();
      titleController.clear();
      setState(() {
        _imageFile = null;
        isUploading = false;
        postId = const Uuid().v4();
      });
    } else {
      displayMessage('Please add Image, Name, Description, Price and Location');
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

  Future<void> showDialogBox() async {
    await showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Category().categoryitem(context),
        ),
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
          style: TextStyle(color: Colors.blue, fontSize: 30),
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
                  title: Container(
                    width: 250.0,
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Name of Product...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
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
                const Divider(),
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
                                    image: FileImage(_imageFile!)),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const Divider(),
                GestureDetector(
                  onTap: handleChooseFromGallery,
                  child: const Card(
                    child: ListTile(
                      leading:
                          Icon(Icons.image, color: Colors.blue, size: 35.0),
                      title: Text('Add Image'),
                    ),
                  ),
                ),

                /// TODO: Use pop up to pop category
                /// TODO: showDialog to display category list
                /// TODO: use navigator.pop to pop back list to upload page
                GestureDetector(
                  onTap: () {
                    showDialogBox();
                  },
                  child: const Card(
                    child: ListTile(
                      leading:
                          Icon(Icons.category, color: Colors.blue, size: 35.0),
                      title: Text('Select Category'),
                    ),
                  ),
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.monetization_on,
                        color: Colors.blue, size: 35.0),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          hintText: "Price",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
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
