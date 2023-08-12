import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/screen/message_and_chat/message_export.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class Messa extends StatefulWidget {
  const Messa({super.key});

  @override
  State<Messa> createState() => _MessaState();
}

class _MessaState extends State<Messa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) => const MyHomeScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SearchMessages(),
            ),
          );
        },
        child: Card(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.chat,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Start chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Messages')
              .doc(currentUser!.uid)
              .collection('Chat Room')
              .where('receiverId', isEqualTo: currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No Messages Yet',
                  style: TextStyle(fontSize: 30, color: Colors.grey),
                ),
              );
            }

            List<String> senderIds = [];
            for (var doc in snapshot.data!.docs) {
              String senderId = doc['senderId'];
              if (!senderIds.contains(senderId)) {
                senderIds.add(senderId);
              }
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: senderIds.length,
                itemBuilder: (context, index) {
                  var messageSnapshot = senderIds[index];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currentUser!.uid)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return circularProgress();
                      }
                      if (userSnapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${userSnapshot.error}'),
                        );
                      }
                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return const ListTile(
                          title: Text('User not found'),
                        );
                      }
                      var userData = userSnapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: userData['PhotoUrl'] != null
                                ? CachedNetworkImageProvider(
                                    userData['PhotoUrl'].toString())
                                : const AssetImage(
                                        'assets/images/User Image.png')
                                    as ImageProvider,
                          ),
                          title: Text(
                            userData['senderEmail'].toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            userData['message'].toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                },
              );
            }
            return circularProgress();
          },
        ),
      ),
    );
  }

  Stream<QuerySnapshot> qwert(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return FirebaseFirestore.instance
        .collection('Messages')
        .doc(chatRoomId)
        .collection('Chat Room')
        .where('receiverId', isEqualTo: currentUser!.uid)
        .snapshots();
  }
}
