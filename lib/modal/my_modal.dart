class UserData {
  String? title;
  String? subtitle;
  String? uid;

  UserData({ this.title,  this.subtitle, this.uid});

  UserData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['uid'] = this.uid;
    return data;
  }
}
