// To parse this JSON data, do
//
//     final notificationServerModel = notificationServerModelFromJson(jsonString);

import 'dart:convert';

NotificationServerModel notificationServerModelFromJson(String str) => NotificationServerModel.fromJson(json.decode(str));

String notificationServerModelToJson(NotificationServerModel data) => json.encode(data.toJson());

class NotificationServerModel {
  NotificationServerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.notificationType,
  });

  int id;
  String title;
  String description;
  String image;
  String notificationType;

  factory NotificationServerModel.fromJson(Map<String, dynamic> json) => NotificationServerModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    notificationType: json["notification_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "notification_type": notificationType,
  };
}
