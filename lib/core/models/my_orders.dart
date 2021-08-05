import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/models/user.dart';

class MyOrders {
  String id;
  String createdAt;
  String updatedAt;
  String paymentMethod;
  String status;
  int totalItems;
  int totalPrice;
  Address address;
  List<Lines> lines;

  MyOrders(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.paymentMethod,
      this.status,
      this.totalItems,
      this.totalPrice,
      this.address,
      this.lines});

  MyOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    paymentMethod = json['paymentMethod'];
    status = json['status'];
    totalItems = json['totalItems'];
    totalPrice = json['totalPrice'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['lines'] != null) {
      lines = new List<Lines>();
      json['lines'].forEach((v) {
        lines.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['paymentMethod'] = this.paymentMethod;
    data['status'] = this.status;
    data['totalItems'] = this.totalItems;
    data['totalPrice'] = this.totalPrice;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.lines != null) {
      data['lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String id;
  String createdAt;
  String updatedAt;
  String fullName;
  String landMark;
  String buildingNumber;
  String zoneNumber;
  String streetNumber;
  String phoneNumber;
  UserInfo user;

  Address(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.landMark,
      this.buildingNumber,
      this.zoneNumber,
      this.streetNumber,
      this.phoneNumber,
      this.user});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fullName = json['fullName'];
    landMark = json['landMark'];
    buildingNumber = json['buildingNumber'];
    zoneNumber = json['zoneNumber'];
    streetNumber = json['streetNumber'];
    phoneNumber = json['phoneNumber'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['fullName'] = this.fullName;
    data['landMark'] = this.landMark;
    data['buildingNumber'] = this.buildingNumber;
    data['zoneNumber'] = this.zoneNumber;
    data['streetNumber'] = this.streetNumber;
    data['phoneNumber'] = this.phoneNumber;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Lines {
  String id;
  String createdAt;
  String updatedAt;
  int qty;
  int price;
  Products product;

  Lines(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.qty,
      this.price,
      this.product});

  Lines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    qty = json['qty'];
    price = json['price'];
    product =
        json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['qty'] = this.qty;
    data['price'] = this.price;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}
