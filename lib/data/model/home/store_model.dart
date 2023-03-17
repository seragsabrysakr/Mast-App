import 'client_model.dart';

class StoreModel {
  int? id;
  String? title;
  String? type;
  String? description;
  String? isActive;
  String? image;
  String? url;
  String? coupon;
  String? createdAt;
  String? updatedAt;
  bool? special;
  String? ratingCount;
  double? avgRating;
  bool? userRating;
  ClientModel? client;
  List<Ratings>? ratings;

  StoreModel(
      {this.id,
      this.title,
      this.type,
      this.description,
      this.isActive,
      this.image,
      this.url,
      this.coupon,
      this.createdAt,
      this.updatedAt,
      this.special,
      this.ratingCount,
      this.avgRating,
      this.client,
      this.userRating,
      this.ratings});

  StoreModel.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    isActive = json['is_active'];
    image = json['image'];
    url = json['url'];
    coupon = json['coupon'];
    client =
        json['client'] == null ? null : ClientModel.fromJson(json['client']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    special = json['special'];
    ratingCount = json['rating_count'].toString();
    avgRating = json['avgRating'].toDouble();
    userRating = json['user_rating'];
    if (json['ratings'] != null) {
      ratings = [];
      json['ratings'].forEach((v) {
        ratings!.add(Ratings.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['description'] = description;
    data['is_active'] = isActive;
    data['image'] = image;
    data['url'] = url;
    data['coupon'] = coupon;
    data['client'] = client;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['special'] = special;
    data['rating_count'] = ratingCount;
    data['avgRating'] = avgRating;
    data['user_rating'] = userRating;
    if (ratings != null) {
      data['ratings'] = ratings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ratings {
  int? id;
  String? userId;
  String? shopId;
  String? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;
  Client? client;

  Ratings(
      {this.id,
      this.userId,
      this.shopId,
      this.rating,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.client});

  Ratings.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopId = json['shop_id'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['shop_id'] = shopId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (client != null) {
      data['client'] = client!.toJson();
    }
    return data;
  }
}

class Client {
  int? id;
  String? name;
  String? phone;
  String? isActive;
  String? image;
  String? balance;
  String? email;
  String? verifyCode;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;

  Client(
      {this.id,
      this.name,
      this.phone,
      this.isActive,
      this.image,
      this.balance,
      this.email,
      this.verifyCode,
      this.fcmToken,
      this.createdAt,
      this.updatedAt});

  Client.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    isActive = json['is_active'];
    image = json['image'];
    balance = json['balance'];
    email = json['email'];
    verifyCode = json['verify_code'];
    fcmToken = json['fcm_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['is_active'] = isActive;
    data['image'] = image;
    data['balance'] = balance;
    data['email'] = email;
    data['verify_code'] = verifyCode;
    data['fcm_token'] = fcmToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
