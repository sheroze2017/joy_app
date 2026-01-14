class DoctorAppointment {
  int? code;
  bool? sucess;
  List<Appointment>? data;
  String? message;

  DoctorAppointment({this.code, this.sucess, this.data, this.message});

  DoctorAppointment.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <Appointment>[];
      json['data'].forEach((v) {
        data!.add(new Appointment.fromJson(v));
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

class Appointment {
  dynamic appointmentId; // Changed to dynamic to handle both String (MongoDB ObjectId) and int (legacy)
  dynamic doctorUserId; // Changed to dynamic to handle both String and int
  dynamic patientUserId; // Changed to dynamic to handle both String and int
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
  UserDetails? userDetails;
  AppointmentReview? review;

  Appointment(
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
      this.userDetails,
      this.review});

  Appointment.fromJson(Map<String, dynamic> json) {
    // Handle MongoDB ObjectId (_id) or legacy appointment_id
    if (json['_id'] != null) {
      appointmentId = json['_id'] is String ? json['_id'] : json['_id'].toString();
    } else {
      appointmentId = json['appointment_id'];
    }
    
    doctorUserId = json['doctor_user_id'] != null
        ? (json['doctor_user_id'] is String ? json['doctor_user_id'] : json['doctor_user_id'].toString())
        : null;
    patientUserId = json['patient_user_id'] != null
        ? (json['patient_user_id'] is String ? json['patient_user_id'] : json['patient_user_id'].toString())
        : null;
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
    // Handle both patient_details (new API) and user_details (legacy)
    userDetails = json['patient_details'] != null
        ? new UserDetails.fromJson(json['patient_details'])
        : (json['user_details'] != null
            ? new UserDetails.fromJson(json['user_details'])
            : null);
    // Parse review object if present
    review = json['review'] != null && json['review'] is Map
        ? new AppointmentReview.fromJson(json['review'])
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
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    if (this.review != null) {
      data['review'] = this.review!.toJson();
    }
    return data;
  }
}

class AppointmentReview {
  String? patientName;
  String? patientEmail;
  String? patientPhone;
  String? patientImage;
  dynamic rating;
  String? review;
  String? reviewCreatedAt;

  AppointmentReview({
    this.patientName,
    this.patientEmail,
    this.patientPhone,
    this.patientImage,
    this.rating,
    this.review,
    this.reviewCreatedAt,
  });

  AppointmentReview.fromJson(Map<String, dynamic> json) {
    patientName = json['patient_name'] ?? '';
    patientEmail = json['patient_email'] ?? '';
    patientPhone = json['patient_phone'] ?? '';
    patientImage = json['patient_image'] ?? '';
    rating = json['rating'];
    review = json['review'] ?? '';
    reviewCreatedAt = json['review_created_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_name'] = this.patientName;
    data['patient_email'] = this.patientEmail;
    data['patient_phone'] = this.patientPhone;
    data['patient_image'] = this.patientImage;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['review_created_at'] = this.reviewCreatedAt;
    return data;
  }
}

class UserDetails {
  String? name;
  String? email;
  String? phone;
  dynamic userId; // Changed to dynamic to handle both String (MongoDB ObjectId) and int (legacy)
  String? image;

  UserDetails({this.name, this.email, this.phone, this.userId, this.image});

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    // Handle both _id (MongoDB) and user_id (legacy)
    userId = json['_id'] ?? json['user_id'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['user_id'] = this.userId;
    return data;
  }
}
