import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muna_global/dialog_box/dialog_box_exports.dart';
import 'package:muna_global/screen/category/category_exports.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

class UploadPage extends StatefulWidget {
  final String userId;
  const UploadPage({super.key, required this.userId});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  File? _imageFile;
  bool isUploading = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String productId = const Uuid().v4();
  String? _selectedCategory;
  List<String> availableCategories = [];
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchAvailableCategories();
  // }

  // void fetchAvailableCategories() async {
  //   final QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection('Categories').get();
  //   setState(() {
  //     availableCategories =
  //         querySnapshot.docs.map<String>((DocumentSnapshot document) {
  //       return document.data['name'] as String;
  //     }).toList();
  //   });
  // }

  Future<String> getUsernameFromFirestore(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        return userSnapshot['UserName'];
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print('Error retrieving username: $e');
      return 'Unknown User';
    }
  }

  handleChooseFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? file = Im.decodeImage(_imageFile!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$productId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(file!, quality: 85),
      );
    setState(() {
      _imageFile = compressedImageFile;
    });
  }

  Future<String> uploadImage(file) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("users_posts/${currentUser!.email}_img_$productId.jpg")
        .putFile(file);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  void createPostInFirestore({
    required String imageUrl,
    required String title,
    required String location,
    required String description,
    required double price,
    required String userId,
  }) async {
    // only post if there is something in the textfield
    if (descriptionController.text.isNotEmpty ||
        locationController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        titleController.text.isNotEmpty ||
        quantityController.text.isNotEmpty) {
      // store in firebase

      String userName = await getUsernameFromFirestore(userId);

      FirebaseFirestore.instance.collection('Products').add({
        // 'Category': _selectedCategory,
        "ProductId": productId,
        "PhotoUrl": currentUser!.photoURL,
        "Name of Product": titleController.text,
        "UserEmail": currentUser!.email,
        "UserName": userName,
        "Description": descriptionController.text,
        "Location": locationController.text,
        "Price": double.parse(priceController.text),
        "Quantity": quantityController.text,
        "Size": sizeController.text,
        "ImageUrl": imageUrl,
        "Timestamp": Timestamp.now(),
        "Likes": [],
        "Rating": double.parse('0.0'),
      });
    }

    // clear the textfield
    setState(() {
      descriptionController.clear();
      priceController.clear();
      locationController.clear();
      titleController.clear();
      sizeController.clear();
      quantityController.clear();
    });
  }

  handleSubmit() async {
    if (descriptionController.text.isNotEmpty &&
            titleController.text.isNotEmpty &&
            priceController.text.isNotEmpty &&
            locationController.text.isNotEmpty &&
            _imageFile != null
        // &&
        // _selectedCategory != null
        ) {
      setState(() {
        isUploading = true;
      });
      await compressImage();
      String imageUrl = await uploadImage(_imageFile);
      createPostInFirestore(
        imageUrl: imageUrl,
        title: titleController.text,
        location: locationController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        userId: userId,
      );
      descriptionController.clear();
      locationController.clear();
      priceController.clear();
      titleController.clear();
      sizeController.clear();
      quantityController.clear();
      setState(() {
        _imageFile = null;
        //  _selectedCategory = null;
        isUploading = false;
        productId = const Uuid().v4();
      });
    } else {
      displayMessage('Please Fill Details');
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  clearAllFormField() {
    if (descriptionController.text.isNotEmpty ||
        titleController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        locationController.text.isNotEmpty ||
        _imageFile != null) {}
    descriptionController.clear();
    locationController.clear();
    priceController.clear();
    titleController.clear();
    sizeController.clear();
    quantityController.clear();
    _imageFile == null;
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
        actions: [
          TextButton(
            onPressed: () => clearAllFormField(),
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isUploading ? linearProgress() : const Text(''),
                _imageFile != null
                    ? Container(
                        height: 220.0,
                        width: double.infinity,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(_imageFile!),
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
                  child: const Card(
                    child: ListTile(
                      leading:
                          Icon(Icons.image, color: Colors.blue, size: 35.0),
                      title: Text('Add Image'),
                    ),
                  ),
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.border_color,
                        color: Colors.blue, size: 35.0),
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
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.description_rounded,
                        color: Colors.blue, size: 35.0),
                    title: Container(
                      width: 250.0,
                      child: TextFormField(
                        maxLines: 2,
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Description...",
                          border: InputBorder.none,
                        ),
                      ),
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
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.nature,
                        color: Colors.blue, size: 35.0),
                    title: Container(
                      width: 250.0,
                      child: TextFormField(
                        controller: sizeController,
                        decoration: const InputDecoration(
                          hintText: "Size",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.quora_outlined,
                        color: Colors.blue, size: 35.0),
                    title: Container(
                      width: 250.0,
                      child: TextFormField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          hintText: "Quantity",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                // GestureDetector(
                //   onTap: () {
                //     showDialogBox();
                //   },
                //   child: Card(
                //     child: ListTile(
                //       leading: const Icon(Icons.category,
                //           color: Colors.blue, size: 35.0),
                //       title: DropdownButtonFormField<String>(
                //         value: _selectedCategory,
                //         hint: const Text('Select a category'),
                //         items: availableCategories.map((category) {
                //           return DropdownMenuItem<String>(
                //             value: category,
                //             child: Text(category),
                //           );
                //         }).toList(),
                //         onChanged: (newValue) {
                //           setState(() {
                //             _selectedCategory = newValue;
                //           });
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                const Divider(),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.pin_drop,
                        color: Colors.blue, size: 35.0),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        maxLines: 2,
                        controller: locationController,
                        decoration: const InputDecoration(
                          hintText: "Location",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                MyButton(
                  onTap: handleSubmit,
                  text: 'Sell',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
