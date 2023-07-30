import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String userName;
  final String time;
  final String message;
  final bool isOnline;

  const MessageTile({
    super.key,
    required this.userName,
    required this.time,
    required this.message,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
      ),
      title: Text(userName),
      subtitle: Text(message),
      trailing: Column(
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.grey[500]),
          ),
          isOnline ? Container(color: Colors.green) : Container(),
        ],
      ),
    );
  }
}
