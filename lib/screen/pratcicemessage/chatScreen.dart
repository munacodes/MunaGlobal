import 'package:flutter/material.dart';
import 'package:muna_global/screen/pratcicemessage/mesageModel.dart';
import 'package:muna_global/screen/pratcicemessage/messageService.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MessageService _messageService = MessageService();

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageService.streamMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index].sender),
                      subtitle: Text(messages[index].text),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
