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
      this.medications});

  UserAppointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    doctorUserId = json['doctor_user_id'];
    patientUserId = json['patient_user_id'];
    date = json['date'];
    time = json['time'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    complain = json['complain'].toString();
    symptoms = json['symptoms'].toString();
    location = json['location'].toString();
    remarks = json['remarks'].toString();
    patientName = json['patient_name'].toString();
    age = json['age'].toString();
    gender = json['gender'].toString();
    certificate = json['certificate'].toString();
    diagnosis = json['diagnosis'].toString();
    medications = json['medications'].toString();
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
    return data;
  }
}
