class DoctorDetail {
  int? code;
  bool? sucess;
  DoctorDetailsMap? data;
  String? message;

  DoctorDetail({this.code, this.sucess, this.data, this.message});

  DoctorDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null
        ? new DoctorDetailsMap.fromJson(json['data'])
        : null;
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

class DoctorDetailsMap {
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
  String? qualifications;
  List<Reviews>? reviews;
  List<Availability>? availability;

  DoctorDetailsMap(
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
      this.qualifications,
      this.reviews,
      this.availability});

  DoctorDetailsMap.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'].toString();
    userRole = json['user_role'] ?? '';
    authType = json['auth_type'] ?? '';
    phone = json['phone'] ?? '';
    deviceToken = json['device_token'] ?? '';
    doctorDetailId = json['doctor_detail_id'];
    gender = json['gender'] ?? '';
    expertise = json['expertise'] ?? '';
    location = json['location'] ?? '';
    consultationFee = json['consultation_fee'] ?? '';
    qualifications = json['qualifications'] ?? '';
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    } else {
      reviews = [];
    }
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(new Availability.fromJson(v));
      });
    } else {
      availability = [];
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
    data['qualifications'] = this.qualifications;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.availability != null) {
      data['availability'] = this.availability!.map((v) => v.toJson()).toList();
    }
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

class Availability {
  String? day;
  String? times;

  Availability({this.day, this.times});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    times = json['times'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['times'] = this.times;
    return data;
  }
}
