// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:muna_global/widgets/widgets_exports.dart';
// import 'package:uuid/uuid.dart';
// import 'package:image/image.dart' as Im;
// import 'package:geolocator/geolocator.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:muna_global/screens/home_page.dart';

// class UploadProducts extends StatefulWidget {
//   final String currentUser;
//   const UploadProducts({
//     super.key,
//     required this.currentUser,
//   });

//   @override
//   State<UploadProducts> createState() => _UploadProductsState();
// }

// class _UploadProductsState extends State<UploadProducts> {
//   TextEditingController locationController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   File? _imageFile;
//   bool isUploading = false;
//   String postId = const Uuid().v4();
//   User? currentUser;

//   handleTakePhoto() async {
//     Navigator.pop(context);
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(
//         source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
//     setState(() {
//       _imageFile = File(image!.path);
//     });
//   }

//   handleChooseFromGallery() async {
//     Navigator.pop(context);
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = File(image!.path);
//     });
//   }

//   selectImage(parentContext) {
//     return showDialog(
//       context: parentContext,
//       builder: (context) {
//         return SimpleDialog(
//           title: const Text('Create Post'),
//           children: [
//             SimpleDialogOption(
//               onPressed: handleTakePhoto,
//               child: const Text('Photo with Camera'),
//             ),
//             SimpleDialogOption(
//               onPressed: handleChooseFromGallery,
//               child: const Text('Photo with Gallery'),
//             ),
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   clearImage() {
//     setState(() {
//       _imageFile == null;
//     });
//   }

//   compressImage() async {
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     Im.Image? file = Im.decodeImage(_imageFile!.readAsBytesSync());
//     final compressedImageFile = File('$path/img_$postId.jpg')
//       ..writeAsBytesSync(
//         Im.encodeJpg(file!, quality: 85),
//       );
//     setState(() {
//       _imageFile = compressedImageFile;
//     });
//   }

//   Future<String> uploadImage(file) async {
//     UploadTask uploadTask =
//         FirebaseStorage.instance.ref().child("post_$postId.jpg").putFile(file);
//     TaskSnapshot storageSnap = await uploadTask;
//     String downloadUrl = await storageSnap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   createPostInFirestore(
//       {required String mediaUrl,
//       required String location,
//       required String description}) {
//     FirebaseFirestore.instance
//         .collection('Posts')
//         .doc(widget.currentUser!.id)
//         .collection('User Posts')
//         .doc(postId)
//         .set({
//       "postId": postId,
//       "ownerId": widget.currentUser!.id,
//       "username": widget.currentUser!.username,
//       "mediaUrl": mediaUrl,
//       "description": description,
//       "location": location,
//       "timestamp": timestamp,
//       "likes": {},
//     });
//   }

//   void postMessage() {
//     // only post if there is something in the textfield
//     if (descriptionController.text.isNotEmpty ||
//         locationController.text.isNotEmpty) {
//       // store in firebase
//       FirebaseFirestore.instance.collection('User Posts').add({
//         "UserEmail": currentUser!.email,
//         "Description": descriptionController.text,
//         "TimeStamp": Timestamp.now(),
//         "Likes": [],
//       });
//     }
//     // clear the textfield
//     setState(() {
//       descriptionController.clear();
//     });
//   }

//   handleSubmit() async {
//     setState(() {
//       isUploading = true;
//     });
//     await compressImage();
//     String mediaUrl = await uploadImage(_imageFile);
//     postMessage();
//     createPostInFirestore(
//       mediaUrl: mediaUrl,
//       location: locationController.text,
//       description: descriptionController.text,
//     );
//     descriptionController.clear();
//     locationController.clear();
//     setState(() {
//       _imageFile = null;
//       isUploading = false;
//       postId = const Uuid().v4();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white70,
//         leading: IconButton(
//           onPressed: clearImage,
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Caption Post',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           TextButton(
//             onPressed: isUploading ? null : () => handleSubmit(),
//             child: const Text(
//               "Post",
//               style: TextStyle(
//                   color: Colors.blueAccent,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.0),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           isUploading ? linearProgress() : const Text(''),
//           Container(
//             height: 220.0,
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: FileImage(_imageFile!),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(top: 10.0),
//           ),
//           ListTile(
//             // leading: CircleAvatar(
//             //   backgroundImage:
//             //       CachedNetworkImageProvider(widget.currentUser!.photoUrl),
//             // ),
//             title: Container(
//               width: 250.0,
//               child: TextField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(
//                   hintText: "Write a caption...",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading:
//                 const Icon(Icons.pin_drop, color: Colors.orange, size: 35.0),
//             title: Container(
//               width: 250.0,
//               child: TextField(
//                 controller: locationController,
//                 decoration: const InputDecoration(
//                   hintText: "Where was this photo taken?",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: 200,
//             height: 100,
//             child: Center(
//               child: ElevatedButton.icon(
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Colors.blue),
//                 ),
//                 label: const Text(
//                   "Use Current Location",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: getUserLocation,
//                 icon: const Icon(Icons.my_location, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   getUserLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
// }
