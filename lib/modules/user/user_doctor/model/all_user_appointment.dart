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
  int? appointmentId;
  int? doctorUserId;
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
      this.doctorDetails});

  UserAppointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'] ?? 0;
    doctorUserId = json['doctor_user_id'] ?? 0;
    patientUserId = json['patient_user_id'] ?? 0;
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
    if (this.doctorDetails != null) {
      data['doctor_details'] = this.doctorDetails!.toJson();
    }
    return data;
  }
}

class DoctorDetails {
  int? doctorId;
  String? doctorName;
  String? doctorImage;
  String? doctorEmail;
  String? doctorPhone;
  DoctorDetails2? doctorDetails;

  DoctorDetails(
      {this.doctorId,
      this.doctorName,
      this.doctorImage,
      this.doctorEmail,
      this.doctorPhone,
      this.doctorDetails});

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'] ?? 0;
    doctorName = json['doctor_name'];
    doctorImage = json['doctor_image'] ?? '';
    doctorEmail = json['doctor_email'];
    doctorPhone = json['doctor_phone'];
    doctorDetails = json['doctor_details'] != null
        ? new DoctorDetails2.fromJson(json['doctor_details'])
        : null;
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
