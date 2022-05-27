class UserModel {
  double id;
  String fullname;
  String username;
  String email;
  String phone;

  UserModel({
    this.id,
    this.fullname,
    this.username,
    this.email,
    this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;

    return data;
  }
}
