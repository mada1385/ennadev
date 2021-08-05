class LastCashTransaction {
  String id;
  String createdAt;
  String updatedAt;
  dynamic amount;
  String receivedDate;
  RecevedFrom recevedFrom;

  LastCashTransaction(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.amount,
      this.receivedDate,
      this.recevedFrom});

  LastCashTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    amount = json['amount'];
    receivedDate = json['receivedDate'];
    recevedFrom = json['recevedFrom'] != null
        ? new RecevedFrom.fromJson(json['recevedFrom'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['amount'] = this.amount;
    data['receivedDate'] = this.receivedDate;
    if (this.recevedFrom != null) {
      data['recevedFrom'] = this.recevedFrom.toJson();
    }
    return data;
  }
}

class RecevedFrom {
  String id;
  String createdAt;
  String updatedAt;
  String name;
  String email;
  String password;
  String mobile;
  String image;
  String userType;
  bool isActive;
  String fcmToken;
  String tempCode;

  RecevedFrom(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.email,
      this.password,
      this.mobile,
      this.image,
      this.userType,
      this.isActive,
      this.fcmToken,
      this.tempCode});

  RecevedFrom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    image = json['image'];
    userType = json['userType'];
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
    data['isActive'] = this.isActive;
    data['fcmToken'] = this.fcmToken;
    data['tempCode'] = this.tempCode;
    return data;
  }
}
