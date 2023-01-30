// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

StoreModel storeModelFromJson(String str) => StoreModel.fromJson(json.decode(str));

String storeModelToJson(StoreModel data) => json.encode(data.toJson());

class StoreModel {
  StoreModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.isActive,
    required this.image,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String type;
  String description;
  String isActive;
  String image;
  String url;
  String createdAt;
  String updatedAt;

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json["id"],
    title: json["title"],
    type: json["type"],
    description: json["description"],
    isActive: json["is_active"],
    image: json["image"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
    "description": description,
    "is_active": isActive,
    "image": image,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
