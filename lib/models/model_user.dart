
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? id;
  final String fullName;
  final String address;
  final String phoneNumber;
  String? imageUrl;

  MyUser({
    this.id,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    this.imageUrl
  });

  factory MyUser.fromDocument(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      id: doc.id,
      fullName: data['fullname'],
      address: data['address'],
      phoneNumber: data['phoneNumber'],
      imageUrl: data['imageUrl']


    );
  }
  Map<String, dynamic> toDocument(){
    return{
      'fullName' : fullName,
      'address' :   address,
      'phoneNumber' : phoneNumber,
      'imageUrl' : imageUrl,
    
    };
  }
}