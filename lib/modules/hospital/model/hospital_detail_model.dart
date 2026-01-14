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

class HospitalTiming {
  String? day;
  String? open;
  String? close;

  HospitalTiming({this.day, this.open, this.close});

  HospitalTiming.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    open = json['open'];
    close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['open'] = this.open;
    data['close'] = this.close;
    return data;
  }
}

class HospitalReview {
  dynamic reviewId;
  String? review;
  int? rating;
  String? reviewCreatedAt;
  HospitalReviewGivenBy? givenBy;

  HospitalReview({this.reviewId, this.review, this.rating, this.reviewCreatedAt, this.givenBy});

  HospitalReview.fromJson(Map<String, dynamic> json) {
    reviewId = json['_id'] ?? json['review_id'];
    review = json['review'];
    rating = json['rating'];
    reviewCreatedAt = json['review_created_at'];
    givenBy = json['given_by'] != null ? new HospitalReviewGivenBy.fromJson(json['given_by']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_id'] = this.reviewId;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['review_created_at'] = this.reviewCreatedAt;
    if (this.givenBy != null) {
      data['given_by'] = this.givenBy!.toJson();
    }
    return data;
  }
}

class HospitalReviewGivenBy {
  dynamic userId;
  String? name;
  String? email;
  String? image;

  HospitalReviewGivenBy({this.userId, this.name, this.email, this.image});

  HospitalReviewGivenBy.fromJson(Map<String, dynamic> json) {
    userId = json['_id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}

class HospitalPharmacy {
  dynamic pharmacyId;
  String? name;
  String? email;
  String? location;
  String? phone;
  String? image;
  HospitalPharmacyDetails? details;

  HospitalPharmacy({this.pharmacyId, this.name, this.email, this.location, this.phone, this.image, this.details});

  HospitalPharmacy.fromJson(Map<String, dynamic> json) {
    pharmacyId = json['_id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    location = json['location'] ?? '';
    phone = json['phone'] ?? '';
    image = json['image'] ?? '';
    details = json['details'] != null ? new HospitalPharmacyDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.pharmacyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['image'] = this.image;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class HospitalPharmacyDetails {
  String? placeId;
  String? lat;
  String? lng;
  String? location;

  HospitalPharmacyDetails({this.placeId, this.lat, this.lng, this.location});

  HospitalPharmacyDetails.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'] ?? '';
    lat = json['lat']?.toString() ?? '';
    lng = json['lng']?.toString() ?? '';
    location = json['location'] ?? '';
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

class hospitaldetail {
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
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
  String? timing;
  List<HospitalTiming>? timings;
  List<HospitalReview>? reviews;
  List<HospitalPharmacy>? pharmacies;
  List<dynamic>? doctors; // List of doctor objects from API
  List<dynamic>? posts; // List of post objects from API
  int? doctorCount;
  int? pharmacyCount;
  String? averageRating;
  int? totalReviews;

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
      this.location,
      this.timing,
      this.timings,
      this.reviews,
      this.pharmacies,
      this.doctors,
      this.posts,
      this.doctorCount,
      this.pharmacyCount,
      this.averageRating,
      this.totalReviews});

  hospitaldetail.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    if (json['_id'] != null) {
      // MongoDB ID is a string
      userId = json['_id'].toString();
    } else if (json['user_id'] != null) {
      // Legacy ID might be int or string
      if (json['user_id'] is int) {
        userId = json['user_id'];
      } else {
        userId = json['user_id'].toString();
      }
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
    
    // Handle details object
    if (json['details'] != null) {
      final details = json['details'] as Map<String, dynamic>;
      placeId = details['place_id'] ?? '';
      lat = details['lat']?.toString() ?? '';
      lng = details['lng']?.toString() ?? '';
      about = details['about'] ?? json['about'] ?? '';
      institute = details['institute'] ?? '';
      checkupFee = details['checkup_fee']?.toString() ?? '';
      location = details['location'] ?? json['location'] ?? '';
      
      // Parse timings from details.timings
      if (details['timings'] != null) {
        timings = <HospitalTiming>[];
        details['timings'].forEach((v) {
          timings!.add(new HospitalTiming.fromJson(v));
        });
      }
    } else {
      placeId = json['place_id'] ?? '';
      lat = json['lat']?.toString() ?? '';
      lng = json['lng']?.toString() ?? '';
      about = json['about'] ?? '';
      institute = json['institute'] ?? '';
      checkupFee = json['checkup_fee']?.toString() ?? '';
      location = json['location'] ?? '';
    }
    
    // Also check root level timings
    if (json['timings'] != null && timings == null) {
      timings = <HospitalTiming>[];
      json['timings'].forEach((v) {
        timings!.add(new HospitalTiming.fromJson(v));
      });
    }
    
    // Parse reviews
    if (json['reviews'] != null) {
      reviews = <HospitalReview>[];
      json['reviews'].forEach((v) {
        reviews!.add(new HospitalReview.fromJson(v));
      });
    }
    
    // Parse pharmacies
    if (json['pharmacies'] != null) {
      pharmacies = <HospitalPharmacy>[];
      json['pharmacies'].forEach((v) {
        pharmacies!.add(new HospitalPharmacy.fromJson(v));
      });
    }
    
    // Parse doctors
    if (json['doctors'] != null) {
      doctors = <dynamic>[];
      json['doctors'].forEach((v) {
        doctors!.add(v); // Store as Map for now, can be converted to Doctor model when needed
      });
    }
    
    // Parse posts
    if (json['posts'] != null) {
      posts = <dynamic>[];
      json['posts'].forEach((v) {
        posts!.add(v); // Store as Map for now, can be converted to MediaPost model when needed
      });
    }
    
    // Parse summary statistics
    doctorCount = json['doctor_count'];
    pharmacyCount = json['pharmacy_count'];
    averageRating = json['average_rating']?.toString();
    totalReviews = json['total_reviews'];
    
    // Fallback to old availability field
    timing = json['availability'] ?? 'N/a';
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
