class AllDoctor {
  int? code;
  bool? sucess;
  List<Doctor>? data;
  String? message;

  AllDoctor({this.code, this.sucess, this.data, this.message});

  AllDoctor.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <Doctor>[];
      // Handle both cases: data as array or data.doctors as array
      if (json['data'] is List) {
        // data is directly an array
        (json['data'] as List).forEach((v) {
          data!.add(new Doctor.fromJson(v));
        });
      } else if (json['data'] is Map && json['data'].containsKey('doctors')) {
        // data is an object with 'doctors' key
        final doctorsList = json['data']['doctors'];
        if (doctorsList is List) {
          doctorsList.forEach((v) {
            data!.add(new Doctor.fromJson(v));
          });
        }
      }
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

class Doctor {
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
  String? document;
  String? qualifications;
  List<DoctorReview>? reviews; // Added reviews list
  double? averageRating; // Added average rating

  Doctor(
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
      this.document,
      this.qualifications,
      this.reviews,
      this.averageRating});

  Doctor.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    // Convert to String if it's not already
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone'];
    deviceToken = json['device_token'];
    doctorDetailId = json['doctor_detail_id'];
    gender = json['gender'];
    location = json['location'];
    
    // Handle nested details structure
    if (json['details'] != null && json['details'] is Map<String, dynamic>) {
      final details = json['details'] as Map<String, dynamic>;
      expertise = details['expertise']?.toString() ?? '';
      consultationFee = details['consultation_fee']?.toString();
      document = details['document']?.toString();
      qualifications = details['qualifications']?.toString();
      gender = details['gender']?.toString() ?? gender;
    } else {
      expertise = json['expertise']?.toString() ?? '';
      consultationFee = json['consultation_fee']?.toString();
      document = json['document']?.toString();
      qualifications = json['qualifications']?.toString();
    }
    
    // Parse reviews array
    if (json['reviews'] != null && json['reviews'] is List) {
      reviews = <DoctorReview>[];
      (json['reviews'] as List).forEach((v) {
        try {
          reviews!.add(DoctorReview.fromJson(v));
        } catch (e) {
          print('Error parsing review: $e');
        }
      });
      
      // Calculate average rating
      if (reviews!.isNotEmpty) {
        double totalRating = 0;
        int validRatings = 0;
        for (var review in reviews!) {
          if (review.ratings != null) {
            try {
              totalRating += review.ratings is int 
                  ? (review.ratings as int).toDouble()
                  : double.parse(review.ratings.toString());
              validRatings++;
            } catch (e) {
              print('Error parsing rating value: ${review.ratings}, error: $e');
              // Skip invalid ratings
            }
          }
        }
        averageRating = validRatings > 0 ? totalRating / validRatings : 0.0;
      } else {
        averageRating = 0.0;
      }
    } else {
      reviews = [];
      averageRating = 0.0;
    }
    
    // Debug: Print doctor info to verify parsing
    print('Doctor: ${name}, Reviews count: ${reviews?.length ?? 0}, Average rating: $averageRating');
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
    data['document'] = this.document;
    data['qualifications'] = this.qualifications;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorReview {
  dynamic reviewId;
  dynamic givenTo;
  dynamic givenBy;
  dynamic ratings; // Can be int or String
  String? review;
  String? createdAt;

  DoctorReview({
    this.reviewId,
    this.givenTo,
    this.givenBy,
    this.ratings,
    this.review,
    this.createdAt,
  });

  DoctorReview.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'] ?? json['_id'];
    givenTo = json['given_to'];
    givenBy = json['give_by'] ?? json['given_by']; // API uses 'give_by'
    ratings = json['rating'] ?? json['ratings']; // API uses 'rating' as primary
    review = json['review']?.toString();
    createdAt = json['review_created_at']?.toString() ?? json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_id'] = reviewId;
    data['given_to'] = givenTo;
    data['given_by'] = givenBy;
    data['ratings'] = ratings;
    data['review'] = review;
    data['created_at'] = createdAt;
    return data;
  }
}
