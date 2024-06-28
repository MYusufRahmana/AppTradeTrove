import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  final String productId;
  final String userId;
  final String userName;
  final String text;
  final Timestamp createdAt;

  Comment({
    this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> data, String documentId) {
    return Comment(
      id: documentId,
      productId: data['productId'],
      userId: data['userId'],
      userName: data['userName'],
      text: data['text'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
