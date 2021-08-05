import 'package:enna/core/models/category.dart';

class ContactCategory {
  String id;
  String createdAt;
  String updatedAt;
  String icon;
  Name name;

  ContactCategory(
      {this.id, this.createdAt, this.updatedAt, this.icon, this.name});

  ContactCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    icon = json['icon'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['icon'] = this.icon;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    return data;
  }
}
