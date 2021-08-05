class NotificationModel {
  String id;
  String createdAt;
  String updatedAt;
  String title;
  String description;
  Sender sender;

  NotificationModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.description,
      this.sender});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    title = json['title'];
    description = json['description'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    return data;
  }
}

class Sender {
  String id;
  String createdAt;
  String updatedAt;
  String name;
  String email;
  String password;
  String mobile;
  String image;
  String userType;
  String defaultLang;
  bool isActive;
  String fcmToken;
  String tempCode;

  Sender(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.email,
      this.password,
      this.mobile,
      this.image,
      this.userType,
      this.defaultLang,
      this.isActive,
      this.fcmToken,
      this.tempCode});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    image = json['image'];
    userType = json['userType'];
    defaultLang = json['defaultLang'];
    isActive = json['isActive'];
    fcmToken = json['fcmToken'];
    tempCode = json['tempCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['userType'] = this.userType;
    data['defaultLang'] = this.defaultLang;
    data['isActive'] = this.isActive;
    data['fcmToken'] = this.fcmToken;
    data['tempCode'] = this.tempCode;
    return data;
  }
}
