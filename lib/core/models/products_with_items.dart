// this model that hold category with at most 2 items
import 'package:enna/core/models/product_items.dart';

import 'category.dart';

class ProductsWithItems {
  String id;
  String createdAt;
  String updatedAt;
  Name name;
  List<Products> products;

  ProductsWithItems(
      {this.id, this.createdAt, this.updatedAt, this.name, this.products});

  ProductsWithItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
