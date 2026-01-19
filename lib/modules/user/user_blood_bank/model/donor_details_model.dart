class DonorDetailsResponse {
  bool? success;
  DonorDetailsData? data;
  String? message;
  bool? isSuccess;

  DonorDetailsResponse({this.success, this.data, this.message, this.isSuccess});

  DonorDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? DonorDetailsData.fromJson(json['data']) : null;
    message = json['message'];
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}

class DonorDetailsData {
  dynamic id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? location;
  String? userRole;
  int? totalDonations;
  List<FulfilledDonation>? fulfilledDonations;
  String? about;
  String? bloodGroup;
  int? age;
  ProfileData? profile;

  DonorDetailsData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.location,
    this.userRole,
    this.totalDonations,
    this.fulfilledDonations,
    this.about,
    this.bloodGroup,
    this.age,
    this.profile,
  });

  DonorDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image']?.toString();
    location = json['location'];
    userRole = json['user_role'];
    totalDonations = json['total_donations'];
    about = json['about'];
    bloodGroup = json['blood_group'];
    age = json['age'];
    
    // Parse nested profile data
    profile = json['profile'] != null ? ProfileData.fromJson(json['profile']) : null;
    
    // Use about_me from profile if about is not available
    final aboutValue = about;
    if ((aboutValue == null || aboutValue.isEmpty) && profile?.demographics?.aboutMe != null) {
      about = profile!.demographics!.aboutMe;
    }
    
    // Calculate age from dob if age is not provided
    if (age == null && profile?.demographics?.dob != null) {
      try {
        final dob = DateTime.parse(profile!.demographics!.dob!);
        final today = DateTime.now();
        age = today.year - dob.year;
        if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
          age = age! - 1;
        }
      } catch (e) {
        // If parsing fails, age remains null
      }
    }
    
    if (json['fulfilled_donations'] != null) {
      fulfilledDonations = <FulfilledDonation>[];
      json['fulfilled_donations'].forEach((v) {
        fulfilledDonations!.add(FulfilledDonation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['location'] = this.location;
    data['user_role'] = this.userRole;
    data['total_donations'] = this.totalDonations;
    data['about'] = this.about;
    data['blood_group'] = this.bloodGroup;
    data['age'] = this.age;
    if (this.fulfilledDonations != null) {
      data['fulfilled_donations'] = this.fulfilledDonations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileData {
  Demographics? demographics;

  ProfileData({this.demographics});

  ProfileData.fromJson(Map<String, dynamic> json) {
    demographics = json['demographics'] != null 
        ? Demographics.fromJson(json['demographics']) 
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.demographics != null) {
      data['demographics'] = this.demographics!.toJson();
    }
    return data;
  }
}

class Demographics {
  String? gender;
  String? dob;
  String? location;
  String? aboutMe;

  Demographics({this.gender, this.dob, this.location, this.aboutMe});

  Demographics.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    dob = json['dob'];
    location = json['location'];
    aboutMe = json['about_me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['location'] = this.location;
    data['about_me'] = this.aboutMe;
    return data;
  }
}

class FulfilledDonation {
  dynamic id;
  String? bloodGroup;
  String? status;
  String? donorUserId;
  String? createdAt;

  FulfilledDonation({
    this.id,
    this.bloodGroup,
    this.status,
    this.donorUserId,
    this.createdAt,
  });

  FulfilledDonation.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    bloodGroup = json['blood_group'];
    status = json['status'];
    donorUserId = json['donor_user_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['blood_group'] = this.bloodGroup;
    data['status'] = this.status;
    data['donor_user_id'] = this.donorUserId;
    data['created_at'] = this.createdAt;
    return data;
  }
}

