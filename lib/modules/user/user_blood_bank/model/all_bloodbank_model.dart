import 'package:joy_app/modules/blood_bank/model/blood_bank_details_model.dart';

class AllBloodBank {
  int? code;
  bool? sucess;
  List<BloodBank>? data;
  String? message;

  AllBloodBank({this.code, this.sucess, this.data, this.message});

  AllBloodBank.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <BloodBank>[];
      json['data'].forEach((v) {
        data!.add(new BloodBank.fromJson(v));
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

class BloodBank {
  dynamic id; // _id from API (MongoDB ObjectId)
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
  BloodBankDetailsData? details; // Nested details object
  List<Reviews>? reviews;

  BloodBank(
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
      this.details,
      this.reviews});

  BloodBank.fromJson(Map<String, dynamic> json) {
    // Handle _id (MongoDB) or user_id (legacy)
    id = json['_id'] ?? json['id'];
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
    location = json['location']?.toString();
    placeId = json['place_id']?.toString();
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
    
    // Parse nested details object if present
    details = json['details'] != null
        ? BloodBankDetailsData.fromJson(json['details'])
        : null;
    
    // Use location from details if main location is empty or null
    if (details?.location != null) {
      final loc = location;
      if (loc == null || loc.isEmpty || loc == 'null') {
        location = details!.location;
      }
    }
    if (details?.placeId != null) {
      final pid = placeId;
      if (pid == null || pid.isEmpty || pid == 'null') {
        placeId = details!.placeId;
      }
    }
    if (details?.lat != null) {
      final latVal = lat;
      if (latVal == null || latVal.isEmpty || latVal == 'null') {
        lat = details!.lat;
      }
    }
    if (details?.lng != null) {
      final lngVal = lng;
      if (lngVal == null || lngVal.isEmpty || lngVal == 'null') {
        lng = details!.lng;
      }
    }
    
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    } else {
      reviews = [];
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
    data['reviews'] = this.reviews;
    return data;
  }
}

class Reviews {
  String? rating;
  String? review;
  String? status;
  GiveBy? giveBy;
  int? reviewId;
  String? createdAt;

  Reviews(
      {this.rating,
      this.review,
      this.status,
      this.giveBy,
      this.reviewId,
      this.createdAt});

  Reviews.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    review = json['review'];
    status = json['status'];
    giveBy =
        json['give_by'] != null ? new GiveBy.fromJson(json['give_by']) : null;
    reviewId = json['review_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['status'] = this.status;
    if (this.giveBy != null) {
      data['give_by'] = this.giveBy!.toJson();
    }
    data['review_id'] = this.reviewId;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class GiveBy {
  String? name;
  String? image;

  GiveBy({this.name, this.image});

  GiveBy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
