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
  String? qualifications;
  String? aboutMe;
  int? totalPatients;
  List<Reviews>? reviews;
  List<Availability>? availability;
  List<Booking>? bookings;

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
      this.aboutMe,
      this.totalPatients,
      this.reviews,
      this.availability,
      this.bookings});

  DoctorDetailsMap.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    // Convert to String if it's not already
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name']?.toString();
    email = json['email']?.toString();
    password = json['password']?.toString();
    image = json['image']?.toString() ?? '';
    userRole = json['user_role']?.toString() ?? '';
    authType = json['auth_type']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';
    deviceToken = json['device_token']?.toString() ?? '';
    doctorDetailId = json['doctor_detail_id'];
    // Handle nested details structure
    if (json['details'] != null) {
      gender = json['details']['gender']?.toString() ?? '';
      expertise = json['details']['expertise']?.toString() ?? '';
      location = json['details']['location']?.toString() ?? json['location']?.toString() ?? '';
      consultationFee = json['details']['consultation_fee']?.toString() ?? '';
      qualifications = json['details']['qualifications']?.toString() ?? '';
      aboutMe = json['details']['about_me']?.toString() ?? '';
    } else {
      gender = json['gender']?.toString() ?? '';
      expertise = json['expertise']?.toString() ?? '';
      location = json['location']?.toString() ?? '';
      consultationFee = json['consultation_fee']?.toString() ?? '';
      qualifications = json['qualifications']?.toString() ?? '';
      aboutMe = json['about_me']?.toString() ?? '';
    }
    // Handle total_patients from root level
    totalPatients = json['total_patients'] != null 
        ? (json['total_patients'] is int ? json['total_patients'] : int.tryParse(json['total_patients'].toString()))
        : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    } else {
      reviews = [];
    }
    // Handle availability from both root level and details
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(new Availability.fromJson(v));
      });
    } else if (json['details'] != null && json['details']['availability'] != null) {
      availability = <Availability>[];
      json['details']['availability'].forEach((v) {
        availability!.add(new Availability.fromJson(v));
      });
    } else {
      availability = [];
    }
    if (json['bookings'] != null) {
      bookings = <Booking>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Booking.fromJson(v));
      });
    } else {
      bookings = [];
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
    data['about_me'] = this.aboutMe;
    data['total_patients'] = this.totalPatients;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.availability != null) {
      data['availability'] = this.availability!.map((v) => v.toJson()).toList();
    }
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  dynamic rating; // Changed to dynamic to handle both int and String
  String? review;
  String? status;
  GiveBy? giveBy;
  dynamic reviewId; // Changed to dynamic to handle both int and String
  String? createdAt;

  Reviews(
      {this.rating,
      this.review,
      this.status,
      this.giveBy,
      this.reviewId,
      this.createdAt});

  Reviews.fromJson(Map<String, dynamic> json) {
    // Handle rating as both int and String
    rating = json['rating'];
    if (rating != null && rating is int) {
      rating = rating.toString();
    }
    review = json['review']?.toString();
    status = json['status']?.toString();
    giveBy =
        json['give_by'] != null ? new GiveBy.fromJson(json['give_by']) : null;
    reviewId = json['review_id'] ?? json['_id'];
    createdAt = json['created_at']?.toString();
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
    name = json['name']?.toString();
    final imageValue = json['image']?.toString() ?? '';
    // Set to null if empty string or contains broken URL pattern
    image = (imageValue.isEmpty || 
             imageValue == 'null' || 
             imageValue.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
        ? null
        : imageValue;
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
  String? times; // Will be converted from List to comma-separated string

  Availability({this.day, this.times});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day']?.toString();
    // Handle times as both List and String
    if (json['times'] != null) {
      if (json['times'] is List) {
        times = (json['times'] as List).map((e) => e.toString()).join(', ');
      } else {
        times = json['times'].toString();
      }
    } else {
      times = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['times'] = this.times;
    return data;
  }
}

class Booking {
  String? appointmentId;
  String? date;
  List<String>? times;
  String? status;

  Booking({this.appointmentId, this.date, this.times, this.status});

  Booking.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id']?.toString();
    date = json['date']?.toString();
    if (json['times'] != null) {
      if (json['times'] is List) {
        times = (json['times'] as List).map((e) => e.toString()).toList();
      } else {
        times = [json['times'].toString()];
      }
    } else {
      times = [];
    }
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['date'] = this.date;
    data['times'] = this.times;
    data['status'] = this.status;
    return data;
  }
}
