import 'category.dart';

class User {
  String token;
  UserInfo user;

  User({this.token, this.user});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserInfo {
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
  List<Teams> teams;
  List<Teams> invitedTeams;

  UserInfo(
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
      this.tempCode,
      this.teams,
      this.invitedTeams});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    if (json['invitedTeams'] != null) {
      invitedTeams = new List<Teams>();
      json['invitedTeams'].forEach((v) {
        invitedTeams.add(new Teams.fromJson(v));
      });
    }
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
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    if (this.invitedTeams != null) {
      data['invitedTeams'] = this.invitedTeams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teams {
  String id;
  String createdAt;
  String updatedAt;
  Name name;
  List<String> emailsOrPhones;
  List<Members> members;
  Members creator;
  Season season;

  Teams(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.emailsOrPhones,
      this.members,
      this.creator,
      this.season});

  Teams.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    emailsOrPhones = json['emailsOrPhones'].cast<String>();
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    creator =
        json['creator'] != null ? new Members.fromJson(json['creator']) : null;
    season =
        json['season'] != null ? new Season.fromJson(json['season']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['emailsOrPhones'] = this.emailsOrPhones;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.season != null) {
      data['season'] = this.season.toJson();
    }

    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }

    return data;
  }
}

class Members {
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
  String defaultLang;
  String fcmToken;
  String tempCode;
  String vendor;

  Members(
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
      this.vendor,
      this.defaultLang,
      this.tempCode});

  Members.fromJson(Map<String, dynamic> json) {
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
    vendor = json['vendor'];
    defaultLang = json['defaultLang'];
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
    data['defaultLang'] = this.defaultLang;
    data['vendor'] = this.vendor;
    return data;
  }
}

class Season {
  String id;
  String createdAt;
  String updatedAt;
  String startDate;
  String endDate;
  String lat;
  String lng;

  Season(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.startDate,
      this.endDate,
      this.lat,
      this.lng});

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
