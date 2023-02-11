class ClientModel {
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

  ClientModel(
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

  ClientModel.fromJson(Map<String?, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
