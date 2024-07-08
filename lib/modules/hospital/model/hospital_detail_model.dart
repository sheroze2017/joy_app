class HospitalDetail {
  int? code;
  bool? sucess;
  hospitaldetail? data;
  String? message;

  HospitalDetail({this.code, this.sucess, this.data, this.message});

  HospitalDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data =
        json['data'] != null ? new hospitaldetail.fromJson(json['data']) : null;
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

class hospitaldetail {
  int? userId;
  String? name;
  String? email;
  String? password;
  String? image;
  String? userRole;
  String? authType;
  String? phone;
  String? deviceToken;
  int? hospitalDetailId;
  String? placeId;
  String? lat;
  String? lng;
  String? about;
  String? institute;
  String? checkupFee;
  String? location;

  hospitaldetail(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.hospitalDetailId,
      this.placeId,
      this.lat,
      this.lng,
      this.about,
      this.institute,
      this.checkupFee,
      this.location});

  hospitaldetail.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    image = json['image'].toString();
    userRole = json['user_role'] ?? '';
    authType = json['auth_type'] ?? '';
    phone = json['phone'] ?? '';
    deviceToken = json['device_token'] ?? '';
    hospitalDetailId = json['hospital_detail_id'] ?? 0;
    placeId = json['place_id'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    about = json['about'] ?? '';
    institute = json['institute'] ?? '';
    checkupFee = json['checkup_fee'] ?? '';
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
    data['hospital_detail_id'] = this.hospitalDetailId;
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['about'] = this.about;
    data['institute'] = this.institute;
    data['checkup_fee'] = this.checkupFee;
    data['location'] = this.location;
    return data;
  }
}
