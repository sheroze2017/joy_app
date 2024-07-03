class AllBloodRequest {
  int? code;
  bool? sucess;
  List<BloodRequest>? data;
  String? message;

  AllBloodRequest({this.code, this.sucess, this.data, this.message});

  AllBloodRequest.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <BloodRequest>[];
      json['data'].forEach((v) {
        data!.add(new BloodRequest.fromJson(v));
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

class BloodRequest {
  int? bloodId;
  String? patientName;
  String? date;
  String? unitsOfBlood;
  String? bloodGroup;
  String? gender;
  String? city;
  String? location;
  String? status;
  String? createdAt;
  int? userId;
  String? time;
  String? type;
  String? image;
  String? phone;

  BloodRequest(
      {this.bloodId,
      this.patientName,
      this.date,
      this.unitsOfBlood,
      this.bloodGroup,
      this.gender,
      this.city,
      this.location,
      this.status,
      this.createdAt,
      this.userId,
      this.time,
      this.type,
      this.image,
      this.phone});

  BloodRequest.fromJson(Map<String, dynamic> json) {
    bloodId = json['blood_id'];
    patientName = json['patient_name'];
    date = json['date'];
    unitsOfBlood = json['units_of_blood'];
    bloodGroup = json['blood_group'];
    gender = json['gender'];
    city = json['city'];
    location = json['location'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    userId = json['user_id'];
    time = json['time'];
    type = json['type'];
    image = json['image'].toString();
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blood_id'] = this.bloodId;
    data['patient_name'] = this.patientName;
    data['date'] = this.date;
    data['units_of_blood'] = this.unitsOfBlood;
    data['blood_group'] = this.bloodGroup;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['location'] = this.location;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['user_id'] = this.userId;
    data['time'] = this.time;
    data['type'] = this.type;
    data['image'] = this.image;
    data['phone'] = this.phone;
    return data;
  }
}
