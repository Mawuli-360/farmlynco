// To parse this JSON data, do
//

import 'dart:convert';
// final responseModel = responseModelFromJson(jsonString);

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  final String response;

  ResponseModel({
    required this.response,
  });

  ResponseModel copyWith({
    String? response,
  }) =>
      ResponseModel(
        response: response ?? this.response,
      );

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
      };
}
