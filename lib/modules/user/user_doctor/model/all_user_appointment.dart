class AllUserAppointment {
  int? code;
  bool? sucess;
  List<UserAppointment>? data;
  String? message;

  AllUserAppointment({this.code, this.sucess, this.data, this.message});

  AllUserAppointment.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <UserAppointment>[];
      json['data'].forEach((v) {
        data!.add(new UserAppointment.fromJson(v));
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

class UserAppointment {
  dynamic appointmentId; // Changed to dynamic to handle both String (MongoDB ObjectId) and int (legacy)
  dynamic doctorUserId; // Changed to dynamic to handle both String (MongoDB ObjectId) and int (legacy)
  int? patientUserId;
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
  dynamic rating; // Can be int, double, or String
  String? review;
  String? reviewCreatedAt;
  DoctorDetails? doctorDetails;

  UserAppointment(
      {this.appointmentId,
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
      this.rating,
      this.review,
      this.reviewCreatedAt,
      this.doctorDetails});

  UserAppointment.fromJson(Map<String, dynamic> json) {
    // Handle MongoDB ObjectId (_id as string) or legacy appointment_id
    if (json['_id'] != null) {
      // If _id is a string (MongoDB ObjectId), keep it as string
      if (json['_id'] is String) {
        appointmentId = json['_id'];
      } else {
        appointmentId = json['_id'];
      }
    } else {
      appointmentId = json['appointment_id'] ?? 0;
    }
    // Handle doctor_user_id as dynamic (String for MongoDB ObjectId, int for legacy)
    if (json['doctor_user_id'] != null) {
      if (json['doctor_user_id'] is String) {
        // Keep as string if it's a MongoDB ObjectId
        doctorUserId = json['doctor_user_id'];
      } else {
        doctorUserId = json['doctor_user_id'];
      }
    } else {
      doctorUserId = null;
    }
    patientUserId = json['patient_user_id'] != null
        ? (json['patient_user_id'] is String 
            ? int.tryParse(json['patient_user_id']) 
            : json['patient_user_id'])
        : 0;
    date = json['date'] ?? '';
    time = json['time'] ?? '';
    status = json['status'] ?? '';
    createdAt = json['created_at'] ?? '';
    complain = json['complain'] ?? '';
    symptoms = json['symptoms'] ?? '';
    location = json['location'] ?? '';
    remarks = json['remarks'] ?? '';
    patientName = json['patient_name'] ?? '';
    age = json['age'] ?? '';
    gender = json['gender'] ?? '';
    certificate = json['certificate'] ?? '';
    diagnosis = json['diagnosis'] ?? '';
    medications = json['medications'] ?? '';
    rating = json['rating'];
    if (rating is String) {
      rating = int.tryParse(rating) ?? double.tryParse(rating) ?? rating;
    }
    review = json['review']?.toString();
    reviewCreatedAt = json['review_created_at']?.toString();
    doctorDetails = json['doctor_details'] != null
        ? new DoctorDetails.fromJson(json['doctor_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
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
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['review_created_at'] = this.reviewCreatedAt;
    if (this.doctorDetails != null) {
      data['doctor_details'] = this.doctorDetails!.toJson();
    }
    return data;
  }
}

class DoctorDetails {
  dynamic doctorId; // Changed to dynamic to handle both String (MongoDB ObjectId) and int (legacy)
  String? doctorName;
  String? doctorImage;
  String? doctorEmail;
  String? doctorPhone;
  String? doctorLocation;
  DoctorDetails2? doctorDetails;
  List<AppointmentReview>? reviews;

  DoctorDetails(
      {this.doctorId,
      this.doctorName,
      this.doctorImage,
      this.doctorEmail,
      this.doctorPhone,
      this.doctorLocation,
      this.doctorDetails,
      this.reviews});

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    // Handle _id as dynamic (String for MongoDB ObjectId, int for legacy)
    if (json['_id'] != null) {
      if (json['_id'] is String) {
        // Keep as string if it's a MongoDB ObjectId
        doctorId = json['_id'];
      } else {
        doctorId = json['_id'];
      }
    } else {
      doctorId = json['doctor_id'] ?? null;
    }
    doctorName = json['doctor_name'] ?? '';
    doctorImage = json['doctor_image'] ?? '';
    doctorLocation = json['doctor_location'] ?? '';
    doctorEmail = json['doctor_email'] ?? '';
    doctorPhone = json['doctor_phone'] ?? '';
    doctorDetails = json['doctor_details'] != null
        ? new DoctorDetails2.fromJson(json['doctor_details'])
        : null;
    if (json['reviews'] != null) {
      reviews = <AppointmentReview>[];
      json['reviews'].forEach((v) {
        reviews!.add(new AppointmentReview.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['doctor_name'] = this.doctorName;
    data['doctor_email'] = this.doctorEmail;
    data['doctor_phone'] = this.doctorPhone;
    if (this.doctorDetails != null) {
      data['doctor_details'] = this.doctorDetails!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentReview {
  String? reviewId;
  String? givenTo;
  String? givenBy;
  dynamic rating;
  String? review;
  String? createdAt;
  String? status;

  AppointmentReview({
    this.reviewId,
    this.givenTo,
    this.givenBy,
    this.rating,
    this.review,
    this.createdAt,
    this.status,
  });

  AppointmentReview.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id']?.toString() ?? json['_id']?.toString();
    givenTo = json['given_to']?.toString();
    givenBy = json['given_by']?.toString();
    rating = json['rating'];
    review = json['review'] ?? '';
    createdAt = json['created_at'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_id'] = this.reviewId;
    data['given_to'] = this.givenTo;
    data['given_by'] = this.givenBy;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}

class DoctorDetails2 {
  String? expertise;
  String? qualification;
  String? consultationFee;

  DoctorDetails2({this.expertise, this.qualification, this.consultationFee});

  DoctorDetails2.fromJson(Map<String, dynamic> json) {
    expertise = json['expertise'];
    qualification = json['qualification'];
    consultationFee = json['consultation_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expertise'] = this.expertise;
    data['qualification'] = this.qualification;
    data['consultation_fee'] = this.consultationFee;
    return data;
  }
}
