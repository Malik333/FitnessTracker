class ActivityModel {
  String? title;
  String? description;
  String? createdAt;
  String? type;
  String? duration;

  ActivityModel(
      {this.title, this.description, this.createdAt, this.type, this.duration});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    type = json['type'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    data['duration'] = this.duration;
    return data;
  }
}