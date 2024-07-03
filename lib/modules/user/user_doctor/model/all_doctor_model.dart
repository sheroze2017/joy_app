class AllDoctor {
  int? code;
  bool? sucess;
  List<Doctor>? data;
  String? message;

  AllDoctor({this.code, this.sucess, this.data, this.message});

  AllDoctor.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data!.add(new Doctor.fromJson(v));
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

class Doctor {
  int? userId;
  String? name;
  String? email;
  String? password;
  String? image;
  String? userRole;
  String? authType;
  String? phone;
  String? deviceToken;
  int? doctorDetailId;
  String? gender;
  String? expertise;
  String? location;
  String? consultationFee;
  String? document;
  String? qualifications;

  Doctor(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.doctorDetailId,
      this.gender,
      this.expertise,
      this.location,
      this.consultationFee,
      this.document,
      this.qualifications});

  Doctor.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone'];
    deviceToken = json['device_token'];
    doctorDetailId = json['doctor_detail_id'];
    gender = json['gender'];
    expertise = json['expertise'];
    location = json['location'];
    consultationFee = json['consultation_fee'];
    document = json['document'];
    qualifications = json['qualifications'];
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
    data['doctor_detail_id'] = this.doctorDetailId;
    data['gender'] = this.gender;
    data['expertise'] = this.expertise;
    data['location'] = this.location;
    data['consultation_fee'] = this.consultationFee;
    data['document'] = this.document;
    data['qualifications'] = this.qualifications;
    return data;
  }
}
