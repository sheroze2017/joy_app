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
  dynamic bloodId;
  String? patientName;
  String? date;
  String? unitsOfBlood;
  String? bloodGroup;
  String? gender;
  String? city;
  String? location;
  String? status;
  String? createdAt;
  dynamic userId;
  String? time;
  String? type;
  String? image;
  String? phone;
  String? responseTime; // Preferred response time (e.g., "within 1 hour", "within 3 hours", etc.)
  UserDetails? userDetails;
  DonorDetails? donorDetails;
  dynamic donorUserId;
  String? donorAttachedAt;

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
      this.phone,
      this.responseTime,
      this.userDetails,
      this.donorDetails,
      this.donorUserId,
      this.donorAttachedAt});

  BloodRequest.fromJson(Map<String, dynamic> json) {
    // Handle _id or blood_id - can be string or int
    bloodId = json['blood_id'] ?? json['_id'];
    patientName = json['patient_name'];
    date = json['date'];
    // Handle units_of_blood - can be string or int
    unitsOfBlood = json['units_of_blood']?.toString();
    bloodGroup = json['blood_group'];
    gender = json['gender'];
    city = json['city'];
    location = json['location'];
    status = json['status']?.toString();
    createdAt = json['created_at'];
    // Handle user_id - can be string or int
    userId = json['user_id'];
    time = json['time'];
    type = json['type'];
    image = json['image']?.toString() ?? '';
    phone = json['phone']?.toString();
    // Parse response_time or preferred_response_time
    responseTime = json['response_time'] ?? json['preferred_response_time'] ?? json['timing'];
    // Parse user_details if present
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    // Parse donor_details if present
    donorDetails = json['donor_details'] != null
        ? DonorDetails.fromJson(json['donor_details'])
        : null;
    // Parse donor_user_id and donor_attached_at
    donorUserId = json['donor_user_id'];
    donorAttachedAt = json['donor_attached_at']?.toString();
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
    data['response_time'] = this.responseTime;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    if (this.donorDetails != null) {
      data['donor_details'] = this.donorDetails!.toJson();
    }
    data['donor_user_id'] = this.donorUserId;
    data['donor_attached_at'] = this.donorAttachedAt;
    return data;
  }
}

class UserDetails {
  dynamic id;
  String? name;
  String? email;
  String? phone;

  UserDetails({this.id, this.name, this.email, this.phone});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class DonorDetails {
  dynamic id;
  String? name;
  String? email;
  String? phone;
  String? bloodGroup;
  String? location;
  String? city;

  DonorDetails({this.id, this.name, this.email, this.phone, this.bloodGroup, this.location, this.city});

  DonorDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    bloodGroup = json['blood_group'];
    location = json['location'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['blood_group'] = this.bloodGroup;
    data['location'] = this.location;
    data['city'] = this.city;
    return data;
  }
}
