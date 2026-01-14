class LoginModel {
  int? code;
  bool? sucess;
  LoginData? data;
  String? message;

  LoginModel({this.code, this.sucess, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
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

class LoginData {
  String? token;
  Data? user;

  LoginData({this.token, this.user});

  LoginData.fromJson(Map<String, dynamic> json) {
    print('🔍 [LoginData.fromJson] Starting - JSON keys: ${json.keys.toList()}');
    
    // Extract token from the data object
    token = json['token'];
    print('🔍 [LoginData.fromJson] Token extracted: ${token != null ? "***" : "null"}');
    
    // The user data is in the same object as token - parse it directly
    // Create a copy of json without token for user parsing
    final userJson = Map<String, dynamic>.from(json);
    userJson.remove('token'); // Remove token from user data
    
    print('🔍 [LoginData.fromJson] Parsing user data from same object');
    user = new Data.fromJson(userJson);
    print('🔍 [LoginData.fromJson] User parsed successfully - userId: ${user?.userId}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      // Merge user data and token back together
      final userData = this.user!.toJson();
      userData['token'] = this.token;
      return userData;
    }
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
  String? location;
  String? status;
  String? gender; // Added to store gender from profile.demographics.gender

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
      this.location,
      this.status,
      this.gender});

  Data.fromJson(Map<String, dynamic> json) {
    print('🔍 [Data.fromJson] Starting - JSON keys: ${json.keys.toList()}');
    print('🔍 [Data.fromJson] Full JSON: $json');
    
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    print('🔍 [Data.fromJson] _id value: ${json['_id']}');
    print('🔍 [Data.fromJson] user_id value: ${json['user_id']}');
    print('🔍 [Data.fromJson] Extracted userId: $userId (type: ${userId != null ? userId.runtimeType : "null"})');
    
    // Convert to String if it's not already (for MongoDB ObjectId)
    if (userId != null && userId is! String) {
      userId = userId.toString();
      print('🔍 [Data.fromJson] Converted userId to String: $userId');
    }
    
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image']?.toString() ?? '';
    userRole = json['user_role'];
    authType = json['auth_type'];
    phone = json['phone']?.toString() ?? '';
    deviceToken = json['device_token']?.toString() ?? '';
    location = json['location']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    
    // Parse gender from profile.demographics.gender
    if (json['profile'] != null && json['profile'] is Map<String, dynamic>) {
      final profile = json['profile'] as Map<String, dynamic>;
      if (profile['demographics'] != null && profile['demographics'] is Map<String, dynamic>) {
        final demographics = profile['demographics'] as Map<String, dynamic>;
        gender = demographics['gender']?.toString();
        print('🔍 [Data.fromJson] Extracted gender from profile: $gender');
      }
    }
    
    print('✅ [Data.fromJson] Successfully parsed - userId: $userId, name: $name, role: $userRole, email: $email, gender: $gender');
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
    data['location'] = this.location;
    data['status'] = this.status;
    return data;
  }
}
