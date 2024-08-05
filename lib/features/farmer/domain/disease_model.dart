import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseModel {
  final String content;
  final String id;
  final String image;
  final String title;
  DiseaseModel({
    required this.content,
    required this.id,
    required this.image,
    required this.title,
  });

  DiseaseModel copyWith({
    String? content,
    String? id,
    String? image,
    String? title,
  }) {
    return DiseaseModel(
      content: content ?? this.content,
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'id': id,
      'image': image,
      'title': title,
    };
  }

  factory DiseaseModel.fromMap(Map<String, dynamic> map) {
    return DiseaseModel(
      content: map['content'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
      title: map['title'] as String,
    );
  }

  factory DiseaseModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    return DiseaseModel(
      content: map['content'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiseaseModel.fromJson(String source) =>
      DiseaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiseaseModel(content: $content, id: $id, image: $image, title: $title)';
  }

  @override
  bool operator ==(covariant DiseaseModel other) {
    if (identical(this, other)) return true;

    return other.content == content &&
        other.id == id &&
        other.image == image &&
        other.title == title;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        id.hashCode ^
        image.hashCode ^
        title.hashCode;
  }
}
