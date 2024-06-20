class PharmacyModel {
  int? code;
  bool? sucess;
  List<PharmacyModelData>? data;
  String? message;

  PharmacyModel({this.code, this.sucess, this.data, this.message});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <PharmacyModelData>[];
      json['data'].forEach((v) {
        data!.add(new PharmacyModelData.fromJson(v));
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

class PharmacyModelData {
  int? userId;
  String? firstName;
  String? email;
  String? password;
  Null? image;
  int? userRole;
  int? authType;
  String? address;
  String? phone;
  String? lastName;
  String? assosiatedHospital;
  String? about;
  String? location;
  String? deviceToken;

  PharmacyModelData(
      {this.userId,
      this.firstName,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.address,
      this.phone,
      this.lastName,
      this.assosiatedHospital,
      this.about,
      this.location,
      this.deviceToken});

  PharmacyModelData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    userRole = json['user_role'];
    authType = json['auth_type'];
    address = json['address'];
    phone = json['phone'];
    lastName = json['last_name'];
    assosiatedHospital = json['assosiated_hospital'];
    about = json['about'];
    location = json['location'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['user_role'] = this.userRole;
    data['auth_type'] = this.authType;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['last_name'] = this.lastName;
    data['assosiated_hospital'] = this.assosiatedHospital;
    data['about'] = this.about;
    data['location'] = this.location;
    data['device_token'] = this.deviceToken;
    return data;
  }
}
