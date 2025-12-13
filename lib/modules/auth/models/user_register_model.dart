class UserRegisterModel {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  UserRegisterModel({this.code, this.sucess, this.data, this.message});

  UserRegisterModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    // Handle both 'sucess' (typo) and 'success' (correct spelling) from backend
    sucess = json['sucess'] ?? json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  dynamic userId; // Changed to dynamic to handle both int and String (_id from MongoDB)
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    print('📋 [Data] Parsing userId: $userId (type: ${userId.runtimeType})');
    // Keep userId as-is (can be String for MongoDB _id or int for legacy user_id)
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone'];
    deviceToken = json['device_token'];
    userDetailId = json['user_detail_id'];
    // Handle nested profile structure
    if (json['profile'] != null && json['profile']['demographics'] != null) {
      gender = json['profile']['demographics']['gender'];
      dob = json['profile']['demographics']['dob'];
      location = json['profile']['demographics']['location'];
    } else {
      gender = json['gender'];
      dob = json['dob'];
      location = json['location'];
    }
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
