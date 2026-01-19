class PharmacyModel {
  int? code;
  bool? sucess;
  List<PharmacyModelData>? data;
  String? message;

  PharmacyModel({this.code, this.sucess, this.data, this.message});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <PharmacyModelData>[];
      json['data'].forEach((v) {
        data!.add(new PharmacyModelData.fromJson(v));
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

class PharmacyModelData {
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  String? name;
  String? email;
  String? password;
  String? image;
  String? userRole;
  String? authType;
  String? phone;
  String? deviceToken;
  int? pharmacyDetailId;
  String? placeId;
  String? lat;
  String? lng;
  String? location;
  List<PharReviews>? reviews;

  PharmacyModelData(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.pharmacyDetailId,
      this.placeId,
      this.lat,
      this.lng,
      this.location,
      this.reviews});

  PharmacyModelData.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    // Convert to String if it's not already (for MongoDB ObjectId)
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    image = json['image'].toString();
    userRole = json['user_role'] ?? '';
    authType = json['auth_type'] ?? '';
    phone = json['phone'] ?? '';
    deviceToken = json['device_token'] ?? '';
    pharmacyDetailId = json['pharmacy_detail_id'] ?? 1;
    
    // Handle nested details object (from getUnlinkedPharmacies API)
    if (json['details'] != null && json['details'] is Map) {
      final details = json['details'] as Map<String, dynamic>;
      placeId = details['place_id'] ?? json['place_id'] ?? '';
      lat = details['lat'] ?? json['lat'] ?? '';
      lng = details['lng'] ?? json['lng'] ?? '';
      location = details['location'] ?? json['location'];
    } else {
      // Fallback to root level if details not present
      placeId = json['place_id'] ?? '';
      lat = json['lat'] ?? '';
      lng = json['lng'] ?? '';
      location = json['location'];
    }
    if (json['reviews'] != null) {
      reviews = <PharReviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new PharReviews.fromJson(v));
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
    data['pharmacy_detail_id'] = this.pharmacyDetailId;
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    data['reviews'] = this.reviews;
    return data;
  }
}

class PharReviews {
  String? rating;
  String? review;
  String? status;
  GiveBy? giveBy;
  int? reviewId;
  String? createdAt;

  PharReviews(
      {this.rating,
      this.review,
      this.status,
      this.giveBy,
      this.reviewId,
      this.createdAt});

  PharReviews.fromJson(Map<String, dynamic> json) {
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

  double get ratingAsDouble {
    return double.tryParse(rating ?? '0') ?? 0.0;
  }

  static double calculateAverageRating(List<PharReviews> reviewsList) {
    if (reviewsList.isEmpty) return 0.0;

    double totalRating = reviewsList.fold(0.0, (sum, review) {
      return sum + review.ratingAsDouble;
    });

    return totalRating / reviewsList.length;
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
