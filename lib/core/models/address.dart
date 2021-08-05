import 'package:enna/core/models/user.dart';

class AddressModel {
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

  AddressModel(
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

  AddressModel.fromJson(Map<String, dynamic> json) {
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
