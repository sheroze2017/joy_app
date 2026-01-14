class AllHospital {
  int? code;
  bool? sucess;
  List<Hospital>? data;
  String? message;

  AllHospital({this.code, this.sucess, this.data, this.message});

  AllHospital.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <Hospital>[];
      json['data'].forEach((v) {
        data!.add(new Hospital.fromJson(v));
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

class Hospital {
  int? userId;
  String? originalId; // Store original ID as string for cases where ID is not an int
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
  List<Reviews>? reviews;

  Hospital(
      {this.userId,
      this.originalId,
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
      this.location,
      this.reviews});

  Hospital.fromJson(Map<String, dynamic> json) {
    // Handle both _id (MongoDB) and user_id (legacy)
    if (json['_id'] != null) {
      originalId = json['_id'].toString(); // Store original ID as string
      userId = int.tryParse(json['_id'].toString()) ?? json['_id'];
    } else {
      originalId = json['user_id']?.toString(); // Store original ID as string
      userId = json['user_id'];
    }
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
