import 'all_doctor_model.dart';

class DoctorCategoriesWithDoctors {
  int? code;
  bool? sucess;
  List<DoctorCategory>? data;
  String? message;

  DoctorCategoriesWithDoctors({this.code, this.sucess, this.data, this.message});

  DoctorCategoriesWithDoctors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'] ?? json['success'];
    if (json['data'] != null) {
      data = <DoctorCategory>[];
      (json['data'] as List).forEach((v) {
        data!.add(DoctorCategory.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class DoctorCategory {
  dynamic categoryId;
  String? name;
  int? order;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Doctor>? doctors;

  DoctorCategory({
    this.categoryId,
    this.name,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.doctors,
  });

  DoctorCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['_id'];
    name = json['name'];
    order = json['order'] is int ? json['order'] : (json['order'] != null ? int.tryParse(json['order'].toString()) : null);
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    
    if (json['doctors'] != null && json['doctors'] is List) {
      doctors = <Doctor>[];
      (json['doctors'] as List).forEach((v) {
        try {
          doctors!.add(Doctor.fromJson(v));
        } catch (e) {
          print('Error parsing doctor in category: $e');
        }
      });
    } else {
      doctors = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.categoryId;
    data['name'] = this.name;
    data['order'] = this.order;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.doctors != null) {
      data['doctors'] = this.doctors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
