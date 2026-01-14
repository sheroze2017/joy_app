class PharmacyRegisterModel {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  PharmacyRegisterModel({this.code, this.sucess, this.data, this.message});

  PharmacyRegisterModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  String? name;
  String? email;
  String? password;
  String? image;
  String? userRole;
  String? authType;
  String? phone;
  String? deviceToken;
  int? pharmacyDetailId;
  String? placeId;
  String? lat;
  String? lng;
  String? location;

  Data(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.pharmacyDetailId,
      this.placeId,
      this.lat,
      this.lng,
      this.location});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    print('📋 [PharmacyRegisterModel.Data] Parsing userId: $userId (type: ${userId.runtimeType})');
    // Convert to String if it's not already (for MongoDB ObjectId)
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image']?.toString() ?? '';
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone']?.toString() ?? '';
    deviceToken = json['device_token']?.toString() ?? '';
    pharmacyDetailId = json['pharmacy_detail_id'];
    // Handle nested profile structure if present
    if (json['profile'] != null && json['profile']['pharmacy'] != null) {
      final pharmacyProfile = json['profile']['pharmacy'];
      placeId = pharmacyProfile['place_id']?.toString();
      lat = pharmacyProfile['lat']?.toString();
      lng = pharmacyProfile['lng']?.toString();
      location = pharmacyProfile['location']?.toString();
    } else {
      placeId = json['place_id']?.toString();
      lat = json['lat']?.toString();
      lng = json['lng']?.toString();
      location = json['location']?.toString();
    }
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
    data['pharmacy_detail_id'] = this.pharmacyDetailId;
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    return data;
  }
}
