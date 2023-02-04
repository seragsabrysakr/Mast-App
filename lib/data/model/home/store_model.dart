// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString?);

import 'dart:convert';

StoreModel storeModelFromJson(String? str) => StoreModel.fromJson(json.decode(str!));

class StoreModel {
  StoreModel({
    this.id,
    this.title,
    this.type,
    this.description,
    this.isActive,
    this.image,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.special,
    this.ratingCount,
    this.avgRating,
    this.userRating,
    this.ratings,
  });

  int? id;
  String? title;
  String? type;
  String? description;
  String? isActive;
  String? image;
  String? url;
  String? createdAt;
  String? updatedAt;
  bool? special;
  String? ratingCount;
  double? avgRating;
  bool? userRating;
  List<Rating>? ratings;

  factory StoreModel.fromJson(Map<String?, dynamic> json) => StoreModel(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        description: json["description"],
        isActive: json["is_active"],
        image: json["image"],
        url: json["url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        special: json["special"],
        ratingCount: json["rating_count"],
        avgRating: json["avgRating"] is int? ? json["avgRating"].toDouble() : json["avgRating"],
        userRating: json["user_rating"],
        ratings: List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
      );
}

class Rating {
  Rating({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String? userId;
  String? shopId;
  String? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Rating.fromJson(Map<String?, dynamic> json) => Rating(
        id: json["id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
