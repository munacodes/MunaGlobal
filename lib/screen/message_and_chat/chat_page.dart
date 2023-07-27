import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/chat/chat_service.dart';
import 'package:muna_global/screen/message_and_chat/message_export.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserID;
  //final String userName;
  const ChatPage({
    super.key,
    // required this.userName,
    required this.receiverUserName,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    // only send message if there is something to send
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserName, messageController.text);

      // clear the text controller after sending the message
      messageController.clear();
    }
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
          widget.receiverUserName, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 10),
            ChatTile(message: data['message']),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: messageController,
              hintText: 'Type a message',
              obscureText: false,
            ),
          ),
          GestureDetector(
            onTap: sendMessage,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MessagesPage(),
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
        title: Text(
          widget.receiverUserName,
          style: const TextStyle(color: Colors.blue, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            buildMessageInput(),
          ],
        ),
      ),
    );
  }
}
