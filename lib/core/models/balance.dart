class Balance {
  dynamic recieved;
  dynamic expenseBalance;
  dynamic cashBalance;

  Balance({this.recieved, this.expenseBalance, this.cashBalance});

  Balance.fromJson(Map<String, dynamic> json) {
    recieved = json['recieved'];
    expenseBalance = json['expenseBalance'];
    cashBalance = json['cashBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recieved'] = this.recieved;
    data['expenseBalance'] = this.expenseBalance;
    data['cashBalance'] = this.cashBalance;
    return data;
  }
}
