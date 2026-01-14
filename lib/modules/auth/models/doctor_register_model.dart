class DoctorRegisterModel {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  DoctorRegisterModel({this.code, this.sucess, this.data, this.message});

  DoctorRegisterModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
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
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
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
      this.doctorDetailId,
      this.gender,
      this.expertise,
      this.location,
      this.consultationFee,
      this.document,
      this.qualifications});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    print('📋 [DoctorRegisterModel.Data] Parsing userId: $userId (type: ${userId.runtimeType})');
    // Convert to String if it's not already (for MongoDB ObjectId)
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image']?.toString() ?? '';
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone']?.toString() ?? '';
    deviceToken = json['device_token']?.toString() ?? '';
    doctorDetailId = json['doctor_detail_id'];
    // Handle nested profile structure if present
    if (json['profile'] != null && json['profile']['doctor'] != null) {
      final doctorProfile = json['profile']['doctor'];
      gender = doctorProfile['gender']?.toString();
      expertise = doctorProfile['expertise']?.toString();
      location = doctorProfile['location']?.toString();
      consultationFee = doctorProfile['consultation_fee']?.toString();
      document = doctorProfile['document']?.toString();
      qualifications = doctorProfile['qualifications']?.toString();
    } else {
      gender = json['gender']?.toString();
      expertise = json['expertise']?.toString();
      location = json['location']?.toString();
      consultationFee = json['consultation_fee']?.toString();
      document = json['document']?.toString();
      qualifications = json['qualifications']?.toString();
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
