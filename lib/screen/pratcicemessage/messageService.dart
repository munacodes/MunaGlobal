import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muna_global/screen/pratcicemessage/mesageModel.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String sender, String text) async {
    await _firestore.collection('messages').add({
      'sender': sender,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Message>> streamMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message(
          id: doc.id,
          sender: doc['sender'],
          text: doc['text'],
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
