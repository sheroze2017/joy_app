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
  UserDetails? userDetails;

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
      this.userDetails});

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    doctorUserId = json['doctor_user_id'];
    patientUserId = json['patient_user_id'];
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
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
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
    return data;
  }
}

class UserDetails {
  String? name;
  String? email;
  String? phone;
  int? userId;
  String? image;

  UserDetails({this.name, this.email, this.phone, this.userId, this.image});

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    userId = json['user_id'] ?? 0;
    image = json[image] ?? '';
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
