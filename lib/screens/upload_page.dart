import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  handleTakePhoto() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create Post'),
          children: [
            SimpleDialogOption(
              onPressed: handleTakePhoto,
              child: const Text('Photo with Camera'),
            ),
            SimpleDialogOption(
              onPressed: handleChooseFromGallery,
              child: const Text('Photo with Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  clearImage() {
    setState(() {
      _imageFile == null;
    });
  }

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
      FirebaseFirestore.instance.collection('User Posts').add({
        "postId": postId,
        "UserEmail": currentUser!.email,
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
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_imageFile);
    // postMessage();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            isUploading ? linearProgress() : const Text(''),
            GestureDetector(
              onTap: selectImage(context),
              child: Container(
                height: 220.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_imageFile!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              // leading: CircleAvatar(
              //   backgroundImage:
              //       CachedNetworkImageProvider(widget.currentUser!.photoUrl),
              // ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Description...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(Icons.pin_drop, color: Colors.blue, size: 35.0),
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
          ],
        ),
      ),
    );
  }
}
