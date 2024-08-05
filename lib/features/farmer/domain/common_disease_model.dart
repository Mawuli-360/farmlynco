import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommonDiseaseModel {
  final String content;
  final String id;
  final String image;
  CommonDiseaseModel({
    required this.content,
    required this.id,
    required this.image,
  });

  CommonDiseaseModel copyWith({
    String? content,
    String? id,
    String? image,
    String? title,
  }) {
    return CommonDiseaseModel(
      content: content ?? this.content,
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'id': id,
      'image': image,
    };
  }

  factory CommonDiseaseModel.fromMap(Map<String, dynamic> map) {
    return CommonDiseaseModel(
      content: map['content'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
    );
  }

  factory CommonDiseaseModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    return CommonDiseaseModel(
      content: map['content'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommonDiseaseModel.fromJson(String source) =>
      CommonDiseaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommonDiseaseModel(content: $content, id: $id, image: $image)';
  }
}
