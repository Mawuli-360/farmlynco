import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  // final String category;
  final String description;
  final String name;
  final String price;
  final String productId;
  final String productImage;
  final String productOwner;
  final String profilePic;

  final String userId;
  final String userPhoneNumber;
  bool isBookmarked;

  ProductModel(
      {
        // required this.category,
      required this.description,
      required this.name,
      required this.price,
      required this.productId,
      required this.productImage,
      required this.productOwner,
      required this.profilePic,
      required this.userId,
      required this.userPhoneNumber,
      this.isBookmarked = false});

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data);
  }

  ProductModel copyWith(
      {String? category,
      String? description,
      String? name,
      String? price,
      String? productId,
      String? productImage,
      String? productOwner,
      String? profilePic,
      String? userId,
      String? userPhoneNumber,
      required bool isBookmarked}) {
    return ProductModel(
      // category: category ?? this.description,
      description: description ?? this.description,
      name: name ?? this.name,
      price: price ?? this.price,
      productId: productId ?? this.productId,
      productImage: productImage ?? this.productImage,
      productOwner: productOwner ?? this.productOwner,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'name': name,
      'price': price,
      'productId': productId,
      'productImage': productImage,
      'productOwner': productOwner,
      'profilePic': profilePic,
      'userId': userId,
      'userPhoneNumber': userPhoneNumber,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      description: map['description'] as String,
      name: map['name'] as String,
      price: map['price'] as String,
      productId: map['productId'] as String,
      productImage: map['productImage'] as String,
      productOwner: map['productOwner'] as String,
      profilePic: map['profilePic'] as String,
      userId: map['userId'] as String,
      userPhoneNumber: map['userPhoneNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(description: $description, name: $name, price: $price, productId: $productId, productImage: $productImage, productOwner: $productOwner, profilePic: $profilePic, userId: $userId, userPhoneNumber: $userPhoneNumber)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        other.name == name &&
        other.price == price &&
        other.productId == productId &&
        other.productImage == productImage &&
        other.productOwner == productOwner &&
        other.profilePic == profilePic &&
        other.userId == userId &&
        other.userPhoneNumber == userPhoneNumber;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        name.hashCode ^
        price.hashCode ^
        productId.hashCode ^
        productImage.hashCode ^
        productOwner.hashCode ^
        profilePic.hashCode ^
        userId.hashCode ^
        userPhoneNumber.hashCode;
  }
}
