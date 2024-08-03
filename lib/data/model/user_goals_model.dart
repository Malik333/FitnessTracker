class UserGoalsModel {
  int? minutes;
  int? quantity;

  UserGoalsModel({this.minutes, this.quantity});

  UserGoalsModel.fromJson(Map<String, dynamic> json) {
    minutes = json['minutes'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minutes'] = minutes;
    data['quantity'] = quantity;
    return data;
  }
}