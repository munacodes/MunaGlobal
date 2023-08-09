import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String senderEmail;
  final String message;
  final String photoUrl;
  final Timestamp timestamp;

  Message({
    required this.photoUrl,
    required this.senderId,
    required this.receiverId,
    required this.senderEmail,
    required this.message,
    required this.timestamp,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      "photoUrl": photoUrl,
      "senderId": senderId,
      "senderEmail": senderEmail,
      "receiverId": receiverId,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
