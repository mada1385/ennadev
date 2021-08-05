import 'category.dart';

class ContactsCateoryModel {
  String id;
  String createdAt;
  String updatedAt;
  String icon;
  Name name;
  List<Contacts> contacts;

  ContactsCateoryModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.icon,
      this.name,
      this.contacts});

  ContactsCateoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    icon = json['icon'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    if (json['contacts'] != null) {
      contacts = new List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(new Contacts.fromJson(v));
      });
    }
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
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contacts {
  String id;
  String createdAt;
  String updatedAt;
  String companyName;
  String contactName;
  String landLine;
  String mobile;
  String email;
  String website;

  Contacts(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.companyName,
      this.contactName,
      this.landLine,
      this.mobile,
      this.email,
      this.website});

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    companyName = json['companyName'];
    contactName = json['contactName'];
    landLine = json['landLine'];
    mobile = json['mobile'];
    email = json['email'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['companyName'] = this.companyName;
    data['contactName'] = this.contactName;
    data['landLine'] = this.landLine;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['website'] = this.website;
    return data;
  }
}
