import 'package:enna/core/models/category.dart';

class Products {
  String id;
  String createdAt;
  String updatedAt;
  dynamic price;
  dynamic qty;
  List<String> images;
  Name name;
  Name description;
  Category category;
  List<Review> reviews;
  dynamic cRating;

  Products(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.qty,
      this.images,
      this.name,
      this.description,
      this.category,
      this.reviews,
      this.cRating});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'];
    qty = json['qty'];
    images = json['images'].cast<String>();
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['reviews'] != null) {
      reviews = new List<Review>();
      json['reviews'].forEach((v) {
        reviews.add(new Review.fromJson(v));
      });
    }
    cRating = json['cRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['images'] = this.images;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    data['cRating'] = this.cRating;
    return data;
  }
}

class Review {
  String id;
  String createdAt;
  String updatedAt;
  dynamic rate;

  Review({this.id, this.createdAt, this.updatedAt, this.rate});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['rate'] = this.rate;
    return data;
  }
}
