import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradetrove/models/chat.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _chatCollection = _database.collection('chats');

  static Future<void> sendMessage(ChatMessage chatMessage) async {
    await _chatCollection.add(chatMessage.toMap());
  }

  static Stream<List<ChatMessage>> getMessages(String currentUserId, String otherUserId) {
    final sentMessagesStream = _chatCollection
        .where('senderId', isEqualTo: currentUserId)
        .where('receiverId', isEqualTo: otherUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatMessage.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });

    final receivedMessagesStream = _chatCollection
        .where('senderId', isEqualTo: otherUserId)
        .where('receiverId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatMessage.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });

    return Rx.combineLatest2<List<ChatMessage>, List<ChatMessage>, List<ChatMessage>>(
      sentMessagesStream,
      receivedMessagesStream,
      (sentMessages, receivedMessages) {
        final allMessages = [...sentMessages, ...receivedMessages];
        allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Urutkan berdasarkan timestamp
        return allMessages;
      },
    );
  }

  static Stream<List<String>> getChatUsers(String currentUserId) {
    final sentMessagesStream = _chatCollection
        .where('senderId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return (doc.data() as Map<String, dynamic>)['receiverId'] as String;
          }).toList();
        });

    final receivedMessagesStream = _chatCollection
        .where('receiverId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return (doc.data() as Map<String, dynamic>)['senderId'] as String;
          }).toList();
        });

    return Rx.combineLatest2<List<String>, List<String>, List<String>>(
      sentMessagesStream,
      receivedMessagesStream,
      (sent, received) {
        return [...sent, ...received].toSet().toList(); // Menghilangkan duplikat
      },
    );
  }
}
