class AllDonor {
  int? code;
  bool? sucess;
  List<BloodDonor>? data;
  String? message;

  AllDonor({this.code, this.sucess, this.data, this.message});

  AllDonor.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <BloodDonor>[];
      json['data'].forEach((v) {
        data!.add(new BloodDonor.fromJson(v));
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

class BloodDonor {
  dynamic donorId;
  String? name;
  String? bloodGroup;
  String? location;
  String? gender;
  String? city;
  String? status;
  dynamic userId;
  String? createdAt;
  String? type;
  String? phone;
  String? image;
  String? email;
  String? about;
  int? age;
  int? totalDonations;

  BloodDonor(
      {this.donorId,
      this.name,
      this.bloodGroup,
      this.location,
      this.gender,
      this.city,
      this.status,
      this.userId,
      this.createdAt,
      this.type,
      this.phone,
      this.image,
      this.email,
      this.about,
      this.age,
      this.totalDonations});

  BloodDonor.fromJson(Map<String, dynamic> json) {
    donorId = json['donor_id'] ?? json['_id'];
    name = json['name'];
    bloodGroup = json['blood_group'];
    location = json['location'];
    gender = json['gender'];
    city = json['city'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    type = json['type'];
    phone = json['phone'];
    image = json['image']?.toString() ?? '';
    email = json['email'];
    about = json['about'];
    age = json['age'] is int ? json['age'] : (json['age'] != null ? int.tryParse(json['age'].toString()) : null);
    totalDonations = json['total_donations'] is int ? json['total_donations'] : (json['total_donations'] != null ? int.tryParse(json['total_donations'].toString()) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['donor_id'] = this.donorId;
    data['name'] = this.name;
    data['blood_group'] = this.bloodGroup;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['email'] = this.email;
    data['about'] = this.about;
    data['age'] = this.age;
    data['total_donations'] = this.totalDonations;
    return data;
  }
}
