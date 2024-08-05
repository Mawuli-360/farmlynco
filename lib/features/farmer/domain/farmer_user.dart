import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerUser {
  final String email;
  final String fullName;
  final String imageUrl;
  final String phoneNumber;
  final String storeName;
  final String uid;
  FarmerUser({
    required this.email,
    required this.fullName,
    required this.imageUrl,
    required this.phoneNumber,
    required this.storeName,
    required this.uid,
  });

  FarmerUser copyWith({
    String? email,
    String? fullName,
    String? imageUrl,
    String? phoneNumber,
    String? storeName,
    String? uid,
  }) {
    return FarmerUser(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      storeName: storeName ?? this.storeName,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'storeName': storeName,
      'uid': uid,
    };
  }

  factory FarmerUser.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FarmerUser.fromMap(data);
  }

  factory FarmerUser.fromMap(Map<String, dynamic> map) {
    return FarmerUser(
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      imageUrl: map['imageUrl'] as String,
      phoneNumber: map['phoneNumber'] as String,
      storeName: map['storeName'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmerUser.fromJson(String source) =>
      FarmerUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
