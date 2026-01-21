class BloodBankDetails {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  BloodBankDetails({this.code, this.sucess, this.data, this.message});

  BloodBankDetails.fromJson(Map<String, dynamic> json) {
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
  dynamic id; // _id from API
  int? userId;
  String? name;
  String? email;
  String? password;
  String? image;
  String? userRole;
  String? authType;
  String? phone;
  String? deviceToken;
  int? bloodBankDetailId;
  String? location;
  String? placeId;
  String? lat;
  String? lng;
  String? status;
  String? createdAt;
  String? updatedAt;
  BloodBankDetailsData? details; // Nested details object
  String? about;
  dynamic timings; // Can be String or List<dynamic>
  int? patientsCount;
  int? experienceYears;
  double? rating;
  int? reviewsCount;
  int? activeBloodRequestsCount;
  int? activePlasmaRequestsCount;
  int? totalDonorsCount;

  Data(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.bloodBankDetailId,
      this.location,
      this.placeId,
      this.lat,
      this.lng,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.details,
      this.about,
      this.timings,
      this.patientsCount,
      this.experienceYears,
      this.rating,
      this.reviewsCount,
      this.activeBloodRequestsCount,
      this.activePlasmaRequestsCount,
      this.totalDonorsCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image']?.toString() ?? '';
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone'];
    deviceToken = json['device_token'];
    bloodBankDetailId = json['blood_bank_detail_id'];
    location = json['location'];
    placeId = json['place_id'];
    lat = json['lat'];
    lng = json['lng'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details = json['details'] != null
        ? BloodBankDetailsData.fromJson(json['details'])
        : null;
    about = json['about'];
    // Handle timings as either String or List
    if (json['timings'] != null) {
      if (json['timings'] is List) {
        timings = json['timings'];
      } else {
        timings = json['timings'].toString();
      }
    } else {
      timings = null;
    }
    patientsCount = json['patients_count'];
    experienceYears = json['experience_years'];
    rating = json['rating']?.toDouble();
    reviewsCount = json['reviews_count'];
    activeBloodRequestsCount = json['active_blood_requests_count'];
    activePlasmaRequestsCount = json['active_plasma_requests_count'];
    totalDonorsCount = json['total_donors_count'];
    
    // If location is in details, use that as fallback
    if (location == null && details?.location != null) {
      location = details!.location;
    }
    if (placeId == null && details?.placeId != null) {
      placeId = details!.placeId;
    }
    if (lat == null && details?.lat != null) {
      lat = details!.lat;
    }
    if (lng == null && details?.lng != null) {
      lng = details!.lng;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['user_role'] = this.userRole;
    data['auth_type'] = this.authType;
    data['phone'] = this.phone;
    data['device_token'] = this.deviceToken;
    data['blood_bank_detail_id'] = this.bloodBankDetailId;
    data['location'] = this.location;
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    data['about'] = this.about;
    data['timings'] = this.timings;
    data['patients_count'] = this.patientsCount;
    data['experience_years'] = this.experienceYears;
    data['rating'] = this.rating;
    data['reviews_count'] = this.reviewsCount;
    data['active_blood_requests_count'] = this.activeBloodRequestsCount;
    data['active_plasma_requests_count'] = this.activePlasmaRequestsCount;
    data['total_donors_count'] = this.totalDonorsCount;
    return data;
  }
}

class BloodBankDetailsData {
  String? placeId;
  String? lat;
  String? lng;
  String? location;
  String? about;
  dynamic timings; // Can be String or List<dynamic>

  BloodBankDetailsData({this.placeId, this.lat, this.lng, this.location, this.about, this.timings});

  BloodBankDetailsData.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
    location = json['location'];
    about = json['about'];
    // Handle timings as either String or List
    if (json['timings'] != null) {
      if (json['timings'] is List) {
        timings = json['timings'];
      } else {
        timings = json['timings'].toString();
      }
    } else {
      timings = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    return data;
  }
}
