class AllCash {
  List<Items> items;
  Meta meta;
  Links links;

  AllCash({this.items, this.meta, this.links});

  AllCash.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class Items {
  String id;
  String createdAt;
  String updatedAt;
  dynamic amount;
  String receivedDate;
  RecevedFrom recevedFrom;

  Items(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.amount,
      this.receivedDate,
      this.recevedFrom});

  Items.fromJson(Map<String, dynamic> json) {
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
  String defaultLang;
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
      this.defaultLang,
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

class Meta {
  int totalItems;
  int itemCount;
  int itemsPerPage;
  int totalPages;
  dynamic currentPage;

  Meta(
      {this.totalItems,
      this.itemCount,
      this.itemsPerPage,
      this.totalPages,
      this.currentPage});

  Meta.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    itemCount = json['itemCount'];
    itemsPerPage = json['itemsPerPage'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItems'] = this.totalItems;
    data['itemCount'] = this.itemCount;
    data['itemsPerPage'] = this.itemsPerPage;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class Links {
  String first;
  String previous;
  String next;
  String last;

  Links({this.first, this.previous, this.next, this.last});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    previous = json['previous'];
    next = json['next'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['previous'] = this.previous;
    data['next'] = this.next;
    data['last'] = this.last;
    return data;
  }
}
