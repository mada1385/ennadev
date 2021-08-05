import 'package:enna/core/models/category.dart';

import 'all_expenses_model.dart';

class LastExpensesTransaction {
  String id;
  String createdAt;
  String updatedAt;
  dynamic amount;
  String reciept;
  String note;
  SpentFor spentFor;
  RecevedFrom recevedFrom;

  LastExpensesTransaction(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.amount,
      this.reciept,
      this.note,
      this.spentFor,
      this.recevedFrom});

  LastExpensesTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    amount = json['amount'];
    reciept = json['reciept'];
    note = json['note'];
    spentFor = json['spentFor'] != null
        ? new SpentFor.fromJson(json['spentFor'])
        : null;
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
    data['reciept'] = this.reciept;
    data['note'] = this.note;
    if (this.spentFor != null) {
      data['spentFor'] = this.spentFor.toJson();
    }
    if (this.recevedFrom != null) {
      data['recevedFrom'] = this.recevedFrom.toJson();
    }
    return data;
  }
}

class SpentFor {
  String id;
  String createdAt;
  String updatedAt;
  Name name;

  SpentFor({this.id, this.createdAt, this.updatedAt, this.name});

  SpentFor.fromJson(Map<String, dynamic> json) {
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
