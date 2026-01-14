class NearbyServicesAndBookings {
  int? code;
  bool? sucess;
  NearbyServicesData? data;
  String? message;

  NearbyServicesAndBookings({this.code, this.sucess, this.data, this.message});

  NearbyServicesAndBookings.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null
        ? NearbyServicesData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class NearbyServicesData {
  List<NearbyPharmacy>? pharmacies;
  List<NearbyHospital>? hospitals;
  List<NearbyDoctor>? doctors;
  List<BloodDonor>? bloodDonors;
  List<Booking>? bookings;

  NearbyServicesData({
    this.pharmacies,
    this.hospitals,
    this.doctors,
    this.bloodDonors,
    this.bookings,
  });

  NearbyServicesData.fromJson(Map<String, dynamic> json) {
    if (json['pharmacies'] != null) {
      pharmacies = <NearbyPharmacy>[];
      json['pharmacies'].forEach((v) {
        pharmacies!.add(NearbyPharmacy.fromJson(v));
      });
    } else {
      pharmacies = [];
    }
    if (json['hospitals'] != null) {
      hospitals = <NearbyHospital>[];
      json['hospitals'].forEach((v) {
        hospitals!.add(NearbyHospital.fromJson(v));
      });
    } else {
      hospitals = [];
    }
    if (json['doctors'] != null) {
      doctors = <NearbyDoctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(NearbyDoctor.fromJson(v));
      });
    } else {
      doctors = [];
    }
    if (json['blood_donors'] != null) {
      bloodDonors = <BloodDonor>[];
      json['blood_donors'].forEach((v) {
        bloodDonors!.add(BloodDonor.fromJson(v));
      });
    } else {
      bloodDonors = [];
    }
    if (json['bookings'] != null) {
      bookings = <Booking>[];
      json['bookings'].forEach((v) {
        bookings!.add(Booking.fromJson(v));
      });
    } else {
      bookings = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.pharmacies != null) {
      data['pharmacies'] = this.pharmacies!.map((v) => v.toJson()).toList();
    }
    if (this.hospitals != null) {
      data['hospitals'] = this.hospitals!.map((v) => v.toJson()).toList();
    }
    if (this.doctors != null) {
      data['doctors'] = this.doctors!.map((v) => v.toJson()).toList();
    }
    if (this.bloodDonors != null) {
      data['blood_donors'] = this.bloodDonors!.map((v) => v.toJson()).toList();
    }
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NearbyPharmacy {
  dynamic id;
  String? name;
  String? email;
  String? location;
  String? phone;
  String? image;
  String? status;
  PharmacyDetails? details;

  NearbyPharmacy({
    this.id,
    this.name,
    this.email,
    this.location,
    this.phone,
    this.image,
    this.status,
    this.details,
  });

  NearbyPharmacy.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    if (id != null && id is! String) {
      id = id.toString();
    }
    name = json['name']?.toString() ?? '';
    email = json['email']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    details = json['details'] != null
        ? PharmacyDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class PharmacyDetails {
  String? placeId;
  String? lat;
  String? lng;
  String? location;

  PharmacyDetails({this.placeId, this.lat, this.lng, this.location});

  PharmacyDetails.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id']?.toString() ?? '';
    lat = json['lat']?.toString() ?? '';
    lng = json['lng']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    return data;
  }
}

class NearbyHospital {
  dynamic id;
  String? name;
  String? email;
  String? location;
  String? phone;
  String? image;
  String? status;
  HospitalDetails? details;

  NearbyHospital({
    this.id,
    this.name,
    this.email,
    this.location,
    this.phone,
    this.image,
    this.status,
    this.details,
  });

  NearbyHospital.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    if (id != null && id is! String) {
      id = id.toString();
    }
    name = json['name']?.toString() ?? '';
    email = json['email']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    details = json['details'] != null
        ? HospitalDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class HospitalDetails {
  String? placeId;
  String? lat;
  String? lng;
  String? about;
  String? institute;
  String? checkupFee;
  String? location;

  HospitalDetails({
    this.placeId,
    this.lat,
    this.lng,
    this.about,
    this.institute,
    this.checkupFee,
    this.location,
  });

  HospitalDetails.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id']?.toString() ?? '';
    lat = json['lat']?.toString() ?? '';
    lng = json['lng']?.toString() ?? '';
    about = json['about']?.toString() ?? '';
    institute = json['institute']?.toString() ?? '';
    checkupFee = json['checkup_fee']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class NearbyDoctor {
  dynamic id;
  String? name;
  String? email;
  String? location;
  String? phone;
  String? image;
  String? status;
  List<Review>? reviews;
  List<Availability>? availability;
  DoctorDetails? details;
  double? averageRating; // Added average rating

  NearbyDoctor({
    this.id,
    this.name,
    this.email,
    this.location,
    this.phone,
    this.image,
    this.status,
    this.reviews,
    this.availability,
    this.details,
    this.averageRating,
  });

  NearbyDoctor.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    if (id != null && id is! String) {
      id = id.toString();
    }
    name = json['name']?.toString() ?? '';
    email = json['email']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews!.add(Review.fromJson(v));
      });
      
      // Calculate average rating
      if (reviews!.isNotEmpty) {
        double totalRating = 0;
        int validRatings = 0;
        for (var review in reviews!) {
          if (review.ratings != null) {
            totalRating += review.ratings!.toDouble();
            validRatings++;
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
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(Availability.fromJson(v));
      });
    } else {
      availability = [];
    }
    details = json['details'] != null
        ? DoctorDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.availability != null) {
      data['availability'] = this.availability!.map((v) => v.toJson()).toList();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Review {
  dynamic reviewId;
  dynamic givenTo;
  dynamic givenBy;
  int? ratings; // Store as int for calculation
  String? review;
  String? createdAt;

  Review({
    this.reviewId,
    this.givenTo,
    this.givenBy,
    this.ratings,
    this.review,
    this.createdAt,
  });

  Review.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'] ?? json['_id'];
    givenTo = json['given_to'];
    givenBy = json['give_by'] ?? json['given_by']; // API uses 'give_by'
    // API uses 'rating' (singular), not 'ratings'
    if (json['rating'] != null) {
      ratings = json['rating'] is int ? json['rating'] : int.tryParse(json['rating'].toString());
    } else if (json['ratings'] != null) {
      ratings = json['ratings'] is int ? json['ratings'] : int.tryParse(json['ratings'].toString());
    }
    review = json['review']?.toString() ?? '';
    createdAt = json['review_created_at']?.toString() ?? json['created_at']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_id'] = this.reviewId;
    data['given_to'] = this.givenTo;
    data['given_by'] = this.givenBy;
    data['ratings'] = this.ratings;
    data['review'] = this.review;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Availability {
  String? day;
  List<String>? times;

  Availability({this.day, this.times});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day']?.toString() ?? '';
    if (json['times'] != null) {
      times = <String>[];
      json['times'].forEach((v) {
        times!.add(v.toString());
      });
    } else {
      times = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = this.day;
    if (this.times != null) {
      data['times'] = this.times;
    }
    return data;
  }
}

class DoctorDetails {
  String? gender;
  String? expertise;
  String? location;
  String? consultationFee;
  String? document;
  String? qualifications;
  String? aboutMe;
  List<Availability>? availability;

  DoctorDetails({
    this.gender,
    this.expertise,
    this.location,
    this.consultationFee,
    this.document,
    this.qualifications,
    this.aboutMe,
    this.availability,
  });

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    gender = json['gender']?.toString() ?? '';
    expertise = json['expertise']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    consultationFee = json['consultation_fee']?.toString() ?? '';
    document = json['document']?.toString() ?? '';
    qualifications = json['qualifications']?.toString() ?? '';
    aboutMe = json['about_me']?.toString() ?? '';
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(Availability.fromJson(v));
      });
    } else {
      availability = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = this.gender;
    data['expertise'] = this.expertise;
    data['location'] = this.location;
    data['consultation_fee'] = this.consultationFee;
    data['document'] = this.document;
    data['qualifications'] = this.qualifications;
    data['about_me'] = this.aboutMe;
    if (this.availability != null) {
      data['availability'] = this.availability!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BloodDonor {
  dynamic id;
  String? name;
  String? bloodGroup;
  String? location;
  String? gender;
  String? city;
  String? status;
  dynamic userId;
  String? createdAt;
  String? type;

  BloodDonor({
    this.id,
    this.name,
    this.bloodGroup,
    this.location,
    this.gender,
    this.city,
    this.status,
    this.userId,
    this.createdAt,
    this.type,
  });

  BloodDonor.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    if (id != null && id is! String) {
      id = id.toString();
    }
    name = json['name']?.toString() ?? '';
    bloodGroup = json['blood_group']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    gender = json['gender']?.toString() ?? '';
    city = json['city']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    userId = json['user_id'];
    createdAt = json['created_at']?.toString() ?? '';
    type = json['type']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['name'] = this.name;
    data['blood_group'] = this.bloodGroup;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    return data;
  }
}

class Booking {
  dynamic id;
  dynamic doctorUserId;
  dynamic patientUserId;
  String? date;
  String? time;
  String? status;
  String? createdAt;
  String? complain;
  String? symptoms;
  String? location;
  String? remarks;
  String? patientName;
  String? age;
  String? gender;
  String? certificate;
  String? diagnosis;
  String? medications;
  DoctorDetailsInBooking? doctorDetails;

  Booking({
    this.id,
    this.doctorUserId,
    this.patientUserId,
    this.date,
    this.time,
    this.status,
    this.createdAt,
    this.complain,
    this.symptoms,
    this.location,
    this.remarks,
    this.patientName,
    this.age,
    this.gender,
    this.certificate,
    this.diagnosis,
    this.medications,
    this.doctorDetails,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    doctorUserId = json['doctor_user_id'];
    patientUserId = json['patient_user_id'];
    date = json['date']?.toString() ?? '';
    time = json['time']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    createdAt = json['created_at']?.toString() ?? '';
    complain = json['complain']?.toString() ?? '';
    symptoms = json['symptoms']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    remarks = json['remarks']?.toString() ?? '';
    patientName = json['patient_name']?.toString() ?? '';
    age = json['age']?.toString() ?? '';
    gender = json['gender']?.toString() ?? '';
    certificate = json['certificate'];
    diagnosis = json['diagnosis'];
    medications = json['medications'];
    doctorDetails = json['doctor_details'] != null
        ? DoctorDetailsInBooking.fromJson(json['doctor_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['doctor_user_id'] = this.doctorUserId;
    data['patient_user_id'] = this.patientUserId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['complain'] = this.complain;
    data['symptoms'] = this.symptoms;
    data['location'] = this.location;
    data['remarks'] = this.remarks;
    data['patient_name'] = this.patientName;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['certificate'] = this.certificate;
    data['diagnosis'] = this.diagnosis;
    data['medications'] = this.medications;
    if (this.doctorDetails != null) {
      data['doctor_details'] = this.doctorDetails!.toJson();
    }
    return data;
  }
}

class DoctorDetailsInBooking {
  dynamic id;
  String? doctorName;
  String? doctorEmail;
  String? doctorPhone;
  String? doctorImage;
  String? doctorLocation;
  DoctorDetailsNested? doctorDetails;

  DoctorDetailsInBooking({
    this.id,
    this.doctorName,
    this.doctorEmail,
    this.doctorPhone,
    this.doctorImage,
    this.doctorLocation,
    this.doctorDetails,
  });

  DoctorDetailsInBooking.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    doctorName = json['doctor_name']?.toString() ?? '';
    doctorEmail = json['doctor_email']?.toString() ?? '';
    doctorPhone = json['doctor_phone']?.toString() ?? '';
    doctorImage = json['doctor_image']?.toString() ?? '';
    doctorLocation = json['doctor_location']?.toString() ?? '';
    doctorDetails = json['doctor_details'] != null
        ? DoctorDetailsNested.fromJson(json['doctor_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.id;
    data['doctor_name'] = this.doctorName;
    data['doctor_email'] = this.doctorEmail;
    data['doctor_phone'] = this.doctorPhone;
    data['doctor_image'] = this.doctorImage;
    data['doctor_location'] = this.doctorLocation;
    if (this.doctorDetails != null) {
      data['doctor_details'] = this.doctorDetails!.toJson();
    }
    return data;
  }
}

class DoctorDetailsNested {
  String? expertise;
  String? qualification;
  String? consultationFee;

  DoctorDetailsNested({
    this.expertise,
    this.qualification,
    this.consultationFee,
  });

  DoctorDetailsNested.fromJson(Map<String, dynamic> json) {
    expertise = json['expertise']?.toString() ?? '';
    qualification = json['qualification']?.toString() ?? '';
    consultationFee = json['consultation_fee']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expertise'] = this.expertise;
    data['qualification'] = this.qualification;
    data['consultation_fee'] = this.consultationFee;
    return data;
  }
}
