import 'package:enna/core/services/localization/localization.dart';
import 'package:flutter/cupertino.dart';

class Category {
  String id;
  String createdAt;
  String updatedAt;
  Name name;

  Category({this.id, this.createdAt, this.updatedAt, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    return data;
  }
}

class Name {
  String ar;
  String en;

  Name({this.ar, this.en});

  String localized(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return locale.locale.languageCode == "en" ? en : ar ?? en;
  }

  Name.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }

  localied(BuildContext context) {
    switch (AppLocalizations.of(context).locale.languageCode) {
      case 'ar':
        return ar;
      case 'en':
        return en;
      default:
        return en;
    }
  }
}
