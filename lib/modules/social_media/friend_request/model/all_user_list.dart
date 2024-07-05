class AllUserList {
  int? code;
  bool? sucess;
  List<UserList>? data;
  String? message;

  AllUserList({this.code, this.sucess, this.data, this.message});

  AllUserList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <UserList>[];
      json['data'].forEach((v) {
        data!.add(new UserList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class UserList {
  int? userId;
  String? name;
  String? email;
  String? password;
  String? image;
  String? userRole;
  String? authType;
  String? phone;
  String? deviceToken;
  int? userDetailId;
  String? gender;
  String? dob;
  String? location;

  UserList(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.userDetailId,
      this.gender,
      this.dob,
      this.location});

  UserList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    image = json['image'].toString();
    userRole = json['user_role'] ?? '';
    authType = json['auth_type'] ?? '';
    phone = json['phone'] ?? '';
    deviceToken = json['device_token'] ?? '';
    userDetailId = json['user_detail_id'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    location = json['location'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['user_role'] = this.userRole;
    data['auth_type'] = this.authType;
    data['phone'] = this.phone;
    data['device_token'] = this.deviceToken;
    data['user_detail_id'] = this.userDetailId;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['location'] = this.location;
    return data;
  }
}
